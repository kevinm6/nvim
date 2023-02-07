-----------------------------------
--	File         : navic.lua
--	Description  : gps-like plugin config
--	Author       : Kevin
--	Last Modified: 07 Feb 2023, 18:53
-----------------------------------

local M = {
  "SmiteshP/nvim-navic",
  event = "BufReadPre",
  -- dependencies = "neovim/nvim-lspconfig",
}

function M.config()
  local navic = require "nvim-navic"
  local icons = require "util.icons"
  vim.g.navic_silence = false -- disable error messages

  -- Customized config
  navic.setup {
    icons = {
      ["class-name"] = icons.kind.Class,
      ["function-name"] = icons.kind.Function,
      ["method-name"] = icons.kind.Method,
      ["container-name"] = icons.type.Object,
      ["tag-name"] = icons.misc.Tag,
      ["mapping-name"] = icons.type.Object,
      ["sequence-name"] = icons.type.Array,
      ["null-name"] = icons.kind.Field,
      ["boolean-name"] = icons.type.Boolean,
      ["integer-name"] = icons.type.Number,
      ["float-name"] = icons.type.Number,
      ["string-name"] = icons.type.String,
      ["array-name"] = icons.type.Array,
      ["object-name"] = icons.type.Object,
      ["number-name"] = icons.type.Number,
      ["table-name"] = icons.ui.Table,
      ["date-name"] = icons.ui.Calendar,
      ["date-time-name"] = icons.ui.Table,
      ["inline-table-name"] = icons.ui.Calendar,
      ["time-name"] = icons.misc.Watch,
      ["module-name"] = icons.kind.Module,
    },
    highlight = true,

    separator = " " .. icons.ui.ChevronRight .. " ",

    -- limit for amount of context shown
    -- 0 means no limit
    -- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
    -- in context names (eg: function names, class names, etc)
    depth_limit = 5,

    -- indicator used when context is hits depth limit
    depth_limit_indicator = icons.ui.ChevronRight .. "..." .. icons.ui.ChevronLeft,
  }
end

return M
