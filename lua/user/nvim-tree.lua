-------------------------------------
-- File         : nvimtree.lua
-- Description  : NvimTree config
-- Author       : Kevin
-- Last Modified: 31/03/2022 - 13:55
-------------------------------------

local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then return end

local icons = require "user.icons"


vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = icons.git.unstaged,
    staged = icons.git.staged,
    unmerged = icons.git.unmerged,
    renamed = icons.git.renamed,
    untracked = icons.git.untracked,
    deleted = icons.git.deleted,
    ignored = icons.git.ignored,
  },
  folder = {
    arrow_open = " ",
    arrow_close = " ",
    default = icons.kind.Folder,
    open = icons.documents.OpenFolder,
    empty = " ",
    empty_open = " ",
    symlink = " ",
    symlink_open = " ",
  },
}

vim.g.nvim_tree_special_files = {
  ["README.md"] = true
}


local lib = require "nvim-tree.lib"
local view = require "nvim-tree.view"


local function trash_file()
  local path = lib.get_node_at_cursor().absolute_path
  local name = lib.get_node_at_cursor().name

  print("Trash < " .. name .. " > ? (y/n) ")
  local ans = require("nvim-tree.utils").get_user_input_char()
  require("nvim-tree.utils").clear_prompt()
  if ans:match "^y" then
    vim.fn.system("mv " .. vim.fn.fnameescape(path) .. " ~/.Trash")
    vim.cmd "NvimTreeRefresh"
    vim.notify(" " .. name .. " moved to Bin!", "Warn")
  end
end

local function vsplit_preview()
  -- open as vsplit on current node
  local action = "vsplit"
  local node = lib.get_node_at_cursor()

  -- Just copy what's done normally with vsplit
  if node.link_to and not node.nodes then
    require("nvim-tree.actions.open-file").fn(action, node.link_to)
  elseif node.nodes ~= nil then
    lib.expand_or_collapse(node)
  else
    require("nvim-tree.actions.open-file").fn(action, node.absolute_path)
  end
  -- Finally refocus on tree if it was lost
  view.focus()
end

nvim_tree.setup {
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_cursor = true,
  hijack_netrw = false, -- overriden if 'disable_netrw = true'
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = true,
  open_on_setup_file = false,
  open_on_tab = false,
  update_cwd = true,
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = true,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = { -- custom mappings
        { key = { "l", "<CR>", "o" }, action = "edit" },
        { key = { "-", "<BS>"}, action = "dir_up" },
        { key = { "<Esc>", "q" }, action = "close" },
        { key = "h", action = "close_node" },
        { key = "L", action = "cd" },
        { key = ".", action = "cd" },
        { key = "O", action = "system_open" },
        { key = "s", action = "split" },
        { key = "<C-h>", action = "collapse_all" },
        { key = "v", action = "vsplit" },
        { key = "V", action = "vsplit_preview", action_cb = vsplit_preview },
        { key = "p", action = "preview" },
        { key = "^", action = "parent_node" },
        { key = "/", action = "search" },
        { key = "D", action = "trash", action_cb = trash_file },
        { key = "?", action = "toggle_help" },
        },
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "after",
    }
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  ignore_ft_on_setup = { "alpha" },
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.diagnostics.Hint,
      info = icons.diagnostics.Information,
      warning = icons.diagnostics.Warning,
      error = icons.diagnostics.Error,
    },
  },
  filters = {
    dotfiles = false,
    custom = { ".git/", ".cache", ".DS_Store" },
    exclude = {},
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  }
}
