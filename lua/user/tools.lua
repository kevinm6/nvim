-------------------------------------
-- File: tools.lua
-- Description: K utility tools
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/tools.lua
-- Last Modified: 22/12/21 - 08:53
-------------------------------------

local M = {}
function M.makeScratch()
	vim.api.nvim_command [[enew]]
	vim.opt.buftype = 'nofile'
	vim.opt.bufhidden = 'hide'
	vim.opt.nobuflisted = true
	vim.opt.swapfile = false
end
return M
