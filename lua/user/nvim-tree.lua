 -------------------------------------
 -- File: nvim-tree.lua
 -- Description:
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/nvim-tree.lua
 -- Last Modified: 11/01/22 - 15:03
 -------------------------------------

vim.g.nvim_tree_icons = {
  default = " ",
  symlink = " ",
 --  git = {
	-- 	unstaged = "✗",
 --    staged = "✓",
 --    unmerged = "",
 --    renamed = "➜",
 --    untracked = "★",
 --    deleted = "",
	-- },
  folder = {
    -- arrow_open = " ",
    -- arrow_closed = "",
    default = " ",
    open = " ",
    empty = " ",
    empty_open = " ",
    symlink = " ",
  },
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = true,
  ignore_ft_on_setup = {},
  auto_close = false,
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = true,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
			hint = "",
			info = "¡",
			warning = "!",
			error = "𝒙",
			question = "?"
     },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = false,
    ignore = false,
    timeout = 60,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
				{ key = "p", cb = tree_cb "preview" },
				{ key = "<C-p>", cb = tree_cb "parent_node" }
      },
    },
    number = true,
    relativenumber = true,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  quit_on_open = 0,
  -- git_hl = 0,
  disable_window_picker = 0,
  root_folder_modifier = ":t",
  show_icons = {
    -- git = 0,
    folders = 1,
    files = 1,
    folder_arrows = 1,
    tree_width = 18,
  },
}

