-----------------------------------
--	File: twilight.lua
--	Description: twilight plugin config
--	Author: Kevin
--	Last Modified: 14 May 2023, 10:27
-----------------------------------

local M = {
   "folke/twilight.nvim",
   cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
   opts = function(_, o)
      o.dimming = {
         alpha = 0.25, -- amount of dimming
         -- we try to get the foreground from the highlight groups or fallback color
         color = { "Normal", "#ffffff" },
         term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
         inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      }
      o.context = 10 -- amount of lines we will try to show around the current line
      o.treesitter = true -- use treesitter when available for the filetype
      -- treesitter is used to automatically expand the visible text,
      -- but you can further control the types of nodes that should always be fully expanded
      o.expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
         "function",
         "method",
         "table",
         "if_statement",
      }
      o.exclude = {} -- exclude these filetypes
   end,
}

return M
