" -------------------------------------------------
" File: plugins.vim
" Description: NeoVim | VimR | Vim plugins to load
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/plugins.vim
" Last Modified: 29.11.21 13:03
" -------------------------------------------------


" Section: PLUGINS {
	call plug#begin('$NVIMDOTDIR/plugged')
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-dadbod', { 'for': ['sql'] }
		Plug 'kristijanhusak/vim-dadbod-ui', { 'for': ['sql'] }
		Plug 'honza/vim-snippets'
		Plug 'junegunn/goyo.vim'
		Plug 'liuchengxu/vim-which-key', { 'on' : [] } 
		Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
		Plug 'joelbeedle/pseudo-syntax', { 'for': ['markdown', 'pseudo'] }
		Plug 'makerj/vim-pdf', { 'for': ['pdf'] }
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		Plug 'morhetz/gruvbox', { 'on': [] }
	call plug#end()
" }
