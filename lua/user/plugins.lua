--------------------------------------
-- File         : plugins.lua
-- Description  : Lua K NeoVim & VimR plugins w/ packer
-- Author       : Kevin
-- Last Modified: 03/05/2022 - 09:19
--------------------------------------

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

local icons = require("user.icons")

-- PLUGINS
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

local augroup_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup_packer,
	pattern = "plugins.lua",
	callback = function()
		vim.cmd([[ source <afile> ]])
		packer.compile()

		local notification = " Plugins file update & compiled !"
		vim.notify(notification, "info", {
			title = icons.ui.Packer .. " Packer",
		})
	end,
})

packer.init({
	package_root = require("packer.util").join_paths(vim.fn.stdpath("data"), "site", "pack"),
	compile_path = require("packer.util").join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
	max_jobs = 20,
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "shadow" })
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
	-- Plugin/package manager (set packer manage itself)
	use("wbthomason/packer.nvim")

	-- utility plugins
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
	use("windwp/nvim-autopairs")
	use("folke/todo-comments.nvim")
	use("numToStr/Comment.nvim")
	use("kyazdani42/nvim-web-devicons")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
	})
  use "edluffy/hologram.nvim"

	use({
		"folke/which-key.nvim",
		run = "WhichKey",
	})
	use({
		"akinsho/bufferline.nvim",
		tag = "*",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use("akinsho/toggleterm.nvim")
	use("moll/vim-bbye")
	use({
		"tweekmonster/startuptime.vim",
		cond = false,
		cmd = "StartupTime",
	})
	use("lewis6991/impatient.nvim")
	use("goolord/alpha-nvim")
	use("rcarriga/nvim-notify")
	use("jose-elias-alvarez/null-ls.nvim")

	-- DAP
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")
	use("rcarriga/nvim-dap-ui")
	use("Pocco81/DAPInstall.nvim")

	-- autocompletion
	use({
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"ray-x/cmp-treesitter",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"tamago324/cmp-zsh",
		"kdheepak/cmp-latex-symbols",
		"hrsh7th/cmp-calc",
		"dmitmel/cmp-digraphs",
		{ "hrsh7th/cmp-emoji", opt = true },

		-- snippets
		{
			"L3MON4D3/LuaSnip",
			requires = {
				"rafamadriz/friendly-snippets",
				-- "molleweide/LuaSnip-snippets.nvim",
			},
		},
	})

	-- coding helper
	use("Mephistophiles/surround.nvim")
	use({
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
	})
	use("br1anchen/nvim-colorizer.lua")
	use("RRethy/vim-illuminate")
	use("phaazon/hop.nvim")
	use({ "michaelb/sniprun", run = "bash ./install.sh" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			{ "nvim-treesitter/playground" },
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
			{ "lewis6991/nvim-treesitter-context" },
			{ "windwp/nvim-ts-autotag" },
			{ "p00f/nvim-ts-rainbow" },
		},
	})

	use({
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- git
	use("lewis6991/gitsigns.nvim")
	use("f-person/git-blame.nvim")

	-- lsp
	use("neovim/nvim-lspconfig")
	use({ "williamboman/nvim-lsp-installer", after = "nvim-lspconfig" })
	use({ "ray-x/lsp_signature.nvim", after = "nvim-lspconfig" })
	use({
		"mfussenegger/nvim-jdtls",
		require = { "Microsoft/java-debug" },
	})

	use("antoinemadec/FixCursorHold.nvim")
	use("simrat39/symbols-outline.nvim")
	use({
		"b0o/SchemaStore.nvim",
		ft = "json",
		module = "schemastore",
	})
	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-telescope/telescope-media-files.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
			{ "nvim-telescope/telescope-packer.nvim" },
			{ "gbrlsnchs/telescope-lsp-handlers.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-project.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "gfeiyou/command-center.nvim" },
		},
		event = "BufEnter",
	})

	-- database
	use({
		"tpope/vim-dadbod",
		cond = false,
		ft = "sql",
		cmd = ":DB",
		requires = {
			"kristijanhusak/vim-dadbod-ui",
			ft = "sql",
			cmd = ":DBUI",
		},
	})

	-- Python
	use({ -- Render jupyter notebook (in alpha version)
		"ahmedkhalf/jupyter-nvim",
		run = ":UpdateRemotePlugins",
		ft = { "ipynb", "py" },
		config = function()
			require("jupyter-nvim").setup({})
		end,
	})
	use({ "jupyter-vim/jupyter-vim", cond = false, ft = "ipynb" }) -- work with Python envs and render in QTconsole
	use({ "bfredl/nvim-ipy", cond = false, ft = "py" })

	-- markdown
	use({
		{ "ellisonleao/glow.nvim", ft = { "md", "markdown" } },
		{
			"iamcco/markdown-preview.nvim",
			ft = { "md", "markdown" },
			run = "cd app && yarn install",
			cmd = "MarkdownPreview",
		},
	})

	use({ "dhruvasagar/vim-table-mode", ft = { "md", "markdown" } })

	-- pdf
	use({
		"makerj/vim-pdf",
		ft = "pdf",
	})

	-- themes
	use({
		"ellisonleao/gruvbox.nvim",
		cond = false,
	})
	use({
		"Shatur/neovim-ayu",
		cond = false,
	})
  use "fladson/vim-kitty"

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
