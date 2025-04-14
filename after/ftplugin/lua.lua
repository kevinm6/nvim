-------------------------------------
-- File         : lua.lua
-- Description  : Lua filetype extra config
-- Author       : Kevin
-- Last Modified: 19/01/2025 - 10:15
-------------------------------------

vim.opt_local.makeprg = "nvim -l"
vim.opt_local.errorformat = "%f"

vim.keymap.set("n", "<leader>r", "<cmd>lua<CR>", { desc = "Execute current line", buffer = true })
vim.keymap.set("n", "<leader>R", "<cmd>% lua<CR>", { desc = "Execute the current file", buffer = true })
vim.keymap.set("x", "<leader>r", ":'<,'>lua<CR>", { desc = "Execute current selection", buffer = true })