-------------------------------------
-- File         : sumneko_lua.lua
-- Description  : lua lsp config
-- Author       : Kevin
-- Last Modified: 14 Oct 2022, 09:51
-------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local ih = require "inlay-hints"

return {
  cmd = { "lua-language-server", "-E" };
	settings = {
		Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
			diagnostics = {
				globals = { "vim", "packer_plugins" },
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
  on_attach = function(c, b)
    ih.on_attach(c, b)
  end
}
