-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 14 Jan 2023, 10:24
-------------------------------------

local M = {
  "folke/which-key.nvim",
  event = "BufEnter",
  keys = {
    { "<leader>" },
  }
}

function M.config()
	local wk = require "which-key"
	local icons = require "user.icons"

	wk.setup {
	  plugins = {
	    marks = true,
	    registers = true,
	    spelling = {
	      enabled = true,
	      suggestions = 20,
	    },
	    presets = {
	      operators = false,
	      motions = false,
	      text_objects = false,
	      windows = true,
	      nav = true,
	      z = true,
	      g = true,
	    },
	  },
	  icons = {
	    breadcrumb = icons.ui.ChevronRight,
	    separator = icons.git.Rename,
	    group = icons.ui.List .. " ",
	  },
	  popup_mappings = {
	    scroll_down = "<c-d>",
	    scroll_up = "<c-u>",
	  },
	  window = {
	    border = "none",
	    position = "bottom",
	    margin = { 0, 3, 1, 3 }, -- extra window margin [top, right, bottom, left]
	    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
	    winblend = 10,
	  },
	  layout = {
	    height = { min = 4, max = 24 },
	    width = { min = 20, max = 46 },
	    spacing = 3,
	    align = "center",
	  },
	  ignore_missing = false,
	  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	  show_help = false,
	  show_keys = false,
	  triggers_blacklist = {
	    i = { "j", "k" },
	    v = { "j", "k" },
	  },
	}

  wk.register(
    {
      ['0'] = { name = "Configuration File" },
      A = { name = "Sessions" },
      d = { name = "Dap" },
      g = { name = "Git" },
      l = { name = "Lsp" },
      n = { name = "Notifications" },
      f = { name = "Find" },
      t = { name = "Terminal" },
      T = { name = "Treesitter" },
      u = { name = "University Folder" },
      s = { name = "Surround" },
      W = { name = "Window" },
    }, {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    }
  )
end

return M
