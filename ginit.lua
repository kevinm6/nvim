--------------------------------------
-- File: ginit.lua
-- Description: VimR K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.lua
-- Last Modified: 08.12.21 19:31
--------------------------------------

-- Section: Path Settings {
	-- vim.cmd ([[set rtp+=~/.config/nvim]])
		-- vim.cmd ([[
		-- 	set viminfo+=n~/.local/share/nvim/shada/gmain.shada
		-- 	set packpath+=~/.config/nvim/pack
		-- 	set shada='20,<50,s10
		-- 	set path=**
		-- 	set undodir=~./.cache/nvim/tmpr/undo
		-- ]])
-- }


-- Section: VimR FullScreen {
		-- function! s:VimRTempMaxWin() abort
		-- 	VimRMakeSessionTemporary    -- The tools, tool buttons and window settings are not persisted
			-- VimRHideTools
			-- VimRMaximizeWindow
		-- end
		-- command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()
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
