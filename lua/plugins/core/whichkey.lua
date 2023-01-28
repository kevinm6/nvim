-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 28 Jan 2023, 19:24
-------------------------------------

local icons = require "user.icons"

local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
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
	},
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    wk.register(
      {
        mode = { "n", "v" },
        ["<leader>0"] = { name = "Configuration File" },
        ["<leader>S"] = { name = "Sessions" },
        ["<leader>d"] = { name = "Dap" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>C"] = { name = "Slime" },
        ["<leader>R"] = { name = "Run" },
        ["<leader>l"] = { name = "Lsp" },
        ["<leader>n"] = { name = "Notifications" },
        ["<leader>f"] = { name = "Find" },
        ["<leader>t"] = { name = "Terminal" },
        ["<leader>T"] = { name = "Treesitter" },
        ["<leader>y"] = { name = "Yank" },
        ["<leader>u"] = { name = "University Folder" },
        ["<leader>s"] = { name = "Surround" },
        ["<leader>W"] = { name = "Window" },
      })


  end

}

return M
