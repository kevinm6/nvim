" ------------------------------------
" File: init.vim
" Description: Neovim K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/init.vim
" Last Modified: 01/12/21 - 16:52
" ------------------------------------


" Section: check VScode/codium 
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
" }


" Section: Path Settings {
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/main.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
	set undodir=$HOME/.local/share/nvim/tmp/undo " undo dir
" }


" Section: set mapleader & add maps configFile edit/source {
	let mapleader = ","
	let g:mapleader = ","
	nmap <Leader>e :e $NVIMDOTDIR/init.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/init.vim<CR>
" }

	runtime! core/*.vim
