" -------------------------------------------------
" File: markdown.vim
" Description: Filetype markdown specific settings
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.vim
" Last Modified: 18.11.21 09:21
" -------------------------------------------------

" Only do this when not done yet for this buffer
if exists("b:ftplugin_markdown")
	  finish
endif
let b:ftplugin_markdown = 1

setlocal conceallevel=2
setlocal shiftwidth=2 expandtab

setlocal cindent

