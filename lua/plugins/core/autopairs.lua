-------------------------------------
-- File         : autopairs.lua
-- Description  : Lua K NeoVim & VimR autopairs config
-- Author       : Kevin
-- Last Modified: 28 May 2023, 20:13
-------------------------------------

local M = {
   "windwp/nvim-autopairs",
   event = "InsertEnter",
   opts = function(_, o)
      o.check_ts = true
      o.ts_config = {
         lua = { "string", "source" },
         javascript = { "string", "template_string" },
         java = true,
      }
      o.break_undo = true
      o.map_c_w = true
      o.map_c_h = false
      o.enable_check_bracket_line = true
      o.disable_filetype = { "TelescopePrompt", "Alpha" }
      o.fast_wrap = {
         map = "<C-e>",
         chars = { "{", "[", "(", '"', "'" },
         pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
         offset = 0, -- Offset from pattern match
         end_key = "$",
         keys = "qwertyuiopzxcvbnmasdfghjkl",
         check_comma = true,
         highlight = "PmenuSel",
         highlight_grey = "LineNr",
      }
   end
}

return M
