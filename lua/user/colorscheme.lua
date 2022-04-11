 -------------------------------------
 -- File         : colorscheme.lua
 -- Description  : K specific variables
 -- Author       : Kevin
 -- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/colorscheme.lua
 -- Last Modified: 12/03/2022 - 18:23
 -------------------------------------

 local theme = "k_theme"

 local status_ok, _ = pcall(vim.cmd "colorscheme " .. theme)
 if not status_ok then
   require("notify")("  Colorscheme " .. theme .. " not found!  ", "Error")
	 return
 end
