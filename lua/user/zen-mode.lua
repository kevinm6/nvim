-----------------------------------
--  File: zen-mode.lua
--  Description: zen_mode plugin conf
--  Author: Kevin
--  Source: https://github.com/kevinm6/nvim/lua/nvim/lua/user/zen-mode.lua
--  Last Modified: 25/03/2022 - 17:18
-----------------------------------


local ok, zen_mode = pcall(require, "zen-mode")
if not ok then return end


zen_mode.setup {
	window = {
		backdrop = 1,
		height = 0.9, -- height of the Zen window
		width = 0.85,
		options = {
			signcolumn = "no", -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			-- cursorline = false, -- disable cursorline
			-- cursorcolumn = false, -- disable cursor column
			-- foldcolumn = "0", -- disable fold column
			-- list = false, -- disable whitespace characters
		},
	},
	plugins = {
		gitsigns = { enabled = false }, -- disables git signs
		tmux = { enabled = false },
		twilight = { enabled = true },
	},
	-- on_open = function()
	--   vim.lsp.diagnostic.disable()
	--  vim.cmd [[
	--       set foldlevel=10
	--       IndentBlanklineDisable
	--       ]]
	-- end,
	-- on_close = function()
	--   vim.lsp.diagnostic.enable()
	--   vim.cmd [[
	--       set foldlevel=5
	--       IndentBlanklineEnable
	--       ]]
	-- end,
}
