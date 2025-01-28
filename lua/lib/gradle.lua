-------------------------------------
--  File         : gradle.lua
--  Description  : gradle utils functions
--  Author       : Kevin
--  Last Modified: 06/01/2025 - 12:19
-------------------------------------

local M = {}

---Get Gradle tasks for the project
---@param gradlew string the path for the gradle
---@param root_dir string the root directory of the project
local function get_gradle_tasks(gradlew, root_dir)
  if vim.g["gradle_" .. root_dir] ~= nil then
    return vim.g["gradle_" .. root_dir]
  end

  local taskList = {}
  local out = vim.system({ gradlew, "tasks", "--all" }, { text = true }):wait()
  if out.code == 0 then
    for line in out.stdout:gmatch "[^\r\n]+" do
      if line:find " - " then
        local taskName = line:match "^(.-)%s+-" --line:match("^(.-) -")
        if taskName then
          table.insert(taskList, taskName)
        end
      end
    end
    vim.g["gradle_" .. root_dir] = taskList
  else
    vim.notify("Error executing command: " .. out.stderr, vim.log.levels.ERROR, { text = "Gradle (tasks)" })
  end
  return taskList
end

local function run_gradle_task(gradlew, task)
  -- local msg = string.format(" < gradlew %s >", task)
  -- vim.notify(msg, 2, { title = "Gradle" })
  print("Gradle⟩ " .. task)
  vim.system({ gradlew, task }, { text = true }, function(obj)
    local out = (obj.code ~= 0) and obj.stderr or obj.stdout

    vim.schedule(function()
      local sep = "---------------------------------"
      local text = string.format("   OUTPUT⟩ gradle %s\n%s\n%s", task, sep, out)
      local lines = vim.split(text, "\n")

      local buf = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      local height = math.floor(vim.o.lines * 0.25)
      local win = vim.api.nvim_open_win(buf, true, {
        height = height,
        win = -1,
        split = "below",
      })
      vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
      vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
      vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
      vim.api.nvim_set_option_value("filetype", "sh", { buf = buf })
      vim.api.nvim_set_option_value("number", false, { win = win })
      vim.api.nvim_set_option_value("relativenumber", false, { win = win })

      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
      vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = buf })
    end)
  end)
end

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

---Setup Gradle module
---@param opts table
function M.setup(opts)
  local root_dir = opts.root_dir or nil

  if not root_dir then
    vim.notify("root_dir not passed!", vim.log.levels.ERROR, { title = "Gradle" })
    return
  end

  if not vim.fn.filereadable(root_dir .. "/gradlew") then
    vim.notify("No gradlew bin found for the path\n" .. root_dir, vim.log.levels.WARN, { title = "Gradle" })
    return
  end

  local gradlew = root_dir .. "/gradlew"

  vim.api.nvim_create_user_command("Gradle", function(input)
    local task = nil
    if input.args ~= "" then
      run_gradle_task(gradlew, task)
    else
      local tasks = get_gradle_tasks(gradlew, root_dir)
      select_and_run_gradle_task(gradlew, tasks)
    end
  end, {
    nargs = "?",
    complete = get_gradle_tasks,
  })

  vim.keymap.set("n", "<leader>dg", function()
    local tasks = get_gradle_tasks(gradlew, root_dir)
    select_and_run_gradle_task(gradlew, tasks)
  end, { desc = "Gradle", buffer = true })
end

return M