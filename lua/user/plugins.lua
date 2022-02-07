-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/plugins.lua
-- Last Modified: 07/02/2022 - 17:40
-------------------------------------


-- install packer if not found
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    BOOTSTRAPED = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end


-- Section: PLUGINS {
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		return
	end

	packer.init({
		package_root = require("packer.util").join_paths(vim.fn.stdpath("data"), "site", "pack"),
		compile_path = require("packer.util").join_paths(vim.fn.stdpath('config'), 'plugin', 'packer_compiled.lua'),
		plugin_package = 'packer',
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
			working_sym = '⟳',
			error_sym = '✗',
			done_sym = '✓',
			removed_sym = '-',
			moved_sym = '→',
			header_sym = '━',
		},
	})


	vim.cmd([[
		augroup packer_user_config
			autocmd!
			autocmd BufWritePost plugins.lua source <afile> | PackerCompile
		augroup end
	]])

	local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	end

	return packer.startup(function(use)
		-- Plugin/package manager
		use "wbthomason/packer.nvim"

		-- utility plugins
		use "nvim-lua/plenary.nvim"
		use "nvim-lua/popup.nvim"
		use "windwp/nvim-autopairs"
		use "numToStr/Comment.nvim"
		use "nvim-telescope/telescope.nvim"
		use "nvim-telescope/telescope-media-files.nvim"
		use {
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons"
			}
		}
		use {
			"folke/which-key.nvim",
			run = "WhichKey"
		}
		use {
			"akinsho/bufferline.nvim",
			requires = "kyazdani42/nvim-web-devicons"
		}
		use "moll/vim-bbye"
		use "akinsho/toggleterm.nvim"

		-- autocompletion
		use "hrsh7th/nvim-cmp"
		use "hrsh7th/cmp-buffer"
		use "hrsh7th/cmp-path"
		use "hrsh7th/cmp-cmdline"
		use "hrsh7th/cmp-nvim-lsp"
		use "saadparwaiz1/cmp_luasnip"

		-- coding helper
		use {
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate"
		}
		use "nvim-treesitter/playground"
		use "blackCauldron7/surround.nvim"
		use {
			"junegunn/goyo.vim",
			run = ":Goyo"
		}
		use "JoosepAlviste/nvim-ts-context-commentstring"

		-- git
		use "tpope/vim-fugitive"
		use "lewis6991/gitsigns.nvim"

		-- snippets
		use "L3MON4D3/LuaSnip"
		use "rafamadriz/friendly-snippets"

		-- lsp
		use "neovim/nvim-lspconfig"
		use "williamboman/nvim-lsp-installer"
		use "ray-x/lsp_signature.nvim"
		use "mfussenegger/nvim-jdtls"
		use "filipdutescu/renamer.nvim"
		use "antoinemadec/FixCursorHold.nvim"
		use "b0o/SchemaStore.nvim"

		-- database
		use {
			"tpope/vim-dadbod",
			ft = {
				"sql"
			},
			cmd = ":DB"
		}
		use {
			"kristijanhusak/vim-dadbod-ui",
			ft = {
				"sql"
			},
			cmd = ":DBUI"
		}

		-- markdown
		use {
			"ellisonleao/glow.nvim",
			ft = "markdown",
		}
		use {
			"iamcco/markdown-preview.nvim",
			run = "cd app && yarn install",
			ft = "markdown",
		}

		-- pdf
		use {
			"makerj/vim-pdf",
			ft = "pdf",
		}

		-- themes
		use {
			"morhetz/gruvbox",
			opt = true,
			cmd = {
				"colorscheme"
			}
		}
		use {
			"ChristianChiarulli/nvcode-color-schemes.vim",
			opt = true,
			cmd = {
				"colorscheme"
			}
		}

		if packer_bootstrap then
			require('packer').sync()
		end
	end)
-- }

