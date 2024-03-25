-------------------------------------
--  File         : utils.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 25 Mar 2024, 15:41
-------------------------------------

local utils = {}

---toggle_option()
---@param option string option to toggle value
function utils.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value), vim.log.levels.INFO)
end


---Dev FOLDER
function utils.dev_folder()
  local dev_folders = {
    vim.fn.expand "~/dev",
    vim.fn.expand "~/Documents/developer",
  }
  local _, _ = pcall(require, "telescope")
  vim.ui.select(dev_folders, {
    prompt = " > Select dev folder",
    default = nil,
  }, function(choice)
    if choice then
      local has_oil, oil = pcall(require, "oil")
      if has_oil then
        oil.open_float(choice)
      else
        vim.cmd.edit(choice)
      end
    end
  end)
end


---Find Files
function utils.find_files()
  local has_tele, tele_builtin = pcall(require, "telescope.builtin")
  if has_tele then
    tele_builtin.find_files()
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
function utils.recent_files()
  local has_tele, tele_builtin = pcall(require, "telescope.builtin")
  if has_tele then
    tele_builtin.oldfiles()
  else
    local oldfiles = {}
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buffer)
    for idx, file in ipairs(vim.v.oldfiles) do
      local file_stat = vim.loop.fs_stat(file)
      if file_stat and file_stat.type == "file" and not vim.tbl_contains(oldfiles, file) and file ~= current_file then
        table.insert(oldfiles, file)
      end
      if idx > 20 then break end -- get only 20 results
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
function utils.projects()
  local projs_folders = {
    vim.fn.expand "~/Documents/developer",
    vim.fn.expand "~/dev",
    vim.fn.expand "~/uni",
  }
  local projects = {}
  for _, value in pairs(projs_folders) do
    vim.list_extend(projects, vim.split(vim.fn.glob(value .. "/*", true), "\n"))
  end

  local _, _ = pcall(require, "telescope")
  vim.ui.select(projects, {
    prompt = " > Select project",
    default = nil,
    format_item = function(item)
      return not vim.endswith(item, "Icon\r") and vim.fn.fnamemodify(item, ":t")
    end
  }, function(choice)
    if choice then
      local has_oil, oil = pcall(require, "oil")
      if has_oil then
        oil.open_float(choice)
      else
        vim.cmd.edit(choice)
      end
    end
  end)
end


---Delete current buffer and view next
function utils.delete_curr_buf_open_next()
  local cBuf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 }) or {}
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
  vim.cmd.bdelete(cBuf)
end

---Create new file w/ input for filename
---useful for dashboard and so on
---@param cmd_input string file name\[.ext\] that it will be passed to vim.cmd.edit
function utils.new_file(cmd_input)
  local args = cmd_input and cmd_input.args or nil
  if args == nil or args == "" then
    vim.ui.input({
      prompt = "Enter name[{ext}] for newfile: ",
      default = nil,
      completion = 'filetype'
    }, function(input)
      if input then
        vim.cmd.enew()
        vim.cmd.edit(input)
        vim.cmd.write(input)
        vim.cmd.startinsert()
      end
    end)
  else
    vim.cmd.enew()
    vim.cmd.edit(args)
    vim.cmd.write(args)
    vim.cmd.startinsert()
  end
end

---Create temporary file
---@param cmd_input string file extension without dot prefixed
function utils.new_tmp_file(cmd_input)
  local args = cmd_input and cmd_input.args or nil
  if args == nil or args == "" then
    vim.ui.input({
      prompt = "Enter ext for temp file: ",
      default = nil,
      completion = 'filetype'
    }, function(input)
      if input then
        local temp_file = ("%s.%s"):format(vim.fn.tempname(), input)
        vim.cmd.edit(temp_file)
        vim.cmd.write(temp_file)
        vim.cmd.startinsert()
      end
    end)
  else
    local temp_file = ("%s.%s"):format(vim.fn.tempname(), args)
    vim.cmd.edit(temp_file)
    vim.cmd.write(temp_file)
    vim.cmd.startinsert()
  end
end


function utils.workon()
  local _, _ = pcall(require, "telescope")
  local config = require "lazy.core.config"
  vim.ui.select(vim.tbl_values(config.plugins), {
    prompt = "lcd to:",
    format_item = function(plugin)
      return string.format("%s (%s)", plugin.name, plugin.dir)
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
function utils.set_highlights(hls)
  for group, settings in pairs(hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end


---Set 'keywordprg' based on filetype
---@param filetype string filetype that triggered the autocmd
---@return string | nil
function utils.set_keywordprg(filetype)
  local custom_keywordprg = {
    python = 'python3 -m pydoc',
    vim = ':help',
    html = "open https://developer.mozilla.org/search?topic=api&topic=html&q=",
    css = "open https://developer.mozilla.org/search?topic=api&topic=css&q=",
    javascript = "open https://developer.mozilla.org/search?topic=api&topic=js&q="
  }

  return custom_keywordprg[filetype]
end

return utils