-------------------------------------
-- File: neo-tree.lua
-- Description: Neo-tree config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/neo-tree.lua
-- Last Modified: 24/03/2022 - 15:11
-------------------------------------


local ok, neo_tree = pcall(require, "neo-tree")
if not ok then return end

local icons = require "user.icons"


neo_tree.setup {
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = icons.ui.ChevronRight,
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "✚",
        modified  = "",
        conflict  = "",
        unstaged = icons.git.unstaged,
        staged = icons.git.staged,
        unmerged = icons.git.unmerged,
        renamed = icons.git.renamed,
        untracked = icons.git.untracked,
        deleted = icons.git.deleted,
        ignored = icons.git.ignored,
        -- deleted   = "✖",
        -- renamed   = "",
        -- Status type
        -- untracked = "",
        -- ignored   = "",
        -- unstaged  = "",
        -- staged    = "",
      }
    },
    icon = {
      folder_closed = icons.kind.Folder,
      folder_open = icons.documents.OpenFolder,
      folder_empty = "ﰊ",
      default = "*",
    },
    name = {
      trailing_slash = true,
      use_git_status_colors = true,
    },
  },
  window = {
    position = "left",
    width = 30,
    mappings = {
      ["<space>"] = "toggle_node",
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["l"] = "open",
      ["o"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["C"] = "close_node",
      ["<bs>"] = "navigate_up",
      ["-"] = "navigate_up",
      ["."] = "set_root",
      ["H"] = "toggle_hidden",
      ["R"] = "refresh",
      ["/"] = "fuzzy_finder",
      ["f"] = "filter_on_submit",
      ["<c-x>"] = "clear_filter",
      ["a"] = "add",
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
    }
  },
  renderers = {
     directory = {
      { "indent" },
      { "icon" },
      { "current_filter" },
      { "name" },
      -- {
      --   "symlink_target",
      --   highlight = "NeoTreeSymbolicLinkTarget",
      -- },
      { "clipboard" },
      { "diagnostics", errors_only = true },
      --{ "git_status" },
    },
    file = {
      { "indent" },
      { "git_status" },
      { "diagnostics" },
      { "icon" },
      {
        "name",
        use_git_status_colors = true,
      },
      { "bufnr" },
      { "clipboard" },
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
        "Icon"
        --"node_modules"
      },
      never_show = { -- remains hidden even if visible is toggled to true
        --".DS_Store",
        --"thumbs.db"
      },
    },
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
  },
  buffers = {
    show_unloaded = true,
    bind_to_cwd = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
      }
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"]  = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      }
    }
  }
}


vim.api.nvim_set_keymap("n", "€", "<cmd>Neotree reveal <cr>", { silent = true, noremap = true })
