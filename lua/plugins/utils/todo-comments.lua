-----------------------------------
-- File         : todo-comments.lua
-- Description  : todo-comments plugin config
-- Author       : Kevin
-- Last Modified: 16 Sep 2023, 17:22
-----------------------------------

local M = {
   "folke/todo-comments.nvim",
   keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      { "<leader>ftt", function() vim.cmd.TodoTelescope() end, desc = "ToDo Telescope" },
      { "<leader>ftq", function() vim.cmd.TodoQuickFix() end, desc = "ToDo QuickFix" },
      { "<leader>ftl", function() vim.cmd.TodoLocList() end, desc = "ToDo LocList" },
   },
   cmd = { "TodoTelescope", "TodoLocList", "TodoQuickFix" } ,
   event = "BufReadPost",
   dependencies = { "nvim-lua/plenary.nvim" },
   opts = function(_, o)
      local icons = require "user_lib.icons"

      local error_red = "#F44747"
      local warning_orange = "#ff8800"
      local info_yellow = "#FFCC66"
      local hint_blue = "#4FC1FF"
      local perf_purple = "#7C3AED"
      o.keywords = {
         FIX = {
            icon = icons.ui.Bug, -- icon used for the sign, and in search results
            color = error_red, -- can be a hex color, or a named color (see below)
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
}

return M
