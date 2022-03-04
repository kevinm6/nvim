--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 02/03/2022 - 09:48
--------------------------------------


-- Section: check VScodium | Vim (standard)
	if not(vim.fn.has("nvim")) == 1 then
		vim.cmd	"source ~/.config/vim/vimrc"
		return
	end

	if vim.fn.has("gui_vimr") == 1 then
		vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/gmain.shada")
	else
		vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/main.shada")
	end
-- }

-- Section: Config Files to source {
	local modules = {
		"user.impatient",
		"user.prefs",
		"user.maps",
		"user.plugins",
		"user.vars",
		"user.cmp",
		"user.lsp",
		"user.notify",
		"user.gps",
		"user.telescope",
		"user.treesitter",
		"user.autopairs",
		"user.comment",
		"user.gitsigns",
		"user.nvim-tree",
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
		"user.colorizer"
	}

	for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
	end
-- }
