-------------------------------------
-- File         : lualine.lua
-- Description  : lualine plugin config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/lualine.lua
-- Last Modified: 19/04/2022 - 10:28
-------------------------------------

local ok, lualine = pcall(require, "lualine")
if not ok then return end

local gps_ok, gps = pcall(require, "nvim-gps")
if not gps_ok then return end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local icons = require "user.icons"


local filename = {
  "filename",
  icon_enabled = true,
  icon = nil,
  file_status = true,
  path = 0,
  shorting_target = 46,
  symbols = {
    modified = "[+]",
    readonly = "[-]",
    unnamed = "[No Name]",
  },
  fmt = function(str)
    return '%6*' .. str .. '%m'
  end
}


local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info", "hints" },
  symbols = {
    error = icons.diagnostics.Error .. ":",
    warn = icons.diagnostics.Warning .. ":",
    info = icons.diagnostics.Information .. ":",
    hints = icons.diagnostics.Hint .. ":",
  },
  colored = false,
  update_in_insert = false,
  always_visible = true,
  cond = hide_in_width,
  color = "Comment"
}

local diff = {
  "diff",
  colored = true,
  diff_color = {
    added = 'User2',
    modified = 'User2',
    removed = 'User2',
  },
  symbols = {
    added = "+" .. " ",
    modified = "~" .. " ",
    removed = "-" .. " "
  },
  cond = hide_in_width,
  source = function()
    return vim.b.gitsigns_status_dict or {head = "", added = 0, changed = 0, removed = 0}
  end,
}

-- local mode = {
--   "mode",
--   fmt = function(str)
--     return "-- " .. str .. " --"
--   end,
-- }

local filetype = {
  "filetype",
  icons_enabled = true,
  icon = nil,
  colored = false,
  icon_only = false,
  fmt = function(str)
    return '%1*' .. '[' ..  str .. ']'
  end,
}


local encoding = {
  "encoding",
  icons_enabled = true,
  icon = nil,
  colored = false,
  icon_only = false,
  fmt = function(str)
    return '%3*' .. str
  end,
}


local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
  color = "User2",
}


local function nvim_gps()
  return gps.is_available() and hide_in_width and
   "%5*" .. gps.get_location() or ""
end

local function line_on_Tot()
	return hide_in_width() and
    "%3*row %2*%l%3*÷%L" or
    "%2*%l%3*÷%L"
end

vim.opt.laststatus = 3

lualine.setup {
  options = {
    icons_enabled = true,
    theme = nil,
    component_separators = {
      left = icons.ui.SlChevronRight,
      right = icons.ui.SlChevronLeft,
    },
    section_separators = {
      left = icons.ui.SlChevronRight,
      right = icons.ui.SlChevronLeft,
    },
    disabled_filetypes = { "alpha", "dashboard", "toggleterm" },
    always_divide_middle = true,
  },
  sections = {
    -- lualine_a = { branch, diagnostics },
    lualine_a = { branch, diff },
    lualine_b = { filename },
    -- lualine_c = { _gps },
    lualine_c = { nvim_gps },

    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { diagnostics },
    lualine_y = { encoding, filetype },
    lualine_z = { line_on_Tot },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { "filesize" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},

  extensions = { "nvim-tree" },
}

vim.opt.laststatus = 3
