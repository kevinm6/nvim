-------------------------------------
-- File         : coding_helper.lua
-- Description  : plugins that helps coding
-- Author       : Kevin
-- Last Modified: 18 Mar 2024, 18:41
-------------------------------------

local M = {
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
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- keys = {
    --    { "gc", mode = { "n", "v" } },
    --    { "gb", mode = { "n", "v" } },
    -- },
    opts = function(_, o)
      o.ignore = "^$"

      o.pre_hook = function(ctx)
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
        local javascript_filetypes = {
          typescriptreact = true,
          javascriptreact = true,
          javascript = true,
          typescript = true,
        }

        if javascript_filetypes[vim.bo.filetype] then
          local U = require "Comment.utils"

          -- Determine whether to use linewise or blockwise commentstring
          local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

          -- Determine the location where to calculate commentstring from
          local location = nil
          if ctx.ctype == U.ctype.blockwise then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils")
            .get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring {
            key = type,
            location = location,
          }
        end
      end
    end
  },
  {
    'echasnovski/mini.surround',
    version = '*', -- stable version
    event = { "BufRead", "BufNewFile" },
    config = function(_, o)
      require('mini.surround').setup(o)
    end
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoLocList", "TodoQuickFix" },
    event = "BufRead",
    dependencies = { "plenary.nvim" },
    opts = function(_, o)
      local icons = require "lib.icons"

      local error_red = "#F44747"
      local warning_orange = "#ff8800"
      local info_yellow = "#FFCC66"
      local hint_blue = "#4FC1FF"
      local perf_purple = "#7C3AED"
      o.keywords = {
        FIX = {
          icon = icons.ui.Bug,                     -- icon used for the sign, and in search results
          color = error_red,                       -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = icons.ui.Check, color = hint_blue, alt = { "TIP" } },
        HACK = { icon = icons.ui.Fire, color = warning_orange },
        WARN = { icon = icons.diagnostics.Warning, color = warning_orange, alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.ui.Dashboard, color = perf_purple, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.ui.Note, color = info_yellow, alt = { "INFO" } },
      }
    end,
    config = function(_, o)
      local todo_comments = require "todo-comments"
      todo_comments.setup(o)

      vim.keymap.set("n", "]t", function() todo_comments.jump_next() end,
        { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end,
        { desc = "Prev todo comment" })
      vim.keymap.set("n", "<leader>ftt", function() vim.cmd.TodoTelescope() end,
        { desc = "ToDo Telescope" })
      vim.keymap.set("n", "<leader>ftq", function() vim.cmd.TodoQuickFix() end,
        { desc = "ToDo QuickFix" })
      vim.keymap.set("n", "<leader>ftl", function() vim.cmd.TodoLocList() end,
        { desc = "ToDo LocList" })
    end
  }
}

return M