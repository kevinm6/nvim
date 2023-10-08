--------------------------------------
-- File         : surround.lua
-- Description  : Surround config
-- Author       : Kevin
-- Last Modified: 02 Jul 2023, 10:52
--------------------------------------

local M = {
   "ur4ltz/surround.nvim",
   event = "BufRead",
   keys = {
      -- Normal & Visual Keymaps
      {
         mode = { "v", "n" },
         "s.",
         function()
            require("surround").repeat_last()
         end,
         desc = "Repeat",
      },
      {
         mode = { "v", "n" },
         "sa",
         function()
            require("surround").surround_add(true)
         end,
         desc = "Add",
      },
      {
         mode = { "v", "n" },
         "sd",
         function()
            require("surround").surround_delete()
         end,
         desc = "Delete",
      },
      {
         mode = { "v", "n" },
         "sr",
         function()
            require("surround").surround_replace()
         end,
         desc = "Replace",
      },
      {
         mode = { "v", "n" },
         "sq",
         function()
            require("surround").toggle_quotes()
         end,
         desc = "Quotes",
      },
      {
         mode = { "v", "n" },
         "sb",
         function()
            require("surround").toggle_brackets()
         end,
         desc = "Brackets",
      },
   },
   opts = function(_, o)
      o.load_keymaps = true
      o.pairs = {
         nestable = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
         linear = { { "'", "'" }, { "`", "`" }, { '"', '"' }, { "*", "*" } },
      }
   end,
}

return M
