-----------------------------------------
-- File         : winbar.lua
-- Description  : Personal winbar config w/ navic
-- Author       : Kevin Manca
-- Last Modified: 06 Sep 2023, 12:54
-----------------------------------------

local M = {
   dir = "~/.config/nvim/lua/core/winbar.lua",
}

local function is_not_empty(s)
   return s ~= nil and s ~= ""
end

M.filename = function()
   local default_file_icon = require "user_lib.icons".kind.File
   local filename = vim.fn.expand "%:t"

   if is_not_empty(filename) then
      local file_icon = ""
      local extension = vim.fn.expand "%:e"

      file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(
         filename,
         extension,
         { default = not is_not_empty(extension) or false }
      )

      return string.format(
         "%%#FileIconColor%s#%s%%* %s",
         extension,
         file_icon or default_file_icon,
         filename
      )
   end
end

M.get_winbar = function()
   local icons = require "user_lib.icons"
   local has_navic, navic = pcall(require, "nvim-navic")
   local location = has_navic and navic.get_location() or nil

   local retval = M.filename()

   return is_not_empty(location)
         and string.format(
            "%s %%#NavicSeparator# %s %%* %s",
            retval,
            icons.ui.ChevronRight,
            location
         )
      or retval
end

return M
