-------------------------------------
-- File         : git.lua
-- Description  : git config
-- Author       : Kevin
-- Last Modified: 01 May 2024, 12:32
-------------------------------------

return {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  keys = {
    { "<leader>g", nil, mode = { "v", "n" }, desc = require("lib.icons").git.Branch .. "Git" },
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
    local gitsigns = require "gitsigns"
    gitsigns.setup(o)

    -- Keymaps
    local function nmap(tbl)
      vim.keymap.set("n", tbl[1], tbl[2], { desc = require("lib.icons").git.Branch .. tbl[3] })
    end

    nmap {
      "<leader>gj",
      function()
        gitsigns.next_hunk()
      end,
      "Next Hunk",
    }
    nmap {
      "<leader>gk",
      function()
        gitsigns.prev_hunk()
      end,
      "Prev Hunk",
    }
    nmap {
      "<leader>gl",
      function()
        gitsigns.blame_line()
      end,
      "Blame",
    }
    nmap {
      "<leader>gp",
      function()
        gitsigns.preview_hunk()
      end,
      "Preview Hunk",
    }
    nmap {
      "<leader>gr",
      function()
        gitsigns.reset_hunk()
      end,
      "Reset Hunk",
    }
    nmap {
      "<leader>gR",
      function()
        gitsigns.reset_buffer()
      end,
      "Reset Buffer",
    }
    nmap {
      "<leader>gS",
      function()
        gitsigns.stage_hunk()
      end,
      "Stage Hunk",
    }
    nmap {
      "<leader>gu",
      function()
        gitsigns.undo_stage_hunk()
      end,
      "Undo Stage Hunk",
    }
    nmap {
      "<leader>gd",
      function()
        gitsigns.diffthis()
      end,
      "Diff",
    }
    nmap {
      "<leader>gt",
      function()
        gitsigns.toggle_current_line_blame()
      end,
      "Toggle Diff",
    }
    nmap {
      "<leader>gL",
      function()
        gitsigns.toggle_linehl()
      end,
      "Toggle Linehl",
    }
    nmap {
      "<leader>gW",
      function()
        gitsigns.toggle_word_diff()
      end,
      "Toggle Word diff",
    }
    nmap {
      "<leader>gN",
      function()
        gitsigns.toggle_numhl()
      end,
      "Toggle Numhl",
    }

    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#73C990", bg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#E1C08C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#b2555b", bg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "NonText" })
  end,
}