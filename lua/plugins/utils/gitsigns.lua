-------------------------------------
-- File         : git.lua
-- Description  : git config
-- Author       : Kevin
-- Last Modified: 15/07/2025, 13:10
-------------------------------------

return {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  cond = function()
    return vim.fn.executable "git" == 1
  end,
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
    },
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    preview_config = {
      -- Options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
  config = function(_, o)
    local gitsigns = require "gitsigns"
    gitsigns.setup(o)

    -- Keymaps
    local nmap = require("lib.keys").nmap

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