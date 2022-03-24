 -------------------------------------
 -- File: nvimtree.lua
 -- Description: NvimTree config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/nvimtree.lua
 -- Last Modified: 24/03/2022 - 15:11
 -------------------------------------


local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then return end

local icons = require "user.icons"

vim.g.nvim_tree_icons = {
  default = " ",
  symlink = " ",
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
		-- arrow_open = " ",
		-- arrow_close = " ",
		default = icons.kind.Folder,
		open = icons.documents.OpenFolder,
    empty = " ",
    empty_open = " ",
    symlink = " ",
  },
}

vim.g.nvim_tree_special_files = {
	["README.md"] = true
}


local lib = require "nvim-tree.lib"
local view = require "nvim-tree.view"

local function collapse_all()
    require("nvim-tree.actions.collapse-all").fn()
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
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = true,
  ignore_ft_on_setup = { "alpha" },
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
			hint = icons.diagnostics.Hint,
			info = icons.diagnostics.Information,
			warning = icons.diagnostics.Warning,
			error = icons.diagnostics.Error,
			question = icons.diagnostics.Question,
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
    custom = { ".git", ".cache", ".DS_Store", "Icon" },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
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
				{ key = { "l", "<CR>", "o" }, action = "edit" },
				{ key = { "-", "<BS>"}, action = "dir_up" },
				{ key = "h", action = "close_node" },
				{ key = "L", action = "cd" },
				{ key = "]", action = "cd" },
				{ key = "O", action = "system_open" },
				{ key = "s", action = "split" },
				{ key = "<C-h>", action = "collapse_all", action_cb = collapse_all },
				{ key = "v", action = "vsplit" },
				{ key = "V", action = "vsplit_preview", action_cb = vsplit_preview },
				{ key = "p", action = "preview" },
				{ key = "<C-p>", action = "parent_node" },
				{ key = "?", action = "toggle_help" },
				{ key = "<Esc>", action = "toggle_help" },
      },
    },
    number = false,
    relativenumber = true,
  },
  trash = {
    cmd = "mv",
    require_confirm = true,
  },
  quit_on_open = 0,
  git_hl = 1,
  disable_window_picker = 0,
  root_folder_modifier = ":t",
  show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
    tree_width = 30,
  },
}
