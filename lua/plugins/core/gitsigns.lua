-------------------------------------
-- File         : gitsigns.lua
-- Description  : Lua K NeoVim & VimR gitsigns config
-- Author       : Kevin
-- Last Modified: 02 Jul 2023, 10:41
-------------------------------------

local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>g", nil, mode = { "v", "n" }, desc = "Git" },
    { "<leader>gj", function() require "gitsigns".next_hunk() end, desc = "Next Hunk" },
    { "<leader>gk", function() require "gitsigns".prev_hunk() end, desc = "Prev Hunk" },
    { "<leader>gl", function() require "gitsigns".blame_line() end, desc = "Blame" },
    { "<leader>gp", function() require "gitsigns".preview_hunk() end, desc = "Preview Hunk" },
    { "<leader>gr", function() require "gitsigns".reset_hunk() end, desc = "Reset Hunk" },
    { "<leader>gR", function() require "gitsigns".reset_buffer() end, desc = "Reset Buffer" },
    { "<leader>gS", function() require "gitsigns".stage_hunk() end, desc = "Stage Hunk" },
    { "<leader>gu", function() require "gitsigns".undo_stage_hunk() end, desc = "Undo Stage Hunk" },
    { "<leader>gd", function() require "gitsigns".diff_this() end, mode = { "n", "v" }, desc = "Diff" },
    { "<leader>gt", function() require "gitsigns".toggle_current_line_blame() end, desc = "Toggle Diff" },
    { "<leader>gL", function() require "gitsigns".toggle_linehl() end, desc = "Toggle Linehl" },
    { "<leader>gW", function() require "gitsigns".toggle_word_diff() end, desc = "Toggle Word diff" },
    { "<leader>gN", function() require "gitsigns".toggle_numhl() end, desc = "Toggle Numhl" },
  },
   opts = function(_, o)
    o.signs = {
      add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    }
    o.watch_gitdir = {
      interval = 1000,
      follow_files = true,
    }
    o.current_line_blame_formatter_opts = {
      relative_time = false,
    }
    o.preview_config = {
      -- Options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    }
   end
}

return M
