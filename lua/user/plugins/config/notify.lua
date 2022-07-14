-----------------------------------
--	File         : notify.lua
--	Description  : notify plugin configuration
--	Author       : Kevin
--	Last Modified: 16/04/2022 - 18:26
-----------------------------------

local ok, notify = pcall(require, "notify")
if not ok then return end

local icons = require "user.icons"

notify.setup {
  -- Animation style (see below for details)
  stages = "fade",

  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,

  -- Function called when a window is closed
  on_close = nil,

  -- Render function for notifications. See notify-render()
  render = "default",

  -- Default timeout for notifications
  timeout = 1000,

  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
  background_colour = "#2c2c2c",

  -- Minimum width for notification windows
  minimum_width = 12,

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
