-------------------------------------
-- File         : sumneko_lua.lua
-- Description  : lua lsp config
-- Author       : Kevin
-- Last Modified: 20/04/2022 - 21:58
-------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local sumneko_root_path = vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua"
local sumneko_binary = sumneko_root_path .."/extension/server/bin/lua-language-server"

return {
  cmd = { sumneko_binary, "-E", sumneko_root_path.."/extension/server/main.lua" };
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
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
				},
			},
      telemetry = {
        enable = false,
      }
		},
	},
}
