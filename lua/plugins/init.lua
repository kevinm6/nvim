-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 06 Jul 2023, 12:24
-------------------------------------

local M = {
   {
      "nvim-lua/plenary.nvim",
      lazy = true,
   },

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
            vim.notify(("%s:\n%s"):format("Error loading theme < knvim >", knvim), vim.log.levels.INFO)
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
            desc = "ZenMode",
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
      end,
   },

   {
      "3rd/image.nvim",
      enabled = false,
      ft = { "org", "markdown" },
      init = function()
         package.path = package.path .. ";/Users/Kevin/.luarocks.share/lua/5.1/?/init.lua;"
         package.path = package.path .. ";/Users/Kevin/.luarocks.share/lua/5.1/?.lua;"
      end,
      opts = function(_, o)
         o.backend = "kitty"
         o.integrations = {
            markdown = {
               enabled = true,
               sizing_strategy = "auto",
               download_remote_images = true,
               clear_in_insert_mode = false,
            }
         }
      end,
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
      config = true,
   },

   {
      "simrat39/symbols-outline.nvim",
      event = "LspAttach",
      cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
      keys = {
         {
            "<leader>lO",
            function()
               require("symbols-outline").toggle_outline()
            end,
            desc = "Symbols Outline",
         },
      },
      config = true,
   },

   -- Java
   {
      "mfussenegger/nvim-jdtls",
      dependencies = { "mfussenegger/nvim-dap" },
      ft = "java",
   },

   -- Scala
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

   -- Dev Docs
   {
      "sunaku/vim-dasht",
      cmd = "Dasht",
   },

   -- Lua dev
   {
      "folke/neodev.nvim",
      enabled = false,
      config = true
   },
}

return M
