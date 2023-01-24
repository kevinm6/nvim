-------------------------------------
-- File         : oil.lua
-- Description  : oil plugin config
-- Author       : Kevin
-- Last Modified: 24 Jan 2023, 09:34
-------------------------------------

local M = {
  "stevearc/oil.nvim",
  -- event = "VimEnter",
  keys = {
    { "<leader>O", function() require "oil".open() end, desc = "Open in Oil" }
  },
  opts = {
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
      { "permissions", highlight = "String" },
      { "mtime", highlight = "Comment" },
      { "size", highlight = "Type" },
      "icon",
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    -- Restore window options to previous values when leaving an oil buffer
    restore_win_options = true,
    -- Skip the confirmation popup for simple operations
    skip_confirm_for_simple_edits = false,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
    -- Additionally, if it is a string that matches "action.<name>",
    -- it will use the mapping at require("oil.action").<name>
    -- Set to `false` to remove a keymap
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-l>"] = "actions.select",
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-g>"] = "actions.parent",
      ["<C-h>"] = "actions.toggle_hidden",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
    },
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    },
    adapters = {
      ["oil://"] = "files",
      ["oil-ssh://"] = "ssh",
    },
    -- When opening the parent of a file, substitute these url schemes
    remap_schemes = {
      ["scp://"] = "oil-ssh://",
      ["sftp://"] = "oil-ssh://",
    },
  }
}

return M
