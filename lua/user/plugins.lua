--------------------------------------
-- File         : plugins.lua
-- Description  : Lua K NeoVim & VimR plugins w/ packer
-- Author       : Kevin
-- Last Modified: 29/05/2022 - 11:03
--------------------------------------

-- install packer if not found in default location
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

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
local compile_path = p_util.join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua")

vim.api.nvim_create_autocmd("BufWritePost", {
 group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
 pattern = "user/plugins.lua",
 callback = function()
   vim.cmd("source <afile>")
   packer.compile(compile_path)

   vim.notify(
   " Plugins file update & compiled !", "Info", {
     title = "Packer",
   })
 end,
})

packer.init {
  package_root = p_util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = compile_path,
  max_jobs = 20,
  ensure_dependecies = true,
  plugin_package = "packer",
  auto_reload_compiled = true,
  auto_clean = true, -- During sync(), remove unused plugins
  compile_on_sync = true, -- During sync(), run packer.compile()
  disable_commands = false, -- Disable creating commands
  opt_default = false, -- Default to using opt (as opposed to start) plugins
  transitive_opt = true, -- Make dependencies of opt plugins also opt by default
  transitive_disable = true, -- Automatically disable dependencies of disabled plugins
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
   git = {
    cmd = 'git', -- The base command for git operations
    subcommands = { -- Format strings for git subcommands
      update         = 'pull --ff-only --progress --rebase=false',
      install        = 'clone --depth %i --no-single-branch --progress',
      fetch          = 'fetch --depth 999999 --progress',
      checkout       = 'checkout %s --',
      update_branch  = 'merge --ff-only @{u}',
      current_branch = 'branch --show-current',
      diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
      diff_fmt       = '%%h %%s (%%cr)',
      get_rev        = 'rev-parse --short HEAD',
      get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
      submodules     = 'submodule update --init --recursive --progress'
    },
    depth = 1, -- Git clone depth
    clone_timeout = 60, -- Timeout, in seconds, for git clones
    default_url_format = 'https://github.com/%s' -- Lua format string used for "aaa/bbb" style plugins
  },
  profile = {
    enable = false,
    threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
  },
  autoremove = false, -- Remove disabled or unused plugins without prompting the user
}

--
-- local wk = require "which-key"
--
-- wk.register({
--  p = {
--    name = "Packer",
--    l = { ":PackerLoad ", "Load plugin" }
--  }
-- }, {
--  mode = "n", -- NORMAL mode
--  prefix = "<leader>",
--  buffer = nil,
--  silent = false,
--  noremap = true,
--  nowait = true,
-- })

return packer.startup(function(use)
  -- Plugin/package manager (set packer manage itself)
  use "wbthomason/packer.nvim"

  -- Utils plugins
  use {
    "nvim-lua/plenary.nvim",
    {
      "lewis6991/impatient.nvim",
      config = { 'require "user.impatient"' },
    },
    "nvim-lua/popup.nvim",
    { "moll/vim-bbye", event = "VimEnter" },
    {
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
    },
    {
      "MunifTanjim/nui.nvim",
      cmd = "require",
    },
    {
      "RRethy/vim-illuminate",
      module = "illuminate",
      config = { 'require "user.illuminate"' },
    },
    { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" },
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
    },
    {
      "br1anchen/nvim-colorizer.lua",
      event = "BufAdd",
      cmd = "ColorizerToggle",
      config = { 'require "user.colorizer"' },
    },
    {
      "antoinemadec/FixCursorHold.nvim",
      event = "BufAdd",
    },
  }

  -- Core plugins
  use {
    {
      "kyazdani42/nvim-tree.lua",
      module = "nvim-tree",
      config = { 'require "user.nvim-tree"' },
      event = "VimEnter",
    },
    {
      "folke/which-key.nvim",
      run = "WhichKey",
      config = { 'require "user.whichkey"' },
      event = "VimEnter",
    },
    {
      "ghillb/cybu.nvim",
      event = "BufAdd",
      config = { 'require "user.cybu"' },
    },
    {
      "akinsho/bufferline.nvim",
      tag = "*",
      event = "BufAdd",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = { 'require "user.bufferline"' },
    },
    {
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "Git", "_LAZYGIT_TOGGLE", "_NCDU_TOGGLE", "_HTOP_TOGGLE" },
      module = "toggleterm",
      config = { 'require "user.toggleterm"' },
    },
    {
      "goolord/alpha-nvim",
      config = { 'require "user.alpha"' },
    },
    {
      "rcarriga/nvim-notify",
      config = { 'require "user.notify"' },
    },
  }

  -- Autocompletion & Snippets
  use { -- snippets engine and source
    { "hrsh7th/cmp-nvim-lsp", event = "BufWinEnter", module = "cmp_nvim_lsp" },
    { "kevinm6/the-snippets", event = "BufWinEnter" },
    { "L3MON4D3/LuaSnip", event = "VimEnter" },
    { "saadparwaiz1/cmp_luasnip", module = "luasnip" },
    { "hrsh7th/cmp-buffer", event = "VimEnter" },
    { "ray-x/cmp-treesitter", event = "VimEnter" },
    { "hrsh7th/cmp-nvim-lsp-signature-help", event = "VimEnter" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "VimEnter" },
    { "rcarriga/cmp-dap", event = "VimEnter" },
    { "hrsh7th/cmp-path", event = "VimEnter" },
    { "hrsh7th/cmp-cmdline", event = "VimEnter" },
    { "tamago324/cmp-zsh", event = "VimEnter" },
    { "hrsh7th/cmp-calc", event = "VimEnter" },
    { "kdheepak/cmp-latex-symbols", ft = "markdown" },
    { "hrsh7th/cmp-emoji", opt = true  },
    { "dmitmel/cmp-digraphs", opt = true },
    {
      "hrsh7th/nvim-cmp",
      event = "VimEnter",
      config = { 'require "user.cmp"' },
    }
  }

  -- Coding Helper
  use {
    {
      "kevinm6/nvim-gps",
      -- module = "nvim-gps",
      event = "VimEnter",
      config = { 'require "user.gps"' },
    },
    {
      "windwp/nvim-autopairs",
      event = "BufWinEnter",
      config = { 'require "user.autopairs"' },
    },
    {
      "Mephistophiles/surround.nvim",
      event = "BufWinEnter",
      config = { 'require "user.surround"' },
    },
    {
      "folke/todo-comments.nvim",
      event = "BufWinEnter",
      config = { 'require "user.todo-comments"' },
    },
    {
      "numToStr/Comment.nvim",
      event = "BufWinEnter",
      config = { 'require "user.comment"' },
    },
    {
      "phaazon/hop.nvim",
      event = "BufReadPost",
      config = { 'require "user.hop"' },
    },
    {
      "michaelb/sniprun",
      run = "bash ./install.sh",
      event = "InsertLeave",
      config = { 'require "user.sniprun"' },
    },
    {
      "simrat39/symbols-outline.nvim",
      event = "InsertLeave",
      cmd = "SymbolsOutline",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = { 'require "user.symbol-outline"' },
    },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      module = "null-ls",
      cmd = "Format",
    },
  }


  -- Treesitter
  use {
    { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufWinEnter" },
    { "lewis6991/nvim-treesitter-context", event = "VimEnter" },
    { "windwp/nvim-ts-autotag", event = "BufWinEnter" },
    { "p00f/nvim-ts-rainbow", event = "BufWinEnter" },
    { "nvim-treesitter/nvim-treesitter-refactor", event = "BufWinEnter" },
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "BufReadPre",
      module = "treesitter",
      run = "TSUpdate",
      config = { 'require "user.treesitter"' },
    },
  }


  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    module = "gitsigns",
    config = { 'require "user.gitsigns"' },
  }


  -- Telescope
  use {
    { "nvim-telescope/telescope-media-files.nvim", event = "BufWinEnter" },
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-packer.nvim", event = "BufWinEnter" },
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-project.nvim", event = "BufWinEnter" },
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make", event = "BufReadPre" },
    {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      event = "BufWinEnter",
      requires = { "nvim-lua/plenary.nvim" },
      config = { 'require "user.telescope"' },
    }
  }


  -- LSP
  use {
    {
      "neovim/nvim-lspconfig",
      event = "BufAdd",
      module = "lsp",
      cmd = "LspInfo",
      config = { 'require "user.lsp"' },
    },
    {
      "williamboman/nvim-lsp-installer",
      event = "BufWinEnter",
      module = "lsp-lspinstaller",
    },
    { -- Java
      "mfussenegger/nvim-jdtls",
      ft = "java",
      requires = {
        { "Microsoft/java-debug", ft = "java" },
      },
    },

    -- database
    {
      "nanotee/sqls.nvim",
      -- module = "sqls",
      ft = { "sql", "mysql", "psql" },
      config = { 'require "user.lsp.settings.sqls"' },
    },

    -- Json
    {
      "b0o/SchemaStore.nvim",
      -- ft = "json",
      module = "schemastore",
    },
  }


  -- DAP (Debugging)
  use {
    {
      "mfussenegger/nvim-dap",
      module = "dap",
      event = "BufReadPost",
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      after = "nvim-dap",
    },
    {
      "Pocco81/DAPInstall.nvim",
      after = "nvim-dap",
    },
  }


  -- Python
  use { -- Render jupyter notebook (in alpha version)
    {
      "ahmedkhalf/jupyter-nvim",
      run = ":UpdateRemotePlugins",
      ft = "ipynb",
      config = { 'require ("jupyter-nvim").setup({})' },
    },
    {
      "jupyter-vim/jupyter-vim",
      ft = "ipynb"
    }, -- work with Python envs and render in QTconsole
    {
      "bfredl/nvim-ipy",
      ft = "ipy",
      opt = true,
    },
  }


  -- markdown
  use {
    "ellisonleao/glow.nvim",
    ft = { "md", "markdown" },
    cmd = "Glow",
  }
  use {
    {
      "iamcco/markdown-preview.nvim",
      ft = { "md", "markdown" },
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
    },
    {
      "dhruvasagar/vim-table-mode",
      ft = { "md", "markdown" },
      cmd = "TableModeToggle"
    },
    {
      "mbpowers/nvimager",
      cmd = "NvimagerToggle",
    },
  }

  -- pdf
  use {
    "makerj/vim-pdf",
    ft = "pdf",
  }

  -- Xcode Integration
  use {
    "tami5/xbase",
      run = "make install",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      },
    opt = true,
    config = { 'require "user.xbase"' },
  }

  -- themes
  use {
    {
      "ellisonleao/gruvbox.nvim",
      opt = true,
      cmd = "colorscheme",
    },
    {
      "Shatur/neovim-ayu",
      opt = true,
      cmd = "colorscheme",
    },
    {
      "fladson/vim-kitty",
      ft = "kitty"
    },
  }

  if PACKER_BOOTSTRAP then
    require ("packer").sync()
  end

end)
