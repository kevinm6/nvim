-----------------------------------
--	File         : notify.lua
--	Description  : notify plugin configuration
--	Author       : Kevin
--	Last Modified: 07 Feb 2023, 18:51
-----------------------------------

local M = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
}

function M.config()
	local notify = require "notify"
	local icons = require "util.icons"

	notify.setup {
	  -- Animation style (see below for details)
	  stages = "fade",
    fps = 20,

	  -- Function called when a new window is opened, use for changing win settings/config
	  on_open = nil,

	  -- Function called when a window is closed
	  on_close = nil,

	  -- Render function for notifications. See notify-render()
	  render = "default",

	  -- Default timeout for notifications
	  timeout = 1600,

	  -- For stages that change opacity this is treated as the highlight behind the window
	  -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
	  background_colour = "#2c2c2c",

	  -- Minimum width for notification windows
	  minimum_width = 12,

    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,

	  -- Icons for the different levels
	  icons = {
	    ERROR = icons.diagnostics.Error,
	    WARN = icons.diagnostics.Warning,
	    INFO = icons.diagnostics.Information,
	    DEBUG = icons.ui.Bug,
	    TRACE = icons.ui.Pencil,
	  },
	}

	vim.notify = notify
end

return M
