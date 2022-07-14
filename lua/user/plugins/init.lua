--------------------------------------
-- File         : init.lua
-- Description  : Package Manager (Packer) config
-- Author       : Kevin
-- Last Modified: 14 Jul 2022, 10:43
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

local ok, packer = pcall(require, "packer")
if not ok then return end

local p_util = require "packer.util"
local compile_path = p_util.join_paths(vim.fn.stdpath "config", "plugin", "packer_compiled.lua")

local icons = require "user.icons"


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
    open_fn = function() return require("packer.util").float { border = "rounded" } end,
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
      update         = 'pull --ff-only --progress --no-rebase',
      install        = 'clone --depth %i --no-single-branch --progress',
      fetch          = 'fetch --depth 999999 --progress',
      checkout       = 'checkout %s --',
      update_branch  = 'merge --ff-only @{u}',
      current_branch = 'branch --show-current',
      diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
      diff_fmt       = '%%h %%s (%%cr)',
      get_rev        = 'rev-parse --short HEAD',
      get_msg        = 'log --color=auto --pretty=format:FMT --no-show-signature HEAD -n 1',
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


return packer.startup(function(use)
  -- Plugin/package manager (set packer manage itself)
  use {
    "wbthomason/packer.nvim",
    config = function()
      local custom_keymaps = {
        -- Packer
        p = {
          name = "Packer",
          C = {
            function()
              require("packer").compile()
              vim.notify("File compiled", "Info", { title = "Packer", timeout = 2000 })
            end,
            "Compile"
          },
          c = { function() require("packer").clean() end, "Clean" },
          i = { function() require("packer").install() end, "Install" },
          S = { function() require("packer").sync() end, "Sync" },
          s = { function() require("packer").status() end, "Status" },
          u = { ":PackerUpdate ", "Update" },
          l = { ":PackerLoad ", "Load"},
        },
      }
      require("which-key").register(custom_keymaps, { prefix = "<leader>", silent = false })
    end
  }

  -- Utils plugins
  use {
    {
      "lewis6991/impatient.nvim",
      config = function() require "user.plugins.config.impatient" end,
    },
    {
      "nvim-lua/plenary.nvim",
      module = "plenary"
    },
    {
      "nvim-lua/popup.nvim",
      module = "popup",
      cmd = "require",
    },

    { "moll/vim-bbye", event = "BufAdd", cmd = { "Bdelete", "Bwipeout" } },
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
      event = "BufAdd",
      module = "illuminate",
      config = function() require "user.plugins.config.illuminate" end,
    },
    { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" },
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
    },
    {
      "br1anchen/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function() require "user.plugins.config.colorizer" end,
    },
    {
      "antoinemadec/FixCursorHold.nvim",
      event = "BufAdd",
    },
    {
      "ziontee113/color-picker.nvim",
      cmd = { "PickColor", "PickColorInsert" },
      config = function() require "user.plugins.config.color_picker" end,
    },
    {
      "kevinhwang91/nvim-ufo",
      requires = { "kevinhwang91/promise-async" },
      event = "BufAdd",
      config = function() require "user.plugins.config.ufo" end,
    },
    {
      "is0n/jaq-nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.jaq" end,
    }
  }

  -- Core plugins
  use {
    {
      "kyazdani42/nvim-tree.lua",
      module = "nvim-tree",
      config = function() require "user.plugins.config.nvim-tree" end,
      event = "VimEnter",
    },
    {
      "folke/which-key.nvim",
      module = "which-key",
      config = function() require "user.plugins.config.whichkey" end,
      event = "VimEnter",
    },
    {
      "ghillb/cybu.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.cybu" end,
    },
    {
      "akinsho/bufferline.nvim",
      tag = "*",
      event = "BufAdd",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function() require "user.plugins.config.bufferline" end,
    },
    {
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "Git" },
      module = "toggleterm",
      config = function() require "user.plugins.config.toggleterm" end,
    },
    {
      "goolord/alpha-nvim",
      event = "BufWinEnter",
      config = function() require "user.plugins.config.alpha" end,
    },
    {
      "rcarriga/nvim-notify",
      module = { "nvim-notify", "telescope._extensions.notify" },
      event = "BufWinEnter",
      config = function() require "user.plugins.config.notify" end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      event = "BufAdd",
      config = function() require "user.plugins.config.neoclip" end,
    },
    {
      "j-hui/fidget.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.fidget" end,
    },
    {
      "stevearc/dressing.nvim",
      event = "VimEnter",
      config = function() require "user.plugins.config.dressing" end,
    },
    {
      "lewis6991/spellsitter.nvim",
      opt = true,
      config = function () require "user.plugins.config.spellsitter" end,
    },
    {
      "lalitmee/browse.nvim",
      module = "browse",
      cmd = { "Browse" },
      requires = { "nvim-telescope/telescope.nvim" },
      config = function() require("user.browse") end,
    },
    {
      "rmagatti/auto-session",
      cmd = "",
      config = function() require "user.plugins.config.auto-session" end,
    }

  }

  -- Autocompletion & Snippets
  use { -- snippets engine and source
    { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp", after = "nvim-cmp" },
    { "kevinm6/the-snippets", module = "user.luasnip", after = "nvim-cmp" },
    {
      "L3MON4D3/LuaSnip",
      after = "nvim-cmp",
      module = "luasnip",
      config = function () require "user.plugins.config.luasnip" end,
    },
    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
    { "ray-x/cmp-treesitter", after = { "nvim-cmp", "nvim-treesitter" } },
    { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
    { "rcarriga/cmp-dap", after = "nvim-cmp" },
    { "hrsh7th/cmp-path", after = "nvim-cmp" },
    { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
    { "tamago324/cmp-zsh", after = "nvim-cmp", disable = true },
    { "hrsh7th/cmp-calc", after = "nvim-cmp" },
    { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", ft = "markdown" },
    { "hrsh7th/cmp-emoji", after = "nvim-cmp", opt = true },
    { "dmitmel/cmp-digraphs", after = "nvim-cmp", opt = true },
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function() require "user.plugins.config.cmp" end,
    }
  }

  -- Coding Helper
  use {
    {
      "SmiteshP/nvim-navic",
      module = "user.lsp",
      requires = "neovim/nvim-lspconfig",
      config = function() require "user.plugins.config.navic" end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function() require "user.plugins.config.autopairs" end,
    },
    {
      "Mephistophiles/surround.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.surround" end,
    },
    {
      "folke/todo-comments.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.todo-comments" end,
    },
    {
      "numToStr/Comment.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.comment" end,
    },
    {
      "phaazon/hop.nvim",
      event = "BufAdd",
      config = function() require "user.plugins.config.hop" end,
    },
    {
      "michaelb/sniprun",
      run = "bash ./install.sh",
      event = "InsertLeave",
      config = function() require "user.plugins.config.sniprun" end,
    },
    {
      "simrat39/symbols-outline.nvim",
      event = "InsertLeave",
      cmd = "SymbolsOutline",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function() require "user.plugins.config.symbol-outline" end,
    },
    {
      "folke/trouble.nvim",
      module = "trouble",
      cmd = "TroubleToggle",
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      module = "null-ls",
    },
  }


  -- Treesitter
  use {
    { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufAdd" },
    { "lewis6991/nvim-treesitter-context", event = "BufAdd", module = "treesitter" },
    { "windwp/nvim-ts-autotag", ft = { "html", "php", "xml" } },
    { "p00f/nvim-ts-rainbow", event = "BufAdd" },
    { "nvim-treesitter/nvim-treesitter-refactor", event = "BufAdd" },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "VimEnter",
      module = { "treesitter", "telescope" },
      run = ":TSUpdate",
      config = function() require "user.plugins.config.treesitter" end,
    },
    { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" } },
  }


  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    module = "gitsigns",
    event = "BufAdd",
    config = function() require "user.plugins.config.gitsigns" end,
  }


  -- Telescope
  use {
    {
      "nvim-telescope/telescope-media-files.nvim",
      cmd = "Telescope media_files",
      module = "telescope._extensions.media_files",
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      cmd = "Telescope file_browser",
      module = "telescope._extensions.file_browser",
    },
    {
      "nvim-telescope/telescope-packer.nvim",
      cmd = "Telescope packer",
      module = "telescope._extensions.packer",
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      cmd = "Telescope ui-select",
      module = "telescope._extensions.ui-select",
    },
    {
      "nvim-telescope/telescope-project.nvim",
      cmd = "Telescope project",
      module = "telescope._extensions.project",
    },
    {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      requires = { "nvim-lua/plenary.nvim" },
      config = function() require "user.plugins.config.telescope" end,
    }
  }


  -- LSP
  use {
    {
      "neovim/nvim-lspconfig",
      event = "BufAdd",
      module = { "lsp", "lspconfig" },
      cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
      config = function ()
        require "user.lsp.lsp-installer"
        require "user.lsp.init"
      end
    },
    {
      "williamboman/nvim-lsp-installer",
      module = "nvim-lsp-installer",
    },
    { -- Java
      "mfussenegger/nvim-jdtls",
      ft = "java",
      requires = "Microsoft/java-debug",
      config = function() require "user.lsp.configs.jdtls" end,
    },

    -- database
    {
      "nanotee/sqls.nvim",
      ft = { "sql", "mysql", "psql" },
      -- module = "sqls",
      -- config = function() require "user.lsp.configs.sqls" end,
    },

    -- Json
    {
      "b0o/SchemaStore.nvim",
      -- ft = "json",
      -- module = "schemastore",
      ft = "json"
    },
  }


  -- DAP (Debugging)
  use {
    {
      "mfussenegger/nvim-dap",
      module = "dap",
      event = "BufAdd",
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
      config = function() require ("jupyter-nvim").setup({}) end,
    },
    {
      "jupyter-vim/jupyter-vim",
      ft = "ipynb"
    }, -- work with Python envs and render in QTconsole
    {
      "bfredl/nvim-ipy",
      ft = "ipy",
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
  "xbase-lab/xbase",
    run = "make install",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "xcodeproj", "swift", "cpp", "objective-c" },
    config = function() require "user.plugins.config.xbase" end,
  }

  -- themes
  use {
    {
      "ellisonleao/gruvbox.nvim",
      cmd = "colorscheme",
    },
    {
      "Shatur/neovim-ayu",
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
