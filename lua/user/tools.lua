-------------------------------------
-- File: tools.lua
-- Description: K utility tools
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/tools.lua
-- Last Modified: 13/12/21 - 19:12
-------------------------------------

local M = {}
function M.makeScratch()
	vim.api.nvim_command [[enew]]
	noswapfile hide enew
	set.buftype = 'nofile'
	set.bufhidden = 'hide'
	set.nobuflisted = true
	set.swapfile = false
end
return M
