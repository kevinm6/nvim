" -------------------------------------------------
" File: plugins.vim
" Description: NeoVim | VimR | Vim plugins to load
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/plugins.vim
" Last Modified: 26.11.21 09:39
" -------------------------------------------------


" Section: PLUGINS {
	call plug#begin('$NVIMDOTDIR/plugged')
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-dadbod'
		Plug 'kristijanhusak/vim-dadbod-ui'
		Plug 'SirVer/ultisnips'
		Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
		Plug 'joelbeedle/pseudo-syntax', { 'for': ['markdown', 'pseudo'] }
		Plug 'liuchengxu/vim-which-key', { 'on': [] }
		Plug 'junegunn/goyo.vim'
		Plug 'makerj/vim-pdf', { 'for': ['pdf'] }
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		Plug 'morhetz/gruvbox', { 'on': [] }
	call plug#end()
" }
