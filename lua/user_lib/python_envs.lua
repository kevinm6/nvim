-------------------------------------
--  File         : python_envs.lua
--  Description  : helper module to get and manage python_envs
--  Author       : Kevin
--  Last Modified: 23 Jun 2023, 09:27
-------------------------------------

-- Python envs
--  Available funcs:
--    - get_current_venv
--    - pick_venv
local P = {}

-- Python Venv
local set_venv = function(venv)
   local ORIGINAL_PATH = vim.fn.getenv "PATH"
   local venv_bin_path = venv.path .. "/bin"
   vim.fn.setenv("PATH", venv_bin_path .. ":" .. ORIGINAL_PATH)
   vim.fn.setenv("VIRTUAL_ENV", venv.path)
end

P.get_current_venv = function()
   return vim.g.python_venv
end

local get_venvs = function(venvs_path)
   local success, Path = pcall(require, "plenary.path")
   if not success then
      vim.notify("Could not require plenary: " .. Path, vim.log.levels.WARN)
      return
   end
   -- local scan_dir = require("plenary.scandir").scan_dir

   local paths = venvs_path -- scan_dir(venvs_path, { depth = 1, only_dirs = true })
   local venvs = {}
   for _, path in ipairs(paths) do
      table.insert(venvs, {
         name = Path:new(path):make_relative(vim.fn.expand "~/"),
         path = path,
      })
   end
   return venvs
end

P.pick_venv = function()
   local venvs_paths = {
      vim.fn.expand "~/dev/audioToText-bot",
      vim.fn.stdpath "data" .. "nvim_python_venv",
   }

   vim.ui.select(get_venvs(venvs_paths), {
      prompt = "Select python venv",
      format_item = function(item)
         return ("%s (%s)"):format(item.name, item.path)
      end,
   }, function(choice)
      if not choice then
         return
      end
      set_venv(choice)
   end)
end

return P
