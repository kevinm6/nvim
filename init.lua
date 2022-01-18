--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 17/01/2022 - 10:30
--------------------------------------


-- Section: check VScodium | Vim (standard)
	if not(vim.fn.has("nvim")) == 1 then
		vim.cmd	"source ~/.config/vim/vimrc"
		return
	end

	if vim.fn.has("gui_vimr") == 1 then
		vim.opt.shadafile = vim.fn.expand("~/.local/share/nvim/shada/gmain.shada")
	else
		vim.opt.shadafile = vim.fn.expand("~/.local/share/nvim/shada/main.shada")
	end
-- }

-- Section: Config Files to source {
	local modules = {
		"user.prefs",
		"user.maps",
		"user.plugins",
		"user.vars",
		"user.cmp",
		"user.lsp",
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
	}

	for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
	end
-- }
