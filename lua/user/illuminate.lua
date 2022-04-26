-----------------------------------
--	File         : illuminate.lua
--	Description  : illuminate plugin config
--	Author       : Kevin
--	Last Modified: 18/03/2022 - 16:25
-----------------------------------


-- vim.g.Illuminate_delay = 0
-- vim.g.Illuminate_highlightUnderCursor = 0
vim.g.Illuminate_ftblacklist = { "alpha", "Scratch", "NvimTree" }
vim.api.nvim_set_keymap("n", "<C-n>", '<cmd>lua require("illuminate").next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap("n", "<C-p>", '<cmd>lua require("illuminate").next_reference{reverse=true,wrap=true}<cr>', {noremap=true})

