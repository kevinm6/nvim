-------------------------------------
--  File         : erlangls.lua
--  Description  : erlangls lsp user config
--  Author       : Kevin
--  Last Modified: 23 May 2023, 12:19
-------------------------------------

return {
  -- Required for lsp-status
  cmd = { "erlang_ls" },
  filetypes = { "erlang" },
  docs = {
    description = [[
    https://github.com/erlang-ls/erlang_ls
    ]];
  },
  root_dir = require "lspconfig".util.root_pattern("rebar.config", "erlang.mk", ".git") or
      vim.loop.cwd(),
  single_file_support = true,
}

