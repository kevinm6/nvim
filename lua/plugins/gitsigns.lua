-------------------------------------
-- File         : gitsigns.lua
-- Description  : Lua K NeoVim & VimR gitsigns config
-- Author       : Kevin
-- Last Modified: 02 Jan 2023, 11:40
-------------------------------------

local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>gj", function() require "gitsigns".next_hunk() end, desc = "Next Hunk" },
    { "<leader>gk", function() require "gitsigns".prev_hunk() end, desc = "Prev Hunk" },
    { "<leader>gl", function() require "gitsigns".blame_line() end, desc = "Blame" },
    { "<leader>gp", function() require "gitsigns".preview_hunk() end, desc = "Preview Hunk" },
    { "<leader>gr", function() require "gitsigns".reset_hunk() end, desc = "Reset Hunk" },
    { "<leader>gR", function() require "gitsigns".reset_buffer() end, desc = "Reset Buffer" },
    { "<leader>gs", function() require "gitsigns".stage_hunk() end, desc = "Stage Hunk" },
    { "<leader>gu", function() require "gitsigns".undo_stage_hunk() end, desc = "Undo Stage Hunk" },
    { "<leader>gd", function() require "gitsigns".diff_this() end, desc = "Diff" },
    { "<leader>gt", function() require "gitsigns".toggle_current_line_blame() end, desc = "Toggle Diff" },
  },
  cond = function()
    return vim.loop.fs_stat ".git"
  end,
}

function M.config()
  local gitsigns = require "gitsigns"

  gitsigns.setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  }
end

return M