-------------------------------------
--  File         : ufo.lua
--  Description  : ufo plugin configuration (folding)
--  Author       : Kevin
--  Last Modified: 29 Jun 2022, 09:45
-------------------------------------

local ok, ufo = pcall(require, "ufo")
if not ok then return end

vim.wo.foldcolumn = '1'
vim.wo.foldlevel = 99
vim.wo.foldenable = true

ufo.setup()
