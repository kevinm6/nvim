" -------------------------------------------------
" File: markdown.vim
" Description: Filetype markdown specific settings
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.vim
" Last Modified: 01/12/21 - 09:49
" -------------------------------------------------

" Only do this when not done yet for this buffer
if exists("b:ftplugin_markdown")
	  finish
endif
let b:ftplugin_markdown = 1

setlocal conceallevel=2
setlocal shiftwidth=2 expandtab

setlocal cindent
setlocal spelllang=en_US,it_IT

