-------------------------------------
--  File         : init.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 31 Dec 2025, 16:46
-------------------------------------

local M = {}

---toggle_option()
---@param option string option to toggle value
function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify("Opts - " .. option .. " set to " .. tostring(value), vim.log.levels.INFO)
end

---Dev FOLDER
function M.dev_folder()
  local dev_folders = {
    vim.fn.expand "~/dev",
    vim.fn.expand "~/Documents/developer",
  }
  vim.ui.select(dev_folders, {
    prompt = " > Select dev folder",
    default = nil,
  }, function(choice)
    if choice then
      local has_mini, mini_files = pcall(require, "mini.files")
      if has_mini then
        mini_files.open(choice)
      else
        vim.cmd.edit(choice)
      end
    end
  end)
end

---Find Files
function M.find_files()
  local has_snacks, snacks = pcall(require, "snacks.picker")
  if has_snacks then
    snacks.files()
  else
    local files = vim.fn.glob(vim.uv.cwd() .. "**/**", true, true)

    vim.ui.select(files, {
      prompt = " > Open file",
      default = nil,
    }, function(choice)
      if choice then
        vim.cmd.edit(choice)
      end
    end)
  end
end

---Recent Files
function M.recent_files()
  local has_snacks, snacks = pcall(require, "snacks.picker")
  if has_snacks then
    snacks.recent()
  else
    local oldfiles = {}
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buffer)
    for idx, file in ipairs(vim.v.oldfiles) do
      local file_stat = vim.loop.fs_stat(file)
      if file_stat and file_stat.type == "file" and not vim.tbl_contains(oldfiles, file) and file ~= current_file then
        table.insert(oldfiles, file)
      end
      if idx > 20 then
        break
      end -- get only 20 results
    end

    vim.ui.select(oldfiles, {
      prompt = " > Open recent files",
      default = nil,
    }, function(choice)
      if choice then
        vim.cmd.edit(choice)
      end
    end)
  end
end

---Projects
function M.projects()
  local projs_folders = {
    vim.fn.expand "~/Documents/developer",
    vim.fn.expand "~/dev",
    vim.fn.expand "~/uni",
    vim.fn.expand "~/Informatica)",
  }

  local has_snacks, snacks = pcall(require, "snacks.picker")
  if not has_snacks then
    local projects = {}
    for _, value in pairs(projs_folders) do
      vim.list_extend(projects, vim.split(vim.fn.glob(value .. "/*", true), "\n"))
    end

    vim.ui.select(projects, {
      prompt = " > Select project",
      default = nil,
      format_item = function(item)
        return not vim.endswith(item, "Icon\r") and vim.fn.fnamemodify(item, ":t") or ""
      end,
    }, function(choice)
      if choice then
        vim.cmd.tcd(choice)
        vim.notify("Projects - twd => " .. choice, vim.log.levels.INFO)
        local has_mini, mini_files = pcall(require, "mini.files")
        if has_mini then
          mini_files.open(choice)
        else
          vim.cmd.edit(choice)
        end
      end
    end)
  else
    snacks.projects {
      dev = projs_folders,
      patterns = { ".git", ".svn", "README.md", "*.xls" },
    }
  end
end

---Delete current buffer and view next
function M.delete_curr_buf_open_next()
  local cBuf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo { buflisted = 1 } or {}
  if #bufs ~= 0 then
    for idx, buf in ipairs(bufs) do
      if buf.bufnr == cBuf then
        if idx == #bufs then
          vim.cmd.bprevious {}
        else
          vim.cmd.bnext {}
        end
        break
      end
    end
  else
    return
  end
  vim.api.nvim_buf_delete(cBuf, { force = true })
end

---Create new file w/ input for filename
---useful for dashboard and so on
---@param cmd_input? vim.api.keyset.create_user_command.command_args file name\[.ext\] that it will be passed to vim.cmd.edit
function M.new_file(cmd_input)
  local args = cmd_input and cmd_input.args or nil
  if args == nil or args == "" then
    vim.ui.input({
      prompt = "Enter name[.ext] for newfile: ",
      default = nil,
      completion = "dir",
    }, function(input)
      if not input or input == "" then
        return
      end
      input = vim.trim(input)

      if input then
        vim.cmd.enew()
        vim.cmd.tcd(vim.fn.fnamemodify(input, ":p:h"))
        vim.cmd.edit(input)
        vim.cmd.write(input)
        vim.cmd.startinsert()
      end
    end)
  else
    vim.cmd.enew()
    vim.cmd.tcd(vim.fn.fnamemodify(args, ":p:h"))
    vim.cmd.edit(args)
    vim.cmd.write(args)
    vim.cmd.startinsert()
  end
end

---Create temporary file
---@param cmd_input? vim.api.keyset.create_user_command.command_args file extension without dot prefixed
function M.new_tmp_file(cmd_input)
  local args = cmd_input and cmd_input.args or nil
  if args == nil or args == "" then
    vim.ui.input({
      prompt = "Enter ext for temp file: ",
      default = nil,
      completion = "filetype",
    }, function(input)
      if not input then
        return
      end
      local temp_file = nil
      local f_string = input ~= "" and "%s_f.%s" or "%s_f"

      temp_file = f_string .. vim.fn.tempname() .. input
      -- vim.cmd.tcd(vim.fn.fnamemodify(vim.fn.tempname(), ":p:h"))
      vim.cmd.edit(temp_file)
      vim.cmd.write(temp_file)
      vim.cmd.startinsert()
    end)
  else
    local temp_file = vim.fn.tempname() .. "_f." .. args
    -- vim.cmd.tcd(vim.fn.fnamemodify(temp_file, "%:p:h"))
    vim.cmd.edit(temp_file)
    vim.cmd.write(temp_file)
    vim.cmd.startinsert()
  end
end

function M.workon()
  local config = require "lazy.core.config"
  vim.ui.select(vim.tbl_values(config.plugins), {
    prompt = "lcd to:",
    format_item = function(plugin)
      return plugin.name .. " (" .. plugin.dir .. ")"
    end,
  }, function(plugin)
    if not plugin then
      return
    end
    vim.schedule(function()
      vim.cmd.lcd(plugin.dir)
    end)
  end)
end

---Set highlights
---@param hls table
---@see nvim_set_hl |nvim_set_hl()|
function M.set_highlights(hls)
  for group, settings in pairs(hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

---Shift registers
---@param reg Register
---@class Register
function M.shift_reg(reg)
  for i = 8, 1, -1 do
    local str_reg = tostring(i)
    vim.fn.setreg(tostring(i + 1), vim.fn.getreg(str_reg), vim.fn.getregtype(str_reg))
  end
  vim.fn.setreg("1", reg.val, reg.typ)
end

---Run Brew service
---@param service string name of the brew service
---@param async boolean run sync | async
function M.run_brew_service(service, async)
  -- Stop brew services just before exiting Nvim
  -- I put this here so is created only when starting the service from the autocmd
  -- above (when loading this plugin), if done outside Nvim or without this plugin
  -- the brew services still run as expected
  local function autocmd_stop_service()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        vim.system({ "brew", "services", "stop", service }, { text = true, timeout = 6000 }):wait()
      end,
    })
  end

  if async then
    vim.notify("Brew Services - creating async service")
    vim.system({ "brew", "services", "run", service }, { text = true, timeout = 6000 }, function(obj)
      vim.notify("Brew Services - stdout => " .. obj.stdout, vim.log.levels.INFO, { title = "Brew Services" })

      if obj.code ~= 0 then
        vim.notify("Brew Services - stderr => " .. obj.stderr, vim.log.levels.WARN)
      else
        autocmd_stop_service()
      end
    end)
  else
    local job = vim.system({ "brew", "services", "run", service }, { text = true }):wait(6000)

    if job.code ~= 0 then
      vim.notify("Brew Services - stderr => " .. job.stderr, vim.log.levels.WARN)
    else
      vim.notify("Brew Services - stdout => " .. job.stdout, vim.log.levels.INFO, { title = "Brew Services" })
      autocmd_stop_service()
    end
  end
end

---Create a toggle user command
---@param name string name of the user_command
---@param var_name string variable passed to `vim.g` and `vim.b`
---@param opts? table { desc?, title?, fun on_enable?, fun on_disable? }
function M.user_command_toggle(name, var_name, opts)
  vim.api.nvim_create_user_command(name, function(args)
    local enabled, action = nil, nil

    -- this is for match variables names with `disable` logic
    local var_name_disable = string.match(var_name, "disable")

    -- ToggleAutoPairs! will disable pairs just for this buffer
    if args.bang then
      local buf = vim.api.nvim_get_current_buf()

      vim.b[buf][var_name] = not vim.b[buf][var_name]

      local buf_name_tail = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      action = ("%s < %s >"):format(action, buf_name_tail)

      -- if (var_name_disable*) -> ON = not enabled, OFF = enabled
      -- This is a tricky variable, especially when variable names contains 'disable'
      -- I use it for run functions on toggle{on,off} and display relative notification
      enabled = false
      if vim.b[buf][var_name] then -- var -> ON
        if not var_name_disable then
          enabled = true
        end
      else -- var -> OFF
        if var_name_disable then
          enabled = true
        end
      end
    else
      vim.g[var_name] = not vim.g[var_name]

      enabled = false
      if vim.g[var_name] then -- var -> ON
        if not var_name_disable then
          enabled = true
        end
      else -- var -> OFF
        if var_name_disable then
          enabled = true
        end
      end
    end

    if enabled and opts and opts.on_enable then
      if type(opts.on_enable) == "function" then
        opts.on_enable()
      end
    elseif not enabled and opts and opts.on_disable then
      if type(opts.on_disable) == "function" then
        opts.on_disable()
      end
    end

    action = enabled and "  ON" or "  OFF"
    local log_level = enabled and vim.log.levels.INFO or vim.log.levels.WARN

    vim.notify("Usercommand Toggle - " .. action, log_level, {
      render = "wrapped-compact",
      title = opts and opts.title,
    })
  end, {
    desc = opts and opts.desc,
    bang = true,
  })
end

---Get text from current selection
function M.get_selection_text()
  local top, bot = vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">")
  local text = vim.api.nvim_buf_get_text(0, top[1], top[2], bot[1], bot[2], {})
  return table.concat(text)
end

---TODO: define on nvim-0.11
-- function M.detaching()
--   local addr = vim.v.servername
--   -- save into file in stdpath 'state'
--   local save_addr_path = vim.fn.stdpath "state" .. "/nvim_server_addr"
-- end

return M