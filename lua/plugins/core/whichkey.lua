-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 15 Jul 2023, 13:09
-------------------------------------


local M = {
   "folke/which-key.nvim",
   event = "VeryLazy",
   opts = function(_, o)
      local icons = require "user_lib.icons"

      o.plugins = {
         presets = {
            operators = false,
            motions = false,
            text_objects = false,
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
      o.hidden = { "<silent>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " } -- hide mapping boilerplate
      o.show_help = false
      o.show_keys = false
      o.triggers_blacklist = {
         i = { "j", "k" },
         v = { "j", "k" },
      }
   end,
}

return M
