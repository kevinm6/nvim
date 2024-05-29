-------------------------------------
-- File         : coding_helper.lua
-- Description  : plugins that helps coding
-- Author       : Kevin
-- Last Modified: 01 May 2024, 12:32
-------------------------------------

return {
  ---Autopairs
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",
    opts = function(_, o)
      o.mappings = {
        ["<"] = { action = "open", pair = "<>", neigh_pattern = "^r.", register = { cr = false } },
        [">"] = { action = "close", pair = "<>", register = { cr = false } },
      }
    end,
  },
  {
    "windwp/nvim-autopairs",
    enabled = false,
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
        Rule("<", ">"):with_pair(cond.before_regex "%a+"):with_move(function(o)
          return o.char == ">"
        end),
      }
    end,
  },

  ---Surround
  {
    "echasnovski/mini.surround",
    version = "*", -- stable version
    event = { "BufRead", "BufNewFile" },
    config = true,
  },
}
