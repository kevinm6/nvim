-------------------------------------
--  File         : python_envs.lua
--  Description  : helper module to get and manage python_envs
--  Author       : Kevin
--  Last Modified: 25 Jun 2023, 11:24
-------------------------------------

--- Python envs
---  Available funcs:
---    - get_current_venv
---    - pick_venv
local P = {}

--- Set Python venv
--- @private
--- @param venv table set this venv as current python venv
P.set_venv = function(venv)
   local ORIGINAL_PATH = vim.fn.getenv "PATH"
   local venv_bin_path = venv.path .. "/bin"
   if vim.fn.isdirectory(venv_bin_path) == 1 then
      vim.fn.setenv("PATH", venv_bin_path .. ":" .. ORIGINAL_PATH)
      vim.fn.setenv("VIRTUAL_ENV", venv.path)
   else
      vim.notify("ERROR: Given path is not a python venv!", vim.log.levels.ERROR, {
         title = "Python Venv"
      })
   end
end

--- Get active Python venv
--- @return string|nil _ current active python venv or nothing
P.get_current_venv = function()
   return vim.g.python_venv
end

--- Get Python venvs from given paths
--- @private
--- @param venvs_path table list of paths of python venvs
--- @return table|nil
local get_venvs = function(venvs_path)
   local success, Path = pcall(require, "plenary.path")
   if not success then
      vim.notify("Could not require plenary: " .. Path, vim.log.levels.WARN)
      return
   end

   local paths = venvs_path
   local venvs = {}
   for _, path in ipairs(paths) do
      table.insert(venvs, {
         name = Path:new(path):make_relative(vim.fn.expand "~/"),
         path = path,
      })
   end
   return venvs
end

--- Show a picker for select Python venv
--- and make it active
P.pick_venv = function()
   local venvs_paths = {
      vim.fn.expand "~/dev/audioToText-bot",
      vim.fn.stdpath "data" .. "/nvim_python_venv",
   }

   vim.ui.select(get_venvs(venvs_paths), {
      prompt = "Select Python venv",
      format_item = function(item)
         local name = vim.fn.fnamemodify(item.name, ":t")
         return ("%s (%s)"):format(name, item.path)
      end,
   }, function(choice)
      if not choice then
         return
      end
      P.set_venv(choice)
   end)
end

return P
