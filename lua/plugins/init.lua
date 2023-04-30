-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 30 Apr 2023, 08:48
-------------------------------------

local M = {
   "nvim-lua/plenary.nvim",

   { "tweekmonster/startuptime.vim", cmd = "StartupTime", enabled = false },

   {
      "kyazdani42/nvim-web-devicons",
      opts = { default = true },
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
      opts = {
         window = {
            backdrop = 1,
            height = 0.8, -- height of the Zen window
            width = 0.85,
            options = {
               signcolumn = "no", -- disable signcolumn
               number = false, -- disable number column
               relativenumber = false, -- disable relative numbers
               cursorline = true, -- disable cursorline
            },
         },
         plugins = {
            gitsigns = { enabled = false }, -- disables git signs
            tmux = { enabled = false },
            twilight = { enabled = true },
         },
      },
   },

   {
      "kevinm6/hologram.nvim",
      cmd = "Hologram",
      dev = true,
      ft = { "md", "markdown" },
      opts = { auto_display = true },
   },

   {
      "simrat39/inlay-hints.nvim",
      -- ft = { "java", "go", "lua" },
      enabled = false,
      opts = {
         only_current_line = true,
         eol = { right_align = true },
      },
   },

   {
      "ziontee113/color-picker.nvim",
      cmd = { "PickColor", "PickColorInsert" },
      opts = {
         ["icons"] = { "ﱢ", "" },
         ["border"] = "rounded",
      },
   },

   {
      "NvChad/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
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
      },
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
      "fladson/vim-kitty",
      ft = "kitty",
      enabled = false,
   },

   {
      "turbio/bracey.vim",
      ft = { "markdown", "html", "css", "js" },
      build = "npm install --prefix server",
   },

   {
      "phaazon/mind.nvim",
      version = "v2.2",
      dependencies = "nvim-lua/plenary.nvim",
      cmd = { "MindOpenMain", "MindOpenProject", "MindOpenSmartProject", "MindClose" },
      config = function()
         require("mind").setup {}
      end,
   },
}

return M
