-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra confi
-- Author       : Kevin
-- Last Modified: 10 Jan 2023, 10:20
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 100
vim.opt_local.foldmethod = "syntax"
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "tcroqln"
vim.opt_local.comments:append { "nb:+", "nb:>", "nb:-", "nb:." }

vim.opt.spell = false
vim.opt.spellfile = "/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"

-- Add custom mappings only for markdown files

vim.keymap.set("n", "<leader>mp", function() require "peek".open() end, { desc = "Open Peek preview" })

vim.keymap.set("n", "<leader>mP", function() require "peek".close() end, { desc = "Close Peek preview" })

vim.keymap.set("n", "<leader>mm", function() vim.cmd.Glow() end, { desc = "Floating Markdown Preview (Glow)" })
