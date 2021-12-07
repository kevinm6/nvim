 -------------------------------------
 -- File: plug.lua
 -- Description: K plugins w/ packer as Package Manager
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plug.lua
 -- Last Modified: 07.12.21 18:30
 -------------------------------------


-- Section: PLUGINS {

	local use = require('packer').use
	require('packer').startup(function()
		use {
			'wbthomason/packer.nvim',
			'neovim/nvim-lspconfig',
			'williamboman/nvim-lsp-installer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/nvim-cmp',
			'nvim-telescope/telescope.nvim',
			'tpope/vim-surround',
			'tpope/vim-commentary',
			'tpope/vim-fugitive',
			'nvim-treesitter/nvim-treesitter',
			'sharkdp/fd',
			'BurntSushi/ripgrep',
			'L3MON4D3/LuaSnip'
		}
		use {
			'tpope/vim-dadbod',
			ft = { 'sql' },
			cmd = 'DB'
		}
		use {
			'kristijanhusak/vim-dadbod-ui',
			ft = { 'sql' },
			cmd = 'DBUI'
		}

		use {
			'honza/vim-snippets',
			cmd = 'InsertEnter'
		}
		use { 'junegunn/goyo.vim', run = ':Goyo' }
		use { 'tpope/vim-markdown',
					'joelbeedle/pseudo-syntax',
					ft = { 'markdown', 'pseudo', 'md', 'latex' }
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

		use {
			'haorenW1025/completion-nvim',
			opt = true,
			requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
		}

		use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

		use {
			'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
			config = function() require('gitsigns').setup() end
		}

	end)
-- }

