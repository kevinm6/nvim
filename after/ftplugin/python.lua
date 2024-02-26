-------------------------------------
-- File         : python.lua
-- Description  : filetype python extra config
-- Author       : Kevin
-- Last Modified: 26 Feb 2024, 21:09
-------------------------------------

vim.opt_local.expandtab = true
vim.opt_local.autoindent = true

-- Add custom mappings only for python files
vim.keymap.set("n", "<leader>pv", function()
   require "lib.python_envs".pick_venv()
end, { desc = "Pick Python Venv" })

vim.api.nvim_create_user_command("Pyvenv", function(arg)
   if arg.args ~= "" then
      local venv = {
         name = vim.fn.fnamemodify(arg.args, ":t"),
         path = string.format("%s/%s", vim.uv.cwd(), vim.fn.expand(arg.args))
      }
      require "lib.python_envs".set_venv(venv)
   else
      require "lib.python_envs".pick_venv()
   end
end, {
   nargs = "?",
   desc = "Python Venv",
   complete = "dir"
})
