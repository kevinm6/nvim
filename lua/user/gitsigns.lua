-------------------------------------
-- File: gitsigns.lua
-- Description: Lua K NeoVim & VimR gitsigns config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/gitsigns.lua
-- Last Modified: 13/12/21 - 16:00
-------------------------------------


local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
	return
end

gitsigns.setup {
	signs = {
		add = {
			hl = 'GitSignsAdd',	text = '+',
			numhl='GitSignsAddNr', linehl='GitSignsAddLn'
		},
		change = {
			hl = 'GitSignsChange', text = '\\', 
			numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'
		},
		delete = {
			hl = 'GitSignsDelete', text = '_',
			numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
		},
		topdelete = {
			hl = 'GitSignsDelete', text = '‾',
			numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
		},
		changedelete = {
			hl = 'GitSignsChange', text = '~',
			numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
		},
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
}

