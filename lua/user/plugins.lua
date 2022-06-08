--------------------------------------
-- File         : plugins.lua
-- Description  : Lua K NeoVim & VimR plugins w/ packer
-- Author       : Kevin
-- Last Modified: 08 Jun 2022, 08:48
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
 pattern = "plugins.lua",
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


return packer.startup(function(use)
  -- Plugin/package manager (set packer manage itself)
  use {
    "wbthomason/packer.nvim",
    config = function()
      local custom_keymaps = {
        -- Packer
        p = {
          name = "Packer",
          C = { function() require("packer").compile() end, "Compile" },
          c = { function() require("packer").clean() end, "Clean" },
          i = { function() require("packer").install() end, "Install" },
          S = { function() require("packer").sync() end, "Sync" },
          s = { function() require("packer").status() end, "Status" },
          u = { function() require("packer").update() end, "Update" },
          l = { ":PackerLoad ", "Load"},
        },
      }
      require("which-key").register(custom_keymaps, { prefix = "<leader>", silent = false })
    end
  }

  -- Utils plugins
  use {
    {
      "nvim-lua/plenary.nvim",
      module = "plenary"
    },
    {
      "lewis6991/impatient.nvim",
      config = function() require "user.impatient" end,
    },
    {
      "nvim-lua/popup.nvim",
      module = "popup",
      cmd = "require",
    },

    { "moll/vim-bbye", event = "BufAdd" },
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
      config = function() require "user.illuminate" end,
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
      config = function() require "user.colorizer" end,
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
      config = function() require "user.nvim-tree" end,
      event = "VimEnter",
    },
    {
      "folke/which-key.nvim",
      run = "WhichKey",
      module = "which-key",
      config = function() require "user.whichkey" end,
      event = "VimEnter",
    },
    {
      "ghillb/cybu.nvim",
      event = "BufAdd",
      config = function() require "user.cybu" end,
    },
    {
      "akinsho/bufferline.nvim",
      tag = "*",
      event = "BufAdd",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function() require "user.bufferline" end,
    },
    {
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "Git" },
      module = "toggleterm",
      config = function() require "user.toggleterm" end,
    },
    {
      "goolord/alpha-nvim",
      event = "BufWinEnter",
      config = function() require "user.alpha" end,
    },
    {
      "rcarriga/nvim-notify",
      module = { "nvim-notify", "telescope._extensions.notify" },
      event = "BufWinEnter",
      config = function() require "user.notify" end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      event = "BufAdd",
      config = function() require "user.neoclip" end,
    }
  }

  -- Autocompletion & Snippets
  use { -- snippets engine and source
    { "hrsh7th/cmp-nvim-lsp", event = "BufAdd", module = "cmp_nvim_lsp" },
    { "kevinm6/the-snippets", event = "VimEnter" },
    { "L3MON4D3/LuaSnip", event = "BufAdd" },
    { "saadparwaiz1/cmp_luasnip", module = "luasnip", event = "BufAdd" },
    { "hrsh7th/cmp-buffer", event = "BufAdd" },
    { "ray-x/cmp-treesitter", event = "BufAdd" },
    { "hrsh7th/cmp-nvim-lsp-signature-help", event = "BufAdd" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "BufAdd" },
    { "rcarriga/cmp-dap", event = "BufAdd" },
    { "hrsh7th/cmp-path", event = "BufAdd" },
    { "hrsh7th/cmp-cmdline", event = "BufAdd" },
    { "tamago324/cmp-zsh", event = "BufAdd" },
    { "hrsh7th/cmp-calc", event = "BufAdd" },
    { "kdheepak/cmp-latex-symbols", ft = "markdown" },
    { "hrsh7th/cmp-emoji", opt = true  },
    { "dmitmel/cmp-digraphs", opt = true },
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function() require "user.cmp" end,
    }
  }

  -- Coding Helper
  use {
    {
      "kevinm6/nvim-gps",
      -- module = "nvim-gps",
      event = "BufAdd",
      config = function() require "user.gps" end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function() require "user.autopairs" end,
    },
    {
      "Mephistophiles/surround.nvim",
      event = "BufAdd",
      module = "surround",
      config = function() require "user.surround" end,
    },
    {
      "folke/todo-comments.nvim",
      event = "BufAdd",
      config = function() require "user.todo-comments" end,
    },
    {
      "numToStr/Comment.nvim",
      event = "BufAdd",
      config = function() require "user.comment" end,
    },
    {
      "phaazon/hop.nvim",
      event = "BufAdd",
      config = function() require "user.hop" end,
    },
    {
      "michaelb/sniprun",
      run = "bash ./install.sh",
      event = "InsertLeave",
      config = function() require "user.sniprun" end,
    },
    {
      "simrat39/symbols-outline.nvim",
      event = "InsertLeave",
      cmd = "SymbolsOutline",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function() require "user.symbol-outline" end,
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
    { "lewis6991/nvim-treesitter-context", event = "BufAdd" },
    { "windwp/nvim-ts-autotag", event = "BufAdd" },
    { "p00f/nvim-ts-rainbow", event = "BufAdd" },
    { "nvim-treesitter/nvim-treesitter-refactor", event = "BufAdd" },
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "BufAdd",
      module = { "treesitter", "lspconfig" },
      run = "TSUpdate",
      config = function() require "user.treesitter" end,
    },
  }


  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    module = "gitsigns",
    event = "BufAdd",
    config = function() require "user.gitsigns" end,
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
      config = function() require "user.telescope" end,
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
      requires = {
        { "Microsoft/java-debug", ft = "java" },
      },
    },

    -- database
    {
      "nanotee/sqls.nvim",
      -- module = "sqls",
      ft = { "sql", "mysql", "psql" },
      config = function() require "user.lsp.settings.sqls" end,
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
    config = function() require "user.xbase" end,
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
