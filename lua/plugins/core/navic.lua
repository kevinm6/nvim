-----------------------------------
--	File         : navic.lua
--	Description  : gps-like plugin config
--	Author       : Kevin
--	Last Modified: 28 May 2023, 13:20
-----------------------------------

local M = {
   "SmiteshP/nvim-navic",
   event = "BufReadPre",
   opts = function(_, o)
      vim.g.navic_silence = false -- disable error messages
      local icons = require "user_lib.icons"

      o.icons = {
         -- ui
         Package       = icons.ui.Package .. " ",
         -- kinds
         File          = icons.kind.File .. " ",
         Module        = icons.kind.Module .. " ",
         Namespace     = icons.kind.Namespace .. " ",
         Class         = icons.kind.Class .. " ",
         Method        = icons.kind.Method .. " ",
         Property      = icons.kind.Property .. " ",
         Field         = icons.kind.Field .. " ",
         Constructor   = icons.kind.Constructor .. " ",
         Enum          = icons.kind.Enum .. " ",
         Interface     = icons.kind.Interface .. " ",
         Function      = icons.kind.Function .. " ",
         Variable      = icons.kind.Variable .. " ",
         Constant      = icons.kind.Constant .. " ",
         Key           = icons.kind.Keyword .. " ",
         Null          = icons.kind.Null .. " ",
         EnumMember    = icons.kind.EnumMember .. " ",
         Struct        = icons.kind.Struct .. " ",
         Event         = icons.kind.Event .. " ",
         Operator      = icons.kind.Operator .. " ",
         TypeParameter = icons.kind.TypeParameter .. " ",
         -- types
         String        = icons.type.String .. " ",
         Number        = icons.type.Number .. " ",
         Boolean       = icons.type.Boolean .. " ",
         Array         = icons.type.Array .. " ",
         Object        = icons.type.Object .. " ",
      }
      o.highlight = true

      o.separator = " "..icons.ui.ChevronRight.." "

      -- limit for amount of context shown
      -- 0 means no limit
      -- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
      -- in context names (eg: function names, class names, etc)
      o.depth_limit = 5

      o.safe_output = false

      o.depth_limit_indicator = "..."

      click = false
   end
}

return M
