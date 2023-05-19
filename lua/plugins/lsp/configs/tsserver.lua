-------------------------------------
--  File         : tsserver.lua
--  Description  : tsserver lsp user config
--  Author       : Kevin
--  Last Modified: 15 May 2023, 19:14
-------------------------------------

return {
  -- Required for lsp-status
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript", "javascriptreact", "javascript.jsx",
    "typescript", "typescriptreact", "typescript.tsx"
  },
  init_options = {
    hostInfo = "neovim"
  },
  root_dir = require "lspconfig".util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git") or
      vim.loop.cwd(),
  single_file_support = true,
}

