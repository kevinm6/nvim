 -------------------------------------
 -- File: plug.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plug.lua
 -- Last Modified: 05.12.21 02:03
 -------------------------------------


-- Section: PLUGINS {

	return require('packer').startup(function()
		-- Packer can manage itself
		use 'wbthomason/packer.nvim'
		use 'tpope/vim-surround'
		use 'tpope/vim-commentary'
		use 'tpope/vim-fugitive'
		use { 
			'tpope/vim-dadbod', 
			ft = { 'sql' },
			cmd = 'DB'
		}
		use {
			'kristijanhusak/vim-dadbod-ui',
			ft = { 'sql' }
			cmd = 'DBUI'
		}
		use 'neovim/nvim-lspconfig'
		use 'williamboman/nvim-lsp-installer'
		use 'hrsh7th/cmp-nvim-lsp'
		use 'hrsh7th/cmp-buffer'
		use 'hrsh7th/cmp-path'
		use 'hrsh7th/cmp-cmdline'
		use 'hrsh7th/nvim-cmp'
		use 'honza/vim-snippets'
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		use 'junegunn/goyo.vim'
		use { 'tpope/vim-markdown',
			ft = { 'markdown', 'pseudo', 'md', 'latex' }
		}
		use {
			'joelbeedle/pseudo-syntax',
			ft = {'markdown', 'pseudo'} 
		}
		use {
			'makerj/vim-pdf', 
			ft = { 'pdf' } 
		}
		use {
			'morhetz/gruvbox', 
			opt = true, 
			cmd = { 'colorscheme' } 
		}
		-- Plugins can have dependencies on other plugins
		use {
			'haorenW1025/completion-nvim',
			opt = true,
			requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
		}

		-- Plugins can also depend on rocks from luarocks.org:
		use {
			'my/supercoolplugin',
			rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
		}

		-- Plugins can have post-install/update hooks
		use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

		-- Post-install/update hook with neovim command
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }


		-- Use dependency and run lua function after load
		use {
			'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
			config = function() require('gitsigns').setup() end
		}

	end)
-- }

