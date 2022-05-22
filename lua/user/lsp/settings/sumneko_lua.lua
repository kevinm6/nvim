-------------------------------------
-- File         : sumneko_lua.lua
-- Description  : lua lsp config
-- Author       : Kevin
-- Last Modified: 20/04/2022 - 21:58
-------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local main_path = vim.fn.stdpath("data").."/lsp_servers/sumneko_lua/extension/server/bin/main.lua"

return {
  cmd = { "lua-language-server", "-E", main_path };
	settings = {
		Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "config" .. "/lua",
				},
			},
      telemetry = {
        enable = false,
      },
      single_file_support = true,
		},
	},
}
