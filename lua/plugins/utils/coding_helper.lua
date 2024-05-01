-------------------------------------
-- File         : coding_helper.lua
-- Description  : plugins that helps coding
-- Author       : Kevin
-- Last Modified: 01 May 2024, 12:32
-------------------------------------

return {
  ---Autopairs
  {
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
        Rule("<", ">"):with_pair(cond.before_regex "%a+"):with_move(function(o)
          return o.char == ">"
        end),
      }
    end
  },

  ---MiniSurround
  {
    'echasnovski/mini.surround',
    version = '*', -- stable version
    event = { "BufRead", "BufNewFile" },
    config = function(_, o)
      require('mini.surround').setup(o)
    end
  },

  ---TodoComments
  {
    "folke/todo-comments.nvim",
    enabled = false,
    cmd = { "TodoTelescope", "TodoLocList", "TodoQuickFix" },
    event = "BufRead",
    config = function(_, o)
      local icons = require "lib.icons"

      local error_red = "#F44747"
      local warning_orange = "#ff8800"
      local info_yellow = "#FFCC66"
      local hint_blue = "#4FC1FF"
      local perf_purple = "#7C3AED"
      o.keywords = {
        FIX = {
          icon = icons.ui.Bug,
          color = error_red,
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = icons.ui.Check, color = hint_blue, alt = { "TIP" } },
        HACK = { icon = icons.ui.Fire, color = warning_orange },
        WARN = { icon = icons.diagnostics.Warning, color = warning_orange, alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.ui.Dashboard, color = perf_purple, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.ui.Note, color = info_yellow, alt = { "INFO" } },
      }

      local todo_comments = require "todo-comments"
      todo_comments.setup(o)

      local function nmap(tbl)
        vim.keymap.set("n", tbl[1], tbl[2], { desc = "ToDo❭ "..tbl[3] })
      end

      nmap { "]t", todo_comments.jump_next, "Next" }
      nmap { "[t", todo_comments.jump_prev, "Prev" }
      nmap { "<leader>ftt", vim.cmd.TodoTelescope, "Telescope" }
      nmap { "<leader>ftq", vim.cmd.TodoQuickFix, "QuickFix" }
      nmap { "<leader>ftl", vim.cmd.TodoLocList, "LocList" }
    end
  }
}