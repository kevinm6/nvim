-----------------------------------
--	File         : illuminate.lua
--	Description  : illuminate plugin config
--	Author       : Kevin
--	Last Modified: 01 Jul 2022, 08:59
-----------------------------------

-- I'm not create an autocmd since it is working
--  whithout, called by lsp setup for every client
-- The highlights are linked to LspReference{Text/Write/Read}

-- vim.g.Illuminate_delay = 0
-- vim.g.Illuminate_highlightUnderCursor = 0
vim.g.Illuminate_ftblacklist = { "alpha", "Scratch", "NvimTree", "DressingSelect" }
vim.api.nvim_set_keymap("n", "<C-n>", '<cmd>lua require("illuminate").next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap("n", "<C-p>", '<cmd>lua require("illuminate").next_reference{reverse=true,wrap=true}<cr>', {noremap=true})

