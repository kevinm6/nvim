--------------------------------------
-- File: ginit.lua
-- Description: VimR K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.lua
-- Last Modified: 10/12/21 - 12:30
--------------------------------------


-- Section: VimR FullScreen {
	vim.cmd([[
		function! s:VimRTempMaxWin() abort
			VimRMakeSessionTemporary
			VimRHideTools
			VimRMaximizeWindow
		end
		command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()
	]])
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","

	vim.api.nvim_set_keymap('n', '<Leader>e', ':e $NVIMDOTDIR/ginit.lua<CR>', { noremap = true, silent = false })
	vim.api.nvim_set_keymap('n', '<Leader>s', ':so $NVIMDOTDIR/ginit.lua<CR>', { noremap = true, silent = false })
-- }


-- Section: Other config files to source {
	require('plug')
	require('lsp-config')
	require('prefs')
	require('vars')
	require('maps')
-- }
