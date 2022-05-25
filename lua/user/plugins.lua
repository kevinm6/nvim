--------------------------------------
-- File         : plugins.lua
-- Description  : Lua K NeoVim & VimR plugins w/ packer
-- Author       : Kevin
-- Last Modified: 25/05/2022 - 12:33
--------------------------------------

-- install packer if not found in
--  default location
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

local icons = require "user.icons"

-- PLUGINS
local ok, packer = pcall(require, "packer")
if not ok then return end

local p_util = require "packer.util"

local wk = require "which-key"

wk.register({
  p = {
    name = "Packer",
    l = { ":PackerLoad ", "Load plugin" }
  }
}, {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = false,
  noremap = true,
  nowait = true,
})


local augroup_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup_packer,
  pattern = "plugins.lua",
  callback = function()
    vim.cmd "source <afile>"
    packer.compile()

    vim.notify(
       " Plugins file update & compiled !", "Info", {
      title = "Packer",
    })
  end,
})

packer.init {
  package_root = p_util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = p_util.join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
  max_jobs = 20,
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
  -- Plugin/package manager (set packer manage itself)
  use "wbthomason/packer.nvim"

  -- Utils plugins
  use {
    "nvim-lua/plenary.nvim",
    "lewis6991/impatient.nvim",
    "nvim-lua/popup.nvim",
    "moll/vim-bbye",
    {
      "tweekmonster/startuptime.vim",
      opt = true,
      cmd = "StartupTime",
    },
    {
      "MunifTanjim/nui.nvim",
      cmd = "require",
    },
    "RRethy/vim-illuminate",
    "kyazdani42/nvim-web-devicons",
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
    },
    "br1anchen/nvim-colorizer.lua",
    "antoinemadec/FixCursorHold.nvim",
  }

   -- Core plugins
  use {
    "kyazdani42/nvim-tree.lua",
    {
      "folke/which-key.nvim",
      run = "WhichKey",
    },
    "ghillb/cybu.nvim",
    {
      "akinsho/bufferline.nvim",
      tag = "*",
      requires = "kyazdani42/nvim-web-devicons",
    },
    "akinsho/toggleterm.nvim",
    "goolord/alpha-nvim",
    "rcarriga/nvim-notify",
  }

  -- Autocompletion & Snippets
  use {
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
    "rcarriga/cmp-dap",
    { "hrsh7th/cmp-emoji", opt = true },
    -- snippets engine and source
    {
      "L3MON4D3/LuaSnip",
      requires = "kevinm6/the_snippets",
    },
  }


  -- Coding Helper
  use {
    "windwp/nvim-autopairs",
    "Mephistophiles/surround.nvim",
    "folke/todo-comments.nvim",
    "numToStr/Comment.nvim",
    "phaazon/hop.nvim",
    "kevinm6/nvim-gps",
    { "michaelb/sniprun", run = "bash ./install.sh" },
    {
      "simrat39/symbols-outline.nvim",
      requires = "nvim-treesitter/nvim-treesitter",
    },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    "jose-elias-alvarez/null-ls.nvim",
  }


  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "lewis6991/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "p00f/nvim-ts-rainbow",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/playground",
    },
  }


  -- Git
  use "lewis6991/gitsigns.nvim"


  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-telescope/telescope-media-files.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-packer.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-project.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    event = "BufEnter",
  }

  -- DAP (Debugging)
  use {
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "Pocco81/DAPInstall.nvim",
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    { "williamboman/nvim-lsp-installer", after = "nvim-lspconfig" },
    { -- Java
      "mfussenegger/nvim-jdtls",
      require = { "Microsoft/java-debug" },
    },

    -- database
    "nanotee/sqls.nvim",

    -- Json
    {
      "b0o/SchemaStore.nvim",
      ft = "json",
      module = "schemastore",
    },
  }

  -- Python
  use { -- Render jupyter notebook (in alpha version)
    "ahmedkhalf/jupyter-nvim",
    run = ":UpdateRemotePlugins",
    ft = { "ipynb", "py" },
    config = function()
      require("jupyter-nvim").setup {}
    end,
    {
      "jupyter-vim/jupyter-vim",
      cond = false, ft = "ipynb"
    }, -- work with Python envs and render in QTconsole
    {
      "bfredl/nvim-ipy",
      cond = false, ft = "py"
    },
  }


  -- markdown
  use {
    { "ellisonleao/glow.nvim", ft = { "md", "markdown" } },
    {
      "iamcco/markdown-preview.nvim",
      ft = { "md", "markdown" },
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
    },
    {
      "dhruvasagar/vim-table-mode",
      ft = { "md", "markdown" }
    },
  }

  -- pdf
  use {
    "makerj/vim-pdf",
    ft = "pdf",
  }

  -- themes
  use {
    {
      "ellisonleao/gruvbox.nvim",
      opt = true,
    },
    {
      "Shatur/neovim-ayu",
      opt = true,
    },
    {
      "fladson/vim-kitty",
      ft = "kitty"
    },
  }


  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

