--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 10/12/21 - 12:30
--------------------------------------


-- Section: check VScode/codium 
	if vim.fn.exists('g:vscode') == 1 then
		return
	end
	if not(vim.fn.has('nvim')) == 1 then
		vim.cmd	'source $VIMDOTDIR/vimrc'
		return
	elseif vim.fn.has('gui_vimr') == 1 then
		vim.cmd 'source $NVIMDOTDIR/ginit.lua'
		return
	end
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","

	vim.api.nvim_set_keymap('n', '<Leader>e', ':e $NVIMDOTDIR/init.lua<CR>', { noremap = true, silent = false })
	vim.api.nvim_set_keymap('n', '<Leader>s', ':so $NVIMDOTDIR/init.lua<CR>', { noremap = true, silent = false })
-- }


-- Section: Other config files to source {
	require('plug')
	require('lsp-config')
	require('prefs')
	require('vars')
	require('maps')
-- }
