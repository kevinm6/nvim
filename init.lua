--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 07.12.21 18:23
--------------------------------------


-- Section: check VScode/codium 
	if vim.fn.exists('g:vscode') == 1 then
		return
	end
	if not(vim.fn.has('nvim')) == 1 then
		vim.cmd [[source $VIMDOTDIR/vimrc]]
		return
	elseif vim.fn.has('gui_vimr') == 1 then
		package.path = package.path .. ';../?.lua'
		require 'nvim.ginit'
		return
	end
-- }


-- Section: Path Settings {
	vim.cmd([[
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/shada/main.shada
	set packpath+=~/.config/nvim/pack/
	set path=**
	set shada='20,<50,s10
	set undodir=~/.cache/nvim/tmp/undo
	]])
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","
	local function map(mode, shortcut, command)
		vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = false })
	end

	map('n', '<Leader>e', ':e $NVIMDOTDIR/init.lua<CR>')
	map('n', '<Leader>s', ':source $NVIMDOTDIR/init.lua<CR>')
-- }

-- Section:	Other config files to source {
	require('lsp-config')
	require('plug')
	require('prefs')
	require('vars')
	require('maps')
-- }
