-------------------------------------
-- File         : lua_ls.lua
-- Description  : lua lsp config
-- Author       : Kevin
-- Last Modified: 12 Feb 2023, 09:55
-------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


return {
  cmd = { "lua-language-server", "-E" };
	settings = {
		Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
			diagnostics = {
				globals = { "vim", "pcall", "format" },
			},
      completion = {
        keywordSnippet = "Replace",
        callSnippet = "Replace",
      },
			workspace = {
				library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
				},
			},
      telemetry = {
        enable = false,
      },
      single_file_support = true,
      hint = { enable = true },
		},
	},
}
