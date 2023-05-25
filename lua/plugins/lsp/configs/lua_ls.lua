-------------------------------------
-- File         : lua_ls.lua
-- Description  : lua lsp config
-- Author       : Kevin
-- Last Modified: 24 May 2023, 12:27
-------------------------------------

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require "neodev".setup {}

return {
   cmd = { "lua-language-server", "-E" },
   settings = {
      Lua = {
         runtime = {
            version = "LuaJIT",
            path = runtime_path,
         },
         diagnostics = {
            enable = true,
            globals = { "vim", "pcall", "format" },
            disable = { "lowercase-global" },
         },
         completion = {
            keywordSnippet = "Replace",
            callSnippet = "Replace",
         },
         workspace = {
            library = {
               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
               [vim.fn.stdpath "config" .. "/lua"] = true,
               [vim.fn.stdpath "data" .. "/mason/packages/lua-language-server/libexec/meta/5393ac01" ] = true,
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
