-----------------------------------
--	File         : navic.lua
--	Description  : gps-like plugin config
--	Author       : Kevin
--	Last Modified: 13 Jun 2022, 10:16
-----------------------------------

local ok, navic = pcall(require, "nvim-navic")
if not ok then return end

local icons = require "user.icons"

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
  depth_limit = 0,

  -- indicator used when context is hits depth limit
  depth_limit_indicator = icons.ui.ChevronRight .. "..." .. icons.ui.ChevronLeft,
}
