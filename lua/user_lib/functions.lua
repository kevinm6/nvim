-------------------------------------
--  File         : functions.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 02 Oct 2023, 17:06
-------------------------------------

local F = {}

---Hotloading source plugin/module
---@param mod any
---@return any, any
F.load = function(mod)
   package.loaded[mod] = nil
   return require(mod)
end

--- Remove augroup, if exists from given name
--- @param name string name of matching augroup to remove
F.remove_augroup = function(name)
   if vim.fn.exists("#" .. name) == 1 then
      vim.cmd("au! " .. name)
   end
end

--- Get lenght of current word
--- @see cword |<cword>|
F.get_word_length = function()
   local word = vim.fn.expand "<cword>"
   return #word
end

--- toggle_option()
--- @param option string option to toggle value
F.toggle_option = function(option)
   local value = not vim.api.nvim_get_option_value(option, {})
   vim.opt[option] = value
   vim.notify(option .. " set to " .. tostring(value), vim.log.levels.INFO)
end

--- Enable|Disable Diagnostics
F.toggle_diagnostics = function()
   vim.g.diagnostics_status = not vim.g.diagnostics_status
   if vim.g.diagnostics_status == true then
      vim.diagnostic.show()
   else
      vim.diagnostic.hide()
   end
end


--- Dev FOLDER
F.dev_folder = function()
   local dev_folders = {
      vim.fn.expand "~/dev",
      vim.fn.expand "~/Documents/developer",
   }
   require "telescope"
   vim.ui.select(dev_folders, {
      prompt = " > Select dev folder",
      default = nil,
   }, function(choice)
      if choice then
         require("telescope").extensions.file_browser.file_browser { cwd = choice }
      end
   end)
end


--- Create new file w/ input for filename
--- useful for dashboard and so on
F.new_file = function()
   vim.ui.input({
      prompt = "Enter name for newfile: ",
      default = nil,
   }, function(input)
      if input then
         vim.cmd.enew()
         vim.cmd.edit(input)
         vim.cmd.write(input)
         vim.cmd.startinsert()
      end
   end)
end

--- Create temporary file
F.new_tmp_file = function()
   vim.ui.input({
      prompt = "Enter ext for temp file: ",
      default = ".",
   }, function(input)
      if input then
         local temp_file = vim.fn.tempname() .. input
         vim.cmd.edit(temp_file)
         vim.cmd.write(temp_file)
         vim.cmd.startinsert()
      end
   end)
end


F.workon = function()
   require "telescope"
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

--- Set highlights
--- @param hls table
--- @see nvim_set_hl |nvim_set_hl()|
F.set_highlights = function(hls)
   for group, settings in pairs(hls) do
      vim.api.nvim_set_hl(0, group, settings)
   end
end


--- Get current buf lsp Capabilities
--- @see nvim_lsp_get_active_clients |nvim_lsp_get_active_clients()|
F.get_current_buf_lsp_capabilities = function()
   local curBuf = vim.api.nvim_get_current_buf()
   local clients = vim.lsp.get_active_clients { bufnr = curBuf }

   for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
         local capAsList = {}
         for key, value in pairs(client.server_capabilities) do
            if value and key:find "Provider" then
               local capability = key:gsub("Provider$", "")
               table.insert(capAsList, "- " .. capability)
            end
         end
         table.sort(capAsList) -- sorts alphabetically
         local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
         vim.notify(msg, vim.log.levels.INFO, {
            on_open = function(win)
               local buf = vim.api.nvim_win_get_buf(win)
               vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            end,
            timeout = 14000,
         })
         vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
      end
   end
end

return F
