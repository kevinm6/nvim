 -------------------------------------
 -- File: init.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
 -- Last Modified: 05.12.21 02:05
 -------------------------------------


-- Section: check VScode/codium 
	if exists('g:vscode')
		finish
	endif

	if !has('nvim')
		source $VIMDOTDIR/vimrc
		finish
	elseif has('gui_vimr')
		source $NVIMDOTDIR/ginit.vim
		finish
	endif
-- }


-- Section: Path Settings {
	vim.opt.rtp+=~/.config/nvim/
	vim.opt.viminfo+=n~/.local/share/nvim/main.shada
	vim.opt.packpath+=&runtimepath
	vim.opt.path+=**
	vim.opt.shada=20,<50,s10
	vim.opt.undodir=$HOME/.local/share/nvim/tmp/undo -- undo dir
-- }


-- Section: set mapleader & add maps configFile edit/source {
	vim.g.mapleader = ","
	local function map(mode, combo, mapping, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
		vim.api.nvim_set_keymap(mode, combo, mapping, options)
	end
	map(<Leader>e :e $NVIMDOTDIR/init.vim<CR>
	map(<Leader>s :source $NVIMDOTDIR/init.vim<CR>
-- }

require('lsp-config')
require('prefs')
require('vars')
require('maps')
require('plug')
