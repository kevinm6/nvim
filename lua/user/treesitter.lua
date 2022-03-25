-------------------------------------
-- File: treesitter.lua
-- Description: TreeSitter config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/treesitter.lua
-- Last Modified: 25/03/2022 - 19:20
-------------------------------------


local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

configs.setup {
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = {},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	autopairs = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = {
			"css",
			"python",
			"yaml"
		}
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = true,
	},
	autotag = {
		enable = true,
		disable = { "xml" },
	},
	rainbow = {
		enable = true,
		colors = {
			"Gold",
			"Orchid",
			"DodgerBlue",
			"Cornsilk",
			-- "LawnGreen",
			-- "Salmon",
		},
		disable = { "html" },
	},
	playground = {
		enable = true,
	},
}

