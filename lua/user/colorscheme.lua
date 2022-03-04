 -------------------------------------
 -- File: colorscheme.lua
 -- Description: K specific variables
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/colorscheme.lua
 -- Last Modified: 27/12/21 - 12:32
 -------------------------------------

 local theme = "k_theme"

 local status_ok, _ = pcall(vim.cmd "colorscheme " .. theme)
 if not status_ok then
   vim.notify("colorscheme " .. theme .. " not found!") return
 end
