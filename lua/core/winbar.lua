-----------------------------------------
-- File         : winbar.lua
-- Description  : Personal winbar config w/ navic
-- Author       : Kevin Manca
-- Last Modified: 28 May 2023, 13:18
-----------------------------------------

local M = {
   "~/.config/nvim/lua/core/winbar.lua",
}

local navic = require "nvim-navic"
local icons = require "user_lib.icons"

local function isempty(s)
   return s == nil or s == ""
end

M.filename = function()

   local filename = vim.fn.expand "%:t"

   local extension = ""
   local file_icon = ""

   local default_file_icon = icons.kind.File
   -- local file_icon_color = ""
   -- local default_file_icon_color = ""

   if not isempty(filename) then
      extension = vim.fn.expand "%:e"

      local default = false

      if isempty(extension) then
         extension = ""
         default = true
      end

      file_icon, file_icon_color =
         require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

      local hl_group = "FileIconColor" .. extension
      -- vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color or default_file_icon_color })

      return string.format(" %%#%s#%s %s", hl_group, file_icon or default_file_icon .. "%*", filename)
   end
end

M.gps = function()
   local location = navic.get_location()
   local retval = M.filename()

   return not isempty(location)
         and string.format("%s %s %s", retval, "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%*", location)
      or retval
end

M.get_winbar = function()
   local winbar_filetype_exclude = {
      help = true,
      dashboard = true,
      NvimTree = true,
      Trouble = true,
      alpha = true,
      toggleterm = true,
      DressingSelect = true,
      TelescopePrompt = true,
      crunner = true,
   }

   return winbar_filetype_exclude[vim.bo.filetype] and nil or M.gps()
end

return M
