--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 25/03/2022 - 14:51
--------------------------------------


-- check if NeoVim or Vim
if not(vim.fn.has("nvim")) == 1 then
	vim.cmd	"source ~/.config/vim/vimrc"
	return
end

-- Use other Shadafile for Gui (VimR)
if vim.fn.has("gui_vimr") == 1 then
	vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/gmain.shada")
else
	vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/main.shada")
end

-- Config Files to source
local modules = {
	"user.impatient",
	"user.prefs",
	"user.keymaps",
	"user.plugins",
	"user.vars",
	"user.icons",
	"user.cmp",
	"user.lsp",
	"user.notify",
	"user.gps",
	"user.telescope",
	"user.treesitter",
	"user.autopairs",
	"user.comment",
	"user.gitsigns",
  "user.neo-tree", -- "user.nvim-tree",
	"user.bufferline",
	"user.toggleterm",
	"user.whichkey",
	"user.autocommands",
	"user.statusline",
	"user.surround",
	"user.renamer",
	"user.registers",
	"user.alpha",
	"user.symbol-outline",
  "user.sniprun",
  "user.hop",
	"user.colorizer",
	"user.illuminate",
  "user.zen-mode"
}

for _, module in ipairs(modules) do
	local ok, err = pcall(require, module)
	if not ok then
		require("notify")(
			"Error loading module < " .. module .. " >\n" .. err,
			"Error",
			{ timeout = 4600 }
		)
	end
end
