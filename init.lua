 -------------------------------------
 -- File: init.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/init.lua
 -- Last Modified: 05.12.21 05:15
 -------------------------------------


-- Section: check VScode/codium 
	if vim.fn.exists('g:vscode') == 1 then
		return
	end

	if not(vim.fn.has('nvim')) == 1 then
		vim.cmd('source $VIMDOTDIR/vimrc; finish')
	elseif vim.fn.has('gui_vimr') == 1 then
		vim.cmd('source $NVIMDOTDIR/ginit.vim; finish')
	end
-- }


-- Section: Path Settings {
	vim.opt.rtp = '~/.config/nvim/'
	--vim.opt.viminfo = '~/.local/share/nvim/main.shada'
	vim.opt.packpath = '&runtimepath'
	vim.opt.path = '**'
	--vim.opt.shada = '20,<50,s10'
	vim.opt.undodir = '$HOME/.local/share/nvim/tmp/undo' -- undo dir
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","
	local function map(mode, shortcut, command)
		vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = false })
	end

	map('n', '<Leader>e', ':e $NVIMDOTDIR/init.vim<CR>')
	map('n', '<Leader>s', ':source $NVIMDOTDIR/init.vim<CR>')
-- }

require('lsp-config')
require('prefs')
require('vars')
require('maps')
require('plug')
