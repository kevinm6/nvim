-------------------------------------
-- File         : nvimtree.lua
-- Description  : NvimTree config
-- Author       : Kevin
-- Last Modified: 07 Feb 2023, 18:51
-------------------------------------

local M = {
  "kyazdani42/nvim-tree.lua",
  enabled = false,
  cmd = "NvimTree",
  keys = {
    { "<leader>E", function() require "nvim-tree".toggle() end, desc = "Open Nvim-Tree window" }
  }
}

-- custom trash-file function
local function trash_file()
  local api = require "nvim-tree.api"
  local node = api.tree.get_node_under_cursor()

  local function get_user_input_char()
    local c = vim.fn.getchar()
    return vim.fn.nr2char(c)
  end

  print("Trash < " .. node.name .. " > ? (y/n) ")

  if node and (get_user_input_char():match("^y")) then
    vim.fn.jobstart("mv " .. vim.fn.fnameescape(node.absolute_path) .. " ~/.Trash", {
      detach = true,
      on_exit = function()
        vim.notify(" " .. node.name .. " moved to Bin!", "Warn")
        api.tree.reload()
      end,
    })
  end
  vim.api.nvim_command "normal :esc<CR>"
end

-- open as vsplit on current node
local function vsplit_preview()
  local api = require "nvim-tree.api"

  local node = api.tree.get_node_under_cursor()

  if node.link_to and not node.nodes then
    api.tree.open(node.link_to)
  elseif node.nodes ~= nil then
    api.node.edit() -- expand or collaps if on folder
  else
    api.node.open.vertical()
  end
  api.tree.focus()
end

function M.config()
  local nvim_tree = require "nvim-tree"
  local icons = require "util.icons"
  local api = require "nvim-tree.api"


  nvim_tree.setup {
    auto_reload_on_write = true,
    disable_netrw = true,
    hijack_cursor = true,
    hijack_netrw = true, -- overriden if 'disable_netrw = true'
    hijack_unnamed_buffer_when_opening = true,
    ignore_buffer_on_setup = false,
    open_on_setup = true,
    open_on_setup_file = false,
    open_on_tab = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    respect_buf_cwd = true,
    sort_by = "case_sensitive",
    filesystem_watchers = {
      enable = true,
      debounce_delay = 100,
    },
    view = {
      width = 34,
      adaptive_size = false,
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
          { key = { "-", "<BS>" }, action = "dir_up" },
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
      add_trailing = true,
      group_empty = false,
      highlight_git = false,
      highlight_opened_files = "name",
      root_folder_modifier = ":t",
      indent_markers = {
        enable = true,
        icons = {
          corner = "└",
          edge = "│",
          none = " ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "after",
        glyphs = {
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
            arrow_closed = " ",
            default = icons.kind.Folder,
            open = icons.documents.OpenFolder,
            empty = " ",
            empty_open = " ",
            symlink = " ",
            symlink_open = " ",
          },
        },
      },
      special_files = {
        ["README.md"] = true
      },
    },
    hijack_directories = {
      enable = true,
      auto_open = false,
    },
    update_focused_file = {
      enable = true,
      update_root = true,
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
        resize_window = true,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "help" },
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
end

return M
