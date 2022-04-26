-----------------------------------
--  File         : zen-mode.lua
--  Description  : zen_mode plugin conf
--  Author       : Kevin
--  Last Modified: 26/03/2022 - 21:00
-----------------------------------


local ok, zen_mode = pcall(require, "zen-mode")
if not ok then return end


zen_mode.setup {
	window = {
		backdrop = 1,
		height = 0.8, -- height of the Zen window
		width = 0.85,
		options = {
			signcolumn = "no", -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			cursorline = true, -- disable cursorline
		},
	},
	plugins = {
		gitsigns = { enabled = false }, -- disables git signs
		tmux = { enabled = false },
		twilight = { enabled = true },
	},
}
