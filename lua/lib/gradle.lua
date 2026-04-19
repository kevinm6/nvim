-------------------------------------
-- title: gradle.lua
-- abstract: gradle utils functions
-- author: Kevin
-- date: 19 Apr 2026, 20:43
-------------------------------------

local M = {}

local state = {}

---Get Gradle tasks for the project
---@param gradlew string the path for the gradle
---@param root_dir string? the root directory of the project
local function get_gradle_tasks(gradlew, root_dir)
  gradlew = gradlew and gradlew or M.gradle
  root_dir = root_dir and root_dir or M.root_dir

  local _id = "gradle_"..vim.fs.basename(root_dir)
  if M[_id] and next(M[_id]) then
    return M[_id]
  end

  if not gradlew or gradlew == "" then
    vim.print(gradlew)
    return {}
  end
  M[_id] = {}
  --local out =
  vim.system({ gradlew, "tasks", "--all" }, { text = true }, function(obj)
    if obj.code == 0 then
      for line in obj.stdout:gmatch "[^\r\n]+" do
        if line:find " - " then
          local taskName = line:match "^(.-)%s+-" --line:match("^(.-) -")
          if taskName then
            table.insert(M[_id], taskName)
          end
        end
      end
      -- vim.g["gradle_" .. root_dir] = taskList
    else
      vim.schedule_wrap(function()
        vim.notify("Gradle - error executing command => " .. obj.stderr, vim.log.levels.ERROR, { text = "Gradle (tasks)" })
      end)
    end
  end)--:wait()
  return M[_id]
end

---Run selected Gradle task
---@param gradlew string the path for the gradle executable
---@param task string the task to run
local function run_gradle_task(gradlew, task)
  vim.notify("Gradle => " .. task)
  if state.buf then
    vim.api.nvim_set_option_value("readonly", false, { buf = state.buf })
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, vim.split("   Gradle - running ⟩ " .. task, "\n"))
    vim.api.nvim_set_option_value("readonly", true, { buf = state.buf })
  end
  vim.system({ gradlew, task }, { text = true }, function(obj)
    local out = (obj.code ~= 0) and obj.stderr or obj.stdout

    vim.schedule(function()
      local sep = "---------------------------------"
      local date = os.date("%d %b %Y - %H:%M:%S")
      local text = ("[%q]\n  OUTPUT⟩ gradle %s\n%s\n%s"):format(date, task, sep, out)
      local lines = vim.split(text, "\n")

      if not state.buf then
        state.buf = vim.api.nvim_create_buf(false, true)
      else
        vim.api.nvim_set_option_value("readonly", false, { buf = state.buf })
      end

      vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
      local height = math.floor(vim.o.lines * 0.25)
      if not state.win then
        state.win = vim.api.nvim_open_win(state.buf, true, {
          height = height,
          win = -1,
          split = "below",
        })
      end
      vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.buf })
      vim.api.nvim_set_option_value("swapfile", false, { buf = state.buf })
      vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.buf })
      vim.api.nvim_set_option_value("filetype", "bash", { buf = state.buf })
      vim.api.nvim_set_option_value("readonly", true, { buf = state.buf })
      vim.api.nvim_set_option_value("number", false, { win = state.win })
      vim.api.nvim_set_option_value("relativenumber", false, { win = state.win })

      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = state.buf,
        callback = function()
          state.buf = nil
          state.win = nil
        end
      })

      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = state.buf })
      vim.keymap.set("n", "<esc>",  "<cmd>close<CR>", { buffer = state.buf })
    end)
  end)
end

---Get Gradle tasks for the project
---@param gradlew string the path for gradle
---@param tasks table the list of task
local function select_and_run_gradle_task(gradlew, tasks)
  vim.ui.select(tasks, {
    prompt = "⟩ Gradle task: ",
  }, function(choice)
    if not choice then
      return
    end
    run_gradle_task(gradlew, choice)
  end)
end

---Get tasks completion
---@return table list of tasks
local function get_tasks_completion()
  local _id = "gradle_"..vim.fs.basename(M.root_dir)
  if M[_id] and next(M[_id]) then
    return M[_id]
  end
  return {}
end

---Setup Gradle module
---@param opts table
function M.setup(opts)
  local root_dir = opts.root_dir or vim.uv.cwd()

  local gradle = vim.fn.executable("gradle") and vim.fn.exepath("gradle") or nil
  local gradlew = root_dir .. "/gradlew"

  if vim.fn.executable(gradlew) == 1 then
    gradle = gradlew -- use wrapper if present in cwd
  end

  if not gradle then
    vim.notify("Gradle: no gradle available in cwd and globally", vim.log.levels.WARN, { title = "Gradle" })
    return
  end
  M.root_dir = root_dir
  M.gradle = gradle

  local tasks = get_gradle_tasks(gradle, root_dir)

  vim.api.nvim_create_user_command("Gradle", function(input)
    local task = nil
    if input.args ~= "" then
      task = input.args
      run_gradle_task(gradle, task)
    else
      select_and_run_gradle_task(gradle, tasks)
    end
  end, {
    nargs = "?",
    complete = get_tasks_completion
  })

  vim.keymap.set("n", "<leader>dg", function()
    select_and_run_gradle_task(gradle, tasks)
  end, { desc = "Gradle", buffer = true })
end

return M