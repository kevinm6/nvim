-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/plugins.lua
-- Last Modified: 21/03/2022 - 17:52
-------------------------------------


-- install packer if not found
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end


-- PLUGINS
local ok, packer = pcall(require, "packer")
if not ok then return end

local icons = require "user.icons"

packer.init({
	package_root = require("packer.util").join_paths(vim.fn.stdpath("data"), "site", "pack"),
	compile_path = require("packer.util").join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
	plugin_package = "packer",
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
		working_sym = icons.packer.working_sym,
		error_sym = icons.packer.error_sym,
		done_sym = icons.packer.done_sym,
		removed_sym = icons.packer.removed_sym,
		moved_sym = icons.packer.moved_sym,
		header_sym = icons.packer.header_sym,
	},
})



return packer.startup(function(use)
	-- Plugin/package manager
	use "wbthomason/packer.nvim"

	-- utility plugins
	use "nvim-lua/plenary.nvim"
	use "nvim-lua/popup.nvim"
	use "windwp/nvim-autopairs"
	use "numToStr/Comment.nvim"
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
	use {
		"tweekmonster/startuptime.vim",
		opt = true,
		cmd = {
			"StartupTime"
		}
	}
	use "lewis6991/impatient.nvim"
	use "goolord/alpha-nvim"
	use "rcarriga/nvim-notify"

	-- autocompletion
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-cmdline"
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lua"
  use {
    "hrsh7th/cmp-emoji",
    opt = true,
    ft = { "markdown", "md" }
  }
  use {
    "kdheepak/cmp-latex-symbols",
    ft = { "markdown", "md" }
  }
	use "saadparwaiz1/cmp_luasnip"
  use { "dmitmel/cmp-digraphs", opt = true }
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "tamago324/cmp-zsh"

	-- snippets
	use "L3MON4D3/LuaSnip"
	use "rafamadriz/friendly-snippets"

	-- coding helper
	use "Mephistophiles/surround.nvim"
	use {
		"junegunn/goyo.vim",
		run = ":Goyo"
	}
	use "br1anchen/nvim-colorizer.lua"
	use "RRethy/vim-illuminate"

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate"
	}
	use "nvim-treesitter/playground"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "windwp/nvim-ts-autotag"
	use "romgrk/nvim-treesitter-context"
	use {
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter"
	}
	use "p00f/nvim-ts-rainbow"


	-- git
	use "tpope/vim-fugitive"
	use "lewis6991/gitsigns.nvim"


	-- lsp
	use "neovim/nvim-lspconfig"
	use "williamboman/nvim-lsp-installer"
	use "ray-x/lsp_signature.nvim"
	use "mfussenegger/nvim-jdtls"
	use "filipdutescu/renamer.nvim"
	use "antoinemadec/FixCursorHold.nvim"
	use "simrat39/symbols-outline.nvim"
	use "b0o/SchemaStore.nvim"
	use {
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	}

	-- Telescope
	use "nvim-telescope/telescope.nvim"
	use {
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make"
	}
	use "nvim-telescope/telescope-media-files.nvim"
	use "nvim-telescope/telescope-file-browser.nvim"
	use "nvim-telescope/telescope-packer.nvim"
	use "gbrlsnchs/telescope-lsp-handlers.nvim"
	use "nvim-telescope/telescope-ui-select.nvim"
	use "nvim-telescope/telescope-project.nvim"

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

	-- Python
	use { -- Render jupyter notebook (in alpha version)
		"ahmedkhalf/jupyter-nvim",
		run = ":UpdateRemotePlugins",
		config = function()
			require("jupyter-nvim").setup {}
		end
	}
	use { "jupyter-vim/jupyter-vim" } -- work with Python envs and render in QTconsole
	use { "bfredl/nvim-ipy" }

	-- markdown
	use {
		"ellisonleao/glow.nvim",
		ft = "markdown",
	}
	use {
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = "markdown",
		cmd = { "MarkdownPreview" }
	}

  use { "dhruvasagar/vim-table-mode" }

	-- pdf
	use {
		"makerj/vim-pdf",
		ft = "pdf",
	}

	-- themes
	use {
		"morhetz/gruvbox",
		opt = true,
		cmd = { "colorscheme" }
	}
	use {
		"ChristianChiarulli/nvcode-color-schemes.vim",
		opt = true,
		cmd = { "colorscheme" }
	}
	use {
		"Shatur/neovim-ayu",
		opt = true,
		cmd = { "colorscheme" }
	}

	if PACKER_BOOTSTRAP then
		require('packer').sync()
	end
end)

