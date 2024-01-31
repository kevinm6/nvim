-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 25 Oct 2023, 10:25
-------------------------------------


local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, o)
    local icons = require "lib.icons"

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
    o.window = {
      border = "rounded",
      position = "bottom",
      margin = { 0, 3, 1, 3 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 8,
    }
    o.layout = {
      height = { min = 4, max = 24 },
      width = { min = 20, max = 46 },
      spacing = 3,
      align = "center",
    }
    o.show_help = false
  end,
}

return M