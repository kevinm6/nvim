-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 28 May 2023, 13:16
-------------------------------------

local icons = require "user_lib.icons"

local M = {
   "folke/which-key.nvim",
   event = "VeryLazy",
   opts = function(_, o)
      o.plugins = {
         marks = true,
         registers = true,
         spelling = {
            enabled = true,
            suggestions = 20,
         },
         presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = true,
            nav = true,
            z = true,
            g = true,
         },
      }
      o.icons = {
         breadcrumb = icons.ui.ChevronRight,
         separator = icons.ui.WhichKeySep,
         group = icons.ui.List .. " ",
      }
      o.popup_mappings = {
         scroll_down = "<c-d>",
         scroll_up = "<c-u>",
      }
      o.window = {
         border = "none",
         position = "bottom",
         margin = { 0, 3, 1, 3 }, -- extra window margin [top, right, bottom, left]
         padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
         winblend = 10,
      }
      o.layout = {
         height = { min = 4, max = 24 },
         width = { min = 20, max = 46 },
         spacing = 3,
         align = "center",
      }
      o.ignore_missing = false
      o.hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " } -- hide mapping boilerplate
      o.show_help = false
      o.show_keys = false
      o.triggers_blacklist = {
         i = { "j", "k" },
         v = { "j", "k" },
      }
   end,
   config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
         mode = { "n", "v" },
         ["<leader>0"] = { name = "Configuration File" },
         ["<leader>S"] = { name = "Sessions" },
         ["<leader>d"] = { name = "Dap" },
         ["<leader>C"] = { name = "Core" },
         ["<leader>g"] = { name = "Git" },
         ["<leader>R"] = { name = "Run" },
         ["<leader>l"] = { name = "Lsp" },
         ["<leader>n"] = { name = "Notifications" },
         ["<leader>f"] = { name = "Find" },
         ["<leader>t"] = { name = "Terminal" },
         ["<leader>T"] = { name = "Treesitter" },
         ["<leader>y"] = { name = "Yank" },
         ["<leader>U"] = { name = "University Folder" },
         ["<leader>s"] = { name = "Surround" },
         ["<leader>W"] = { name = "Window" },
      }
   end,
}

return M
