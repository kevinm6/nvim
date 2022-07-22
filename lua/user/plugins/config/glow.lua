-----------------------------------
--	File         : glow.lua
--	Description  : glow plugin config (markdown preview)
--	Author       : Kevin
--	Last Modified: 21 Jul 2022, 12:56
-----------------------------------

local ok, glow = pcall(require, "glow")
if not ok then return end

glow.setup {
  glow_install_path = "~/.local/bin", -- default path for installing glow binary
  border = "rounded", -- floating window border config
  style = "dark", -- filled automatically with your current editor background, you can override using glow json style
  pager = false,
  -- width = 120,
}
