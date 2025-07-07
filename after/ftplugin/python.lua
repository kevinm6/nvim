-------------------------------------
-- File         : python.lua
-- Description  : filetype python extra config
-- Author       : Kevin
-- Last Modified: 10 Apr 2024, 10:08
-------------------------------------

vim.opt_local.expandtab = true
vim.opt_local.autoindent = true

vim.opt_local.makeprg = "python3 -u"
vim.opt_local.errorformat = '%C %.%#,%A  File "%f"\\, line %l%.%#,%Z%[%^ ]%\\@=%m'
vim.opt_local.keywordprg = "python3 -m pydoc"

-- Add custom mappings only for python files
vim.keymap.set("n", "<localleader>pv", function()
  require "lib.python_envs".pick_venv()
end, { desc = "Pick Python Venv" })

vim.api.nvim_create_user_command("Pyvenv", function(arg)
  if arg.args ~= "" then
    -- if arg.args == "current_dir" then
    --   venv = require "lib.python_envs".current_dir
    -- else
    --   venv = {
    --     name = vim.fn.fnamemodify(arg.args, ":t"),
    --     path = string.format("%s/%s", vim.uv.cwd(), vim.fn.expand(arg.args))
    --   }
    -- end
    require "lib.python_envs".set_venv(arg.args)
  else
    require "lib.python_envs".pick_venv()
  end
end, {
  nargs = "?",
  desc = "Python Venv",
  complete = "custom,v:lua.require'lib.python_envs'.usercmd_pyenv_completion"
})