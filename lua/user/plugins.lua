-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plugins.lua
-- Last Modified: 13/12/21 - 16:00
-------------------------------------

-- Automatically install packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer close and reopen Neovim...")
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Section: PLUGINS {
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		return
	end

	packer.init({
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}
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
			{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
			'tpope/vim-surround',
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
			{ 'joelbeedle/pseudo-syntax', cmd = 'InsertEnter', ft = { 'markdown', 'pseudo', 'md' } },
			{ 'tpope/vim-markdown', ft = { 'markdown', 'pseudo', 'md', 'latex' } },
			{ 'iamcco/markdown-preview.nvim', ft = { 'markdown', 'pseudo', 'md' },
				run = 'cd app && yarn install',
				cmd = 'MarkdownPreview',
			},

			-- pdf
			{ 'makerj/vim-pdf', ft = { 'pdf' } },

			-- themes
			{ 'morhetz/gruvbox', opt = true, cmd = { 'colorscheme' } },
			{ 'ChristianChiarulli/nvcode-color-schemes.vim', opt = true, cmd = { 'colorscheme' } }

		}

		if PACKER_BOOTSTRAP then
			require('packer').sync()
		end

	end)
-- }

