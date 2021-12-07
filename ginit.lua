--------------------------------------
-- File: ginit.lua
-- Description: VimR K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.lua
-- Last Modified: 07.12.21 18:23
--------------------------------------


-- Section: Path Settings {
	vim.cmd([[
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/shada/gmain.shada
	set packpath+=~/.config/nvim/pack/
	set path=**
	set shada='20,<50,s10
	set undodir=~/.cache/nvim/tmpr/undo
	]])
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
	local function map(mode, shortcut, command)
		vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = false })
	end

	map('n', '<Leader>e', ':e $NVIMDOTDIR/ginit.lua<CR>')
	map('n', '<Leader>s', ':source $NVIMDOTDIR/ginit.lua<CR>')
-- }

-- Section: Other config files to source {
	require('lsp-config')
	require('plug')
	require('prefs')
	require('vars')
	require('maps')
-- }
