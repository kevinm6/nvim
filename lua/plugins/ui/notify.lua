-----------------------------------
--	File         : notify.lua
--	Description  : notify plugin configuration
--	Author       : Kevin
--	Last Modified: 13 May 2023, 11:13
-----------------------------------

local M = {
   "rcarriga/nvim-notify",
   event = "VeryLazy",
   opts = function(_, o)
      -- Animation style (see below for details)
      o.stages = "fade"
      o.fps = 20

      -- Function called when a new window is opened, use for changing win settings/config
      o.on_open = nil

      -- Function called when a window is closed
      o.on_close = nil

      -- Render function for notifications. See notify-render()
      o.render = "default"

      -- Default timeout for notifications
      o.timeout = 1600

      -- For stages that change opacity this is treated as the highlight behind the window
      -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
      o.background_colour = "#2c2c2c"

      -- Minimum width for notification windows
      o.minimum_width = 12

      o.max_height = function()
         return math.floor(vim.o.lines * 0.75)
      end
      o.max_width = function()
         return math.floor(vim.o.columns * 0.75)
      end

      -- Icons for the different levels
      o.icons = {
         ERROR = require "util.icons".diagnostics.Error,
         WARN = require "util.icons".diagnostics.Warning,
         INFO = require "util.icons".diagnostics.Information,
         DEBUG = require "util.icons".ui.Bug,
         TRACE = require "util.icons".ui.Pencil,
      }
   end
}

function M.config()
   local notify = require "notify"
   vim.notify = notify
end

return M
