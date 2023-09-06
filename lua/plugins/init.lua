-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 24 Sep 2023, 12:04
-------------------------------------

local M = {
   {
      "nvim-lua/plenary.nvim",
      lazy = true,
   },

   { "nvim-tree/nvim-web-devicons", lazy = true },

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
      ft = { "markdown" },
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
      opts = function(_, o)
         local icons = require "user_lib.icons"
         o.symbols = {
            File = { icon = icons.kind.File, hl = "@text.uri" },
            Module = { icon = icons.kind.Module, hl = "@namespace" },
            Namespace = { icon = icons.kind.Namespace, hl = "@namespace" },
            Package = { icon = icons.ui.Package, hl = "@namespace" },
            Class = { icon = icons.kind.Class, hl = "@type" },
            Method = { icon = icons.kind.Method, hl = "@method" },
            Property = { icon = icons.kind.Property, hl = "@method" },
            Field = { icon = icons.kind.Field, hl = "@field" },
            Constructor = { icon = icons.kind.Constructor, hl = "@constructor" },
            Enum = { icon = icons.kind.Enum, hl = "@type" },
            Interface = { icon = icons.kind.Interface, hl = "@type" },
            Function = { icon = icons.kind.Function, hl = "@function" },
            Variable = { icon = icons.kind.Variable, hl = "@constant" },
            Constant = { icon = icons.kind.Constant, hl = "@constant" },
            String = { icon = icons.type.String, hl = "@string" },
            Number = { icon = icons.type.Number, hl = "@number" },
            Boolean = { icon = icons.type.Boolean, hl = "@boolean" },
            Array = { icon = icons.type.Array, hl = "@constant" },
            Object = { icon = icons.type.Object, hl = "@type" },
            Key = { icon = icons.kind.Keyword, hl = "@type" },
            Null = { icon = icons.kind.Null, hl = "@type" },
            EnumMember = { icon = icons.kind.EnumMember, hl = "@field" },
            Struct = { icon = icons.kind.Struct, hl = "@type" },
            Event = { icon = icons.kind.Event, hl = "@type" },
            Operator = { icon = icons.kind.Operator, hl = "@operator" },
            TypeParameter = { icon = icons.kind.TypeParameter, hl = "@parameter" },
            Component = { icon = icons.kind.Field, hl = "@function" },
            Fragment = { icon = icons.kind.Field, hl = "@constant" }, }
      end
   },

   -- DB
   {
      "tpope/vim-dadbod",
      ft = {
         "sql", "pgsql"
      },
      dependencies = {
         "kristijanhusak/vim-dadbod-ui",
         "kristijanhusak/vim-dadbod-completion"
      },
      config = function()
         require("config.dadbod").setup()
      end
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
      enabled = true,
      config = true
   },
}

return M
