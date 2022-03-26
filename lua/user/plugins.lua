-------------------------------------
-- File: plugins.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/plugins.lua
-- Last Modified: 26/03/2022 - 18:30
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
  max_jobs = 14,
	display = {
		open_fn = function()
			return require("packer.util").float { border = "shadow" }
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
	-- Plugin/package manager (set packer manage itself)
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
	use "akinsho/toggleterm.nvim"
	use "moll/vim-bbye"
	use {
		"tweekmonster/startuptime.vim",
		opt = true,
		cmd = "StartupTime",
	}
	use "lewis6991/impatient.nvim"
	use "goolord/alpha-nvim"
	use "rcarriga/nvim-notify"
  use { "nvim-lualine/lualine.nvim", disable = true, opt = true }

	-- autocompletion
  use {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "ray-x/cmp-treesitter",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "tamago324/cmp-zsh",
    "kdheepak/cmp-latex-symbols",
    "dmitmel/cmp-digraphs",
    "hrsh7th/cmp-emoji",

    -- snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  }

	-- coding helper
	use "Mephistophiles/surround.nvim"
	use {
		"folke/zen-mode.nvim",
    cmd = ":Goyo"
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
      { "nvim-treesitter/playground" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "romgrk/nvim-treesitter-context" },
      { "windwp/nvim-ts-autotag" },
      { "p00f/nvim-ts-rainbow" },
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
	use { "neovim/nvim-lspconfig" }
	use { "williamboman/nvim-lsp-installer", after = "nvim-lspconfig" }
	use { "ray-x/lsp_signature.nvim", after = "nvim-lspconfig" }
	use {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    module = "jdtls",
  }

	use {
    "filipdutescu/renamer.nvim",
    after = "plenary.nvim"
  }
	use "antoinemadec/FixCursorHold.nvim"
	use "simrat39/symbols-outline.nvim"
	use {
    "b0o/SchemaStore.nvim",
    ft = "json",
    module = "schemastore"
  }
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
    },
    event = "BufEnter"
  }

	-- database
	use {
    { "tpope/vim-dadbod", ft = "sql", cmd = ":DB" },
    { "kristijanhusak/vim-dadbod-ui", ft = "sql", cmd = ":DBUI" }
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
		{ "ellisonleao/glow.nvim", ft = { "md", "markdown" } },
    {
      "iamcco/markdown-preview.nvim",
      ft = { "md", "markdown" },
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
    }
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

