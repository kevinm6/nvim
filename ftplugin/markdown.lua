---------------------------------------------------
-- File: markdown.lua
-- Description: Filetype markdown specific settings in Lua
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.lua
-- Last Modified: 10/12/21 - 11:25
---------------------------------------------------

-- Only do this when not done yet for this buffer
if vim.fn.exists("b:ftplugin_markdown") == 1 then
	  return
end
vim.b.ftplugin_markdown = 1

vim.opt.conceallevel = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.cindent = true
vim.opt.spelllang = { 'en_US', 'it_IT' }

