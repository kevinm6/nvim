-------------------------------------
-- File         : sumneko_lua.lua
-- Description  :
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/
-- Last Modified: 21/12/21 - 20:28
-------------------------------------

return {
	settings = {

		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
