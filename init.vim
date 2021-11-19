" ------------------------------------
" File: init.vim
" Description: Neovim K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/init.vim
" Last Modified: 19.11.21 10:45
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
	set undodir=$HOME/.local/share/nvim/tmp/undo " undo directory
" }


" Section: Global Vars {
	" Coc
	let g:coc_config_home = "$NVIMDOTDIR/core/"

	" Python
	let g:python3_host_prog = "/usr/local/bin/python3.9"

	" Database
	let g:dbs = {
		\ 'imdb': 'postgres://:@localhost/imdb',
		\ 'lezione': 'postgres://:@localhost/lezione'
		\}
" }



" Section: keymap to edit/source config file {
	nmap <Leader>e :e $NVIMDOTDIR/init.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/init.vim<CR>
" }

	runtime! core/*.vim
