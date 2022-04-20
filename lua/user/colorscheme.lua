 -------------------------------------
 -- File         : colorscheme.lua
 -- Description  : K specific variables
 -- Author       : Kevin
 -- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/colorscheme.lua
 -- Last Modified: 17/04/2022 - 11:54
 -------------------------------------

 local theme = "k_theme"

 local status_ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
 if not status_ok then
   vim.notify("  Colorscheme " .. theme .. " not found!  ",
     "Error",
     { title = "Colorscheme" }
   )
	 return
 end
