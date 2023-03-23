-------------------------------------
-- File         : oil.lua
-- Description  : oil plugin config
-- Author       : Kevin
-- Last Modified: 24 Mar 2023, 08:46
-------------------------------------

local M = {
  "stevearc/oil.nvim",
  event = "VimEnter",
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
    buf_options = {
      buflisted = false,
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
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
    default_file_explorer = true,
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
    use_default_keymaps = false,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
      is_hidden_file = function (name, bufnr)
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function (name, bufnr)
        return false
      end
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
    -- Configuration for the actions floating preview window
    preview = {
      -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_width and max_width can be a single value or a list of mixed integer/float types.
      -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
      max_width = 0.9,
      -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
      min_width = { 40, 0.4 },
      -- optionally define an integer/float for the exact width of the preview window
      width = nil,
      -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_height and max_height can be a single value or a list of mixed integer/float types.
      -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
      max_height = 0.9,
      -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
      min_height = { 5, 0.1 },
      -- optionally define an integer/float for the exact height of the preview window
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
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
