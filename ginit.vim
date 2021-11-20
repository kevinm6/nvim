" ------------------------------------
" File: ginit.vim
" Description: VimR K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.vim
" Last Modified: 20.11.21 16:26
" ------------------------------------


" Section: PATH SETTINGS {
" Section: Path Settings {
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/gmain.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
	set undodir=$HOME/.local/share/nvim/tmpr/undo " undo directory
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
	
" Section: VimR FullScreen {
		function! s:VimRTempMaxWin() abort
			VimRMakeSessionTemporary    " The tools, tool buttons and window settings are not persisted
			VimRHideTools
			VimRMaximizeWindow
		endf
		command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()
" }


" Section: keymap to edit/source config file {
	nmap <Leader>e :e $NVIMDOTDIR/ginit.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/ginit.vim<CR>
" }

	runtime! core/*.vim
