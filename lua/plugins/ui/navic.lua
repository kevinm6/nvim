-----------------------------------
--	File         : navic.lua
--	Description  : gps-like plugin config
--	Author       : Kevin
--	Last Modified: 02 Jul 2023, 10:44
-----------------------------------

local M = {
  "SmiteshP/nvim-navic",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    -- disable error messages
    vim.g.navic_silence = false
  end,
  opts = function(_, o)
    local icons = require "lib.icons"

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

    o.safe_output = false
  end,
  config = function(_, o)
    require("nvim-navic").setup(o)
    require "knvim.plugins.navic"
  end
}

return M