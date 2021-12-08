--------------------------------------
-- File: ginit.lua
-- Description: VimR K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.lua
-- Last Modified: 08.12.21 13:42
--------------------------------------

-- Section: Path Settings {
	-- vim.cmd ([[set rtp+=~/.config/nvim]])
	vim.cmd ([[set viminfo+=n~/.local/share/nvim/shada/gmain.shada]])
	vim.opt.packpath:append("~/.config/nvim/pack")
	vim.opt.path = "**"
	vim.opt.shada = { "'20", "<50", "s10" }
	vim.opt.undodir = "~./.cache/nvim/tmpr/undo"
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
