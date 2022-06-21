-------------------------------------
--  File         : cybu.lua
--  Description  : cybu plugin config
--  Author       : Kevin
--  Last Modified: 21 Jun 2022, 10:26
-------------------------------------

local ok, cybu = pcall(require, "cybu")
if not ok then return end

cybu.setup {
  position = {
     relative_to = "win", -- win, editor, cursor
     anchor = "topcenter",
     vertical_offset = 0.5, -- vertical offset from anchor in lines
     horizontal_offset = 0, -- vertical offset from anchor in columns
     max_win_height = 6, -- height of cybu window in lines
     max_win_width = 0.5, -- integer for absolute in columns
  },
  display_time = 1500, -- time the cybu window is displayed
  style = {
    path = "relative", -- absolute, relative, tail (filename only)
    border = "rounded", -- single, double, rounded, none
    separator = " ", -- string used as separator
    prefix = "…", -- string used as prefix for truncated paths
    padding = 2, -- left & right padding in number of spaces
    hide_buffer_id = true,
    devicons = {
      enabled = true, -- enable or disable web dev icons
      colored = true, -- enable color for web dev icons
    },
    highlights = {                -- see highlights via :highlight
      current_buffer = "LspReferenceWrite",    -- used for the current buffer
      adjacent_buffers =  "LspReferenceRead", -- used for buffers not in focus
      background = "WhichKeyFloat",        -- used for the window background
      border = "WinSeparator",
    },
  },
  exclude = {                     -- filetypes, cybu will not be active
    "NvimTree",
    "qf",
    "alpha",
  },
  fallback = function() end,
}

vim.keymap.set("n", "H", "<Plug>(CybuPrev)")
vim.keymap.set("n", "L", "<Plug>(CybuNext)")
