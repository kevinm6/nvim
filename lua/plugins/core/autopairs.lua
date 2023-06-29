-------------------------------------
-- File         : autopairs.lua
-- Description  : Lua K NeoVim & VimR autopairs config
-- Author       : Kevin
-- Last Modified: 15 Jul 2023, 09:06
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
      o.map_c_h = true
      o.disable_filetype = { "TelescopePrompt", "Alpha", "vim", "text" }
      o.fast_wrap = {
         map = "<C-s>",
         pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
         highlight = "PmenuSel",
         highlight_grey = "LineNr",
      }
   end,
   config = function(_, opts)
      local npairs = require "nvim-autopairs"
      local cond = require "nvim-autopairs.conds"
      local Rule = require "nvim-autopairs.rule"

      npairs.setup(opts)

      npairs.add_rules {
         ---@diagnostic disable-next-line: redefined-local
         Rule("<", ">"):with_pair(cond.before_regex "%a+"):with_move(function(opts)
            return opts.char == ">"
         end),
      }
   end,
}

return M
