-------------------------------------
-- File         : sumneko_lua.lua
-- Description  :
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/
-- Last Modified: 20/04/2022 - 13:12
-------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {

	settings = {
		Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
          vim.api.nvim_get_runtime_file("", true),
				},
			},
      telemetry = {
        enable = false,
      }
		},
	},
}
