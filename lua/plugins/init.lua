-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 13 May 2023, 11:25
-------------------------------------

local M = {
   "nvim-lua/plenary.nvim",

   { "tweekmonster/startuptime.vim", cmd = "StartupTime", enabled = false },

   {
      "kyazdani42/nvim-web-devicons",
      config = true,
   },

   {
      "kevinm6/knvim-theme.nvim",
      dev = true,
      lazy = false,
      priority = 100,
      config = function()
         local has_theme, knvim = pcall(require, "knvim")
         if not has_theme then
            vim.notify(("%s:\n%s"):format("Error loading theme < knvim >", knvim), "Info")
         end
         require("knvim").setup()
      end,
   },

   {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      keys = {
         {
            mode = "n",
            "<leader>Z",
            function()
               vim.cmd.ZenMode()
            end,
            desc = "Zen",
         },
      },
      opts = function(_, o)
         o.window = {
            backdrop = 1,
            height = 0.8, -- height of the Zen window
            width = 0.85,
            options = {
               signcolumn = "no", -- disable signcolumn
               number = false, -- disable number column
               relativenumber = false, -- disable relative numbers
               cursorline = true, -- disable cursorline
            },
         }
         o.plugins = {
            gitsigns = { enabled = false }, -- disables git signs
            tmux = { enabled = false },
            twilight = { enabled = true },
         }
      end
   },

   {
      "kevinm6/hologram.nvim",
      cmd = "Hologram",
      dev = true,
      -- ft = { "md", "markdown" },
      opts = { auto_display = true },
   },

   {
      "ziontee113/color-picker.nvim",
      cmd = { "PickColor", "PickColorInsert" },
      opts = {
         ["icons"] = { "", "" },
         ["border"] = "rounded",
      },
   },

   {
      "NvChad/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      opts = function(_, opts)
         opts = {
            filetypes = { "*" },
            user_default_options = {
               RGB = true, -- #RGB hex codes
               RRGGBB = true, -- #RRGGBB hex codes
               names = true, -- "Name" codes like Blue oe blue
               AARRGGBB = false, -- 0xAARRGGBB hex codes
               rgb_fn = false, -- CSS rgb() and rgba() functions
               hsl_fn = false, -- CSS hsl() and hsla() functions
               css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
               css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
               -- Available modes: foreground, background, virtualtext
               mode = "background", -- Set the display mode.)
               -- Available methods are false / true / "normal" / "lsp" / "both"
               -- True is same as normal
               tailwind = false, -- Enable tailwind colors
               -- parsers can contain values used in |user_default_options|
               sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
               virtualtext = "■",
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
         }
         return opts
      end
   },

   {
      "mfussenegger/nvim-jdtls",
      dependencies = { "mfussenegger/nvim-dap" },
      ft = "java",
   },

   {
      "scalameta/nvim-metals",
      ft = "scala",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "mfussenegger/nvim-dap",
      },
   },

   -- Json
   {
      "b0o/SchemaStore.nvim",
      ft = "json",
   },

   {
      "sunaku/vim-dasht",
      cmd = "Dasht",
   },

   {
      "turbio/bracey.vim",
      ft = { "markdown", "html", "css", "js" },
      build = "npm install --prefix server",
   },

   {
      "folke/neodev.nvim",
      opts = function(_, o)
         o.library = {
            enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
            -- these settings will be used for your Neovim config directory
            runtime = true, -- runtime path
            types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
            plugins = true, -- installed opt or start plugins in packpath
            -- you can also specify the list of plugins to make available as a workspace library
            -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
         }
         o.setup_jsonls = true -- configures jsonls to provide completion for project specific .luarc.json files
         -- for your Neovim config directory, the config.library settings will be used as is
         -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
         -- for any other directory, config.library.enabled will be set to false
         o.override = function(root_dir, options) end
         -- With lspconfig, Neodev will automatically setup your lua-language-server
         -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
         -- in your lsp start options
         o.lspconfig = true
         -- much faster, but needs a recent built of lua-language-server
         -- needs lua-language-server >= 3.6.0
         o.pathStrict = true
      end
   },
}

return M
