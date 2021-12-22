-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plugins.lua
-- Last Modified: 22/12/21 - 14:27
-------------------------------------


-- Section: PLUGINS {
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		return
	end

	-- display packer in a popup window
	packer.init({
		package_root = require('packer.util').join_paths(vim.fn.stdpath('data'), 'site', 'pack'),
		compile_path = require('packer.util').join_paths(vim.fn.stdpath('data'), 'packer_compiled.lua'),
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
			'wbthomason/packer.nvim',

			-- utility plugins
			'nvim-lua/plenary.nvim',
			'nvim-lua/popup.nvim',
			'windwp/nvim-autopairs',

			-- autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp',

			-- file finder
			'nvim-telescope/telescope.nvim',
			'nvim-telescope/telescope-media-files.nvim',

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
			'lewis6991/gitsigns.nvim',

			-- snippets
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			{'honza/vim-snippets', cmd = 'InsertEnter'},

			-- lsp
			'neovim/nvim-lspconfig',
			'williamboman/nvim-lsp-installer',
			'ray-x/lsp_signature.nvim',
			'mfussenegger/nvim-jdtls',
			'filipdutescu/renamer.nvim',

			-- database
			{ 'tpope/vim-dadbod', ft = { 'sql' }, cmd = ':DB' },
			{ 'kristijanhusak/vim-dadbod-ui', ft = { 'sql' }, cmd = ':DBUI' },

			-- markdown
      'ellisonleao/glow.nvim',
			{
				'iamcco/markdown-preview.nvim',
				opt = true,
				run = 'cd app && yarn install',
				ft = 'markdown',
			},

			-- pdf
			{ 'makerj/vim-pdf', ft = { 'pdf' } },

			-- themes
			{ 'morhetz/gruvbox', opt = true, cmd = { 'colorscheme' } },
			{ 'ChristianChiarulli/nvcode-color-schemes.vim', opt = true, cmd = { 'colorscheme' } }

		}
	end)
-- }

