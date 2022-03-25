-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/plugins.lua
-- Last Modified: 25/03/2022 - 14:39
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

vim.cmd [[
	augroup _packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]]

local icons = require "user.icons"

packer.init {
	package_root = require("packer.util").join_paths(vim.fn.stdpath("data"), "site", "pack"),
	compile_path = require("packer.util").join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
	plugin_package = "packer",
  max_jobs = 14,
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
}


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
  use { "nvim-lualine/lualine.nvim", opt = true }

	-- autocompletion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp"},
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp"},
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp"},
      { "ray-x/cmp-treesitter", after = "nvim-cmp" },
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
      { "tamago324/cmp-zsh", after = "nvim-cmp" },
      { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" },
      { "dmitmel/cmp-digraphs", after = "nvim-cmp", opt = true },
      { "hrsh7th/cmp-emoji", after = "nvim-cmp", opt = true },
    }
  }

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
  use "phaazon/hop.nvim"
  use { "michaelb/sniprun", run = "bash ./install.sh" }

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/playground", after = "nvim-treesitter" },
      { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
      { "romgrk/nvim-treesitter-context", after = "nvim-treesitter" },
      { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
      { "abecodes/tabout.nvim", after = "nvim-treesitter" }
    },
	}
	use {
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter"
	}


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
	use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-media-files.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-packer.nvim" },
      { "gbrlsnchs/telescope-lsp-handlers.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    }
  }

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
    ft = { "ipynb", "py" },
		config = function()
			require("jupyter-nvim").setup {}
		end
	}
	use { "jupyter-vim/jupyter-vim", ft = "ipynb" } -- work with Python envs and render in QTconsole
	use { "bfredl/nvim-ipy", ft = "py" }

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

  use { "dhruvasagar/vim-table-mode", ft = { "md", "markdown" } }

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

