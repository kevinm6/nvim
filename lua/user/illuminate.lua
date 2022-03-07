-----------------------------------
--	File: illuminate.lua
--	Description: illuminate plugin config
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/illuminate.lua
--	Last Modified: 07/03/2022 - 20:59
-----------------------------------

-- vim.g.Illuminate_delay = 0
-- vim.g.Illuminate_highlightUnderCursor = 0
-- vim.g.Illuminate_ftblacklist = {'html'}
vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})

