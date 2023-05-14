--------------------------------------
-- File         : surround.lua
-- Description  : Surround config
-- Author       : Kevin
-- Last Modified: 13 May 2023, 12:08
--------------------------------------

local M = {
   "ur4ltz/surround.nvim",
   event = "BufReadPre",
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
      o.context_offset = 100
      o.load_autogroups = false
      o.load_keymaps = true
      o.mappings_style = "sandwich"
      o.map_insert_mode = true
      o.quotes = { "'", '"' }
      o.brackets = { "(", "{ ", "[" }
      o.space_on_closing_char = false
      o.pairs = {
         nestable = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
         linear = { { "'", "'" }, { "`", "`" }, { '"', '"' }, { "*", "*" } },
      }
      o.prefix = "s"
   end,
}

return M
