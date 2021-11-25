" -------------------------------------------------
" File: plugins.vim
" Description: NeoVim | VimR | Vim plugins to load
" Author: Kevin
" Source: https://github.com/kevinm6/
" Last Modified: 25.11.21 10:33
" -------------------------------------------------


" Section: PLUGINS {
	call plug#begin('$NVIMDOTDIR/plugins')
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-dadbod'
		Plug 'kristijanhusak/vim-dadbod-ui'
		Plug 'liuchengxu/vim-which-key'
		Plug 'tpope/vim-markdown'
		Plug 'joelbeedle/pseudo-syntax'
		Plug 'junegunn/goyo.vim'
		Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		Plug 'morhetz/gruvbox'
	call plug#end()
" }
