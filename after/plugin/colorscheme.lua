-------------------------------------
-- File         : colorscheme.lua
-- Description  : K specific variables
-- Author       : Kevin
-- Last Modified: 26 Jul 2022, 13:32
-------------------------------------

local theme = "knvim"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
if not status_ok then
  vim.notify("  Colorscheme " .. theme .. " not found!  ",
    "Error",
    { title = "Colorscheme" }
  )
  return
end
