-----------------------------------
--  File         : vimls.lua
--  Description  : vimls language server
--  Author       : Kevin
--  Last Modified: 13/05/2022 - 11:07
-----------------------------------

return {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	init_options = {
		diagnostic = {
			enable = true,
		},
		indexes = {
			count = 3,
			gap = 100,
			projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
			runtimepath = true,
		},
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		runtimepath = "",
		suggest = {
			fromRuntimepath = true,
			fromVimruntime = true,
		},
		vimruntime = "",
	},
	single_file_support = true,
}
