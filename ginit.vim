" ------------------------------------
" File: ginit.vim
" Description: VimR K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.vim
" Last Modified: 01/12/21 - 10:26
" ------------------------------------


" Section: Path Settings {
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/gmain.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
	set undodir=$HOME/.local/share/nvim/tmpr/undo " undo dir
" }

	
" Section: VimR FullScreen {
		function! s:VimRTempMaxWin() abort
			VimRMakeSessionTemporary    " The tools, tool buttons and window settings are not persisted
			VimRHideTools
			VimRMaximizeWindow
		endf
		command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()
" }


" Section: set mapleader & add maps configFile edit/source {
	let g:mapleader = ","
	nmap <Leader>e :e $NVIMDOTDIR/ginit.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/ginit.vim<CR>
" }

	runtime! core/*.vim
