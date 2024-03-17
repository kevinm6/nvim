-------------------------------------
--  File         : utils.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 20 Mar 2024, 17:35
-------------------------------------

local M = {}

---Hot-reloading source plugin/module
---@param mod any
---@return any, any
M.reload_module = function(mod)
  mod = mod:gsub('/', '.'):gsub('%.lua$', '')
  package.loaded[mod] = nil
  return require(mod)
end


---toggle_option()
---@param option string option to toggle value
M.toggle_option = function(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value), vim.log.levels.INFO)
end

---Enable|Disable Diagnostics
M.toggle_diagnostics = function()
  vim.g.diagnostics_status = not vim.g.diagnostics_status
  if vim.g.diagnostics_status == true then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end


---Dev FOLDER
M.dev_folder = function()
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


---Projects
M.projects = function()
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


---Create new file w/ input for filename
---useful for dashboard and so on
M.new_file = function(cmd_input)
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
M.new_tmp_file = function(cmd_input)
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


M.workon = function()
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
M.set_highlights = function(hls)
  for group, settings in pairs(hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end


---Get current buf lsp Capabilities
---@see nvim_lsp_get_active_clients |nvim_lsp_get_active_clients()|
M.get_current_buf_lsp_capabilities = function()
  local curBuf = vim.api.nvim_get_current_buf()
  -- TODO: remove check for nvim-0.10 when update to it
  local clients = vim.fn.has("nvim-0.10") == 1 and vim.lsp.get_clients() or
  vim.lsp.get_active_clients { bufnr = curBuf }

  for _, client in pairs(clients) do
    if client.name ~= "null-ls" then
      local capAsList = {}
      for key, value in pairs(client.server_capabilities) do
        if value and key:find "Provider" then
          local capability = key:gsub("Provider$", "")
          table.insert(capAsList, "- " .. capability)
        end
      end
      table.sort(capAsList)    -- sorts alphabetically
      local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
      vim.notify(msg, vim.log.levels.INFO, {
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.fn.has("nvim-0.10") == 1 then
            vim.api.nvim_set_option_value("filetype", "markdown",
              { buf = buf, scope = 'local' })
          else
            vim.api.nvim_set_option_value("filetype", "markdown", { bufnr = buf })
          end
        end,
        timeout = 14000,
      })
      vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
    end
  end
end


M.usercmd_session_completion = function()
  local args = { 'restore', 'save', 'delete' }
  return table.concat(args, "\n")
end

return M