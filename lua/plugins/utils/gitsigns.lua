-------------------------------------
-- File         : gitsigns.lua
-- Description  : Lua K NeoVim & VimR gitsigns config
-- Author       : Kevin
-- Last Modified: 02 Jul 2023, 10:41
-------------------------------------


local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  keys = {
    { "<leader>g", nil, mode = { "v", "n" }, desc = "Git" },
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
  end,
  config = function(_, o)
    require "gitsigns".setup(o)

    vim.keymap.set("n", "<leader>gj", function() require "gitsigns".next_hunk() end, { desc = "Next Hunk" })
    vim.keymap.set("n", "<leader>gk", function() require "gitsigns".prev_hunk() end, { desc = "Prev Hunk" })
    vim.keymap.set("n", "<leader>gl", function() require "gitsigns".blame_line() end, { desc = "Blame" })
    vim.keymap.set("n", "<leader>gp", function() require "gitsigns".preview_hunk() end, { desc = "Preview Hunk" })
    vim.keymap.set("n", "<leader>gr", function() require "gitsigns".reset_hunk() end, { desc = "Reset Hunk" })
    vim.keymap.set("n", "<leader>gR", function() require "gitsigns".reset_buffer() end, { desc = "Reset Buffer" })
    vim.keymap.set("n", "<leader>gS", function() require "gitsigns".stage_hunk() end, { desc = "Stage Hunk" })
    vim.keymap.set("n", "<leader>gu", function() require "gitsigns".undo_stage_hunk() end, { desc = "Undo Stage Hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>gd", function() require "gitsigns".diff_this() end, { desc = "Diff" })
    vim.keymap.set("n", "<leader>gt", function() require "gitsigns".toggle_current_line_blame() end, { desc = "Toggle Diff" })
    vim.keymap.set("n", "<leader>gL", function() require "gitsigns".toggle_linehl() end, { desc = "Toggle Linehl" })
    vim.keymap.set("n", "<leader>gW", function() require "gitsigns".toggle_word_diff() end, { desc = "Toggle Word diff" })
    vim.keymap.set("n", "<leader>gN", function() require "gitsigns".toggle_numhl() end, { desc = "Toggle Numhl" })

    require "knvim.plugins.gitsigns"
  end
}
return M