-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plugins.lua
-- Last Modified: 16/12/21 - 20:46
-------------------------------------


-- Section: PLUGINS {
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		return
	end

	-- display packer in a popup window
	packer.init({
		package_root = require('packer.util').join_paths(vim.fn.stdpath('data'), 'site', 'pack'),
		compile_path = require('packer.util').join_paths(vim.fn.stdpath('config'), 'lua', 'user', 'packer_compiled.lua'),
		display = {
			open_fn = function()
				return require('packer.util').float ({ border = 'rounded' })
			end
		},
	})

	local use = require('packer').use
	packer.startup(function()
		use {
			-- Plugin/package manager
			{ 'wbthomason/packer.nvim', opt = true },

			-- utility plugins
			'nvim-lua/plenary.nvim',
			'nvim-lua/popup.nvim',
			'windwp/nvim-autopairs',

			-- lsp
			'neovim/nvim-lspconfig',
			'williamboman/nvim-lsp-installer',

			-- autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp',

			-- file finder
			'nvim-telescope/telescope.nvim',

			-- coding helper
			{
				'nvim-treesitter/nvim-treesitter',
				run = ":TSUpdate"
			},
			'blackCauldron7/surround.nvim',
			'tpope/vim-commentary',
			{ 'junegunn/goyo.vim', run = ':Goyo' },

			-- git
			'tpope/vim-fugitive',
			{ 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } },

			-- snippets
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			{'honza/vim-snippets', cmd = 'InsertEnter'},

			-- database
			{ 'tpope/vim-dadbod', ft = { 'sql' }, cmd = ':DB' },
			{ 'kristijanhusak/vim-dadbod-ui', ft = { 'sql' }, cmd = ':DBUI' },

			-- markdown
			{ 'tpope/vim-markdown', ft = { 'markdown', 'latex' } },
			{
				'iamcco/markdown-preview.nvim',
				run = 'cd app && yarn install',
				ft = 'markdown',
			},
			{ 'joelbeedle/pseudo-syntax', cmd = 'InsertEnter', ft = 'markdown' },
      'ellisonleao/glow.nvim',

			-- pdf
			{ 'makerj/vim-pdf', ft = { 'pdf' } },

			-- themes
			{ 'morhetz/gruvbox', opt = true, cmd = { 'colorscheme' } },
			{ 'ChristianChiarulli/nvcode-color-schemes.vim', opt = true, cmd = { 'colorscheme' } }

		}
	end)
-- }

