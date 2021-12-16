--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 16/12/21 - 14:20
--------------------------------------


-- Section: check VScodium | Vim (standard)
	if vim.fn.exists('g:vscode') == 1 then
		return
	elseif not(vim.fn.has('nvim')) == 1 then
		vim.cmd	'source ~/.config/vim/vimrc'
		return
	end
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","

	vim.api.nvim_set_keymap('n', '<Leader>e', ':e $NVIMDOTDIR/init.lua<CR>', { noremap = true, silent = false })
	vim.api.nvim_set_keymap('n', '<Leader>s', ':so $NVIMDOTDIR/init.lua<CR>', { noremap = true, silent = false })
-- }


-- Section: Other config files to source {
	require("user.plugins")
	require("user.prefs")
	require("user.vars")
	require("user.maps")
	require("user.lspconfig")
	require("user.cmp")
	require("user.treesitter")
	require("user.gitsigns")
	require("user.autopairs")
	require("user.statusline")
-- }
