----------------------------------------
--  File         : noice.lua
--  Description  : noice plugin configuration
--  Author       : Kevin
--  Last Modified: 26 Dec 2024, 11:05
----------------------------------------

return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function(_, o)
      o.stages = "fade"
      o.on_open = nil
      o.on_close = nil
      o.render = "default"
      o.timeout = 1600

      -- For stages that change opacity this is treated as the highlight behind the window
      -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
      o.background_colour = "#2c2c2c"

      -- Minimum width for notification windows
      o.minimum_width = 12

      o.max_height = function()
        return math.floor(vim.o.lines * 0.3)
      end
      o.max_width = function()
        return math.floor(vim.o.columns * 0.6)
      end

      -- Icons for the different levels
      o.icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = " ",
        TRACE = " ",
      }

      local notify = require "notify"
      notify.setup(o)
      vim.notify = notify
    end,
  },
}
