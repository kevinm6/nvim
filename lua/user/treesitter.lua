-------------------------------------
-- File: treesitter.lua
-- Description: TreeSitter config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/treesitter.lua
-- Last Modified: 27/01/2022 - 18:35
-------------------------------------


local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed ={ "devicetree", "dot", "c", "bash", "comment", "css", "cpp", "dockerfile", "go", "http", "html", "php", "json", "json5", "java", "lua", "markdown", "latex", "perl", "python", "query", "phpdoc", "regex", "swift", "vim" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
	indent = { enable = true, disable = { "python" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
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
			-- "Cornsilk",
			-- "Salmon",
			-- "LawnGreen",
		},
		disable = { "html" },
	},
	playground = {
		enable = true,
	},
})

