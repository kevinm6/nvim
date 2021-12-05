 -------------------------------------
 -- File: plug.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plug.lua
 -- Last Modified: 05.12.21 02:03
 -------------------------------------


-- Section: PLUGINS {
	call plug#begin('$NVIMDOTDIR/plugged')
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-dadbod', { 'for': ['sql'] }
		Plug 'kristijanhusak/vim-dadbod-ui', { 'for': ['sql'] }
		Plug 'neovim/nvim-lspconfig'
		Plug 'williamboman/nvim-lsp-installer'
		Plug 'hrsh7th/cmp-nvim-lsp'
		Plug 'hrsh7th/cmp-buffer'
		Plug 'hrsh7th/cmp-path'
		Plug 'hrsh7th/cmp-cmdline'
		Plug 'hrsh7th/nvim-cmp'
		Plug 'honza/vim-snippets'
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
		Plug 'junegunn/goyo.vim'
		Plug 'liuchengxu/vim-which-key', { 'on' : [] } 
		Plug 'tpope/vim-markdown', { 'for': ['markdown'] }
		Plug 'joelbeedle/pseudo-syntax', { 'for': ['markdown', 'pseudo'] }
		Plug 'makerj/vim-pdf', { 'for': ['pdf'] }
		Plug 'neoclide/coc.nvim', { 'on': [] }" { 'branch':'release' }
		Plug 'morhetz/gruvbox', { 'on': [] }
	call plug#end()
-- }

