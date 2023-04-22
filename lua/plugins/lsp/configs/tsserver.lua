-------------------------------------
--  File         : tsserver.lua
--  Description  : tsserver lsp user config
--  Author       : Kevin
--  Last Modified: 21 Apr 2023, 08:45
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
  root_dir = function()
    return require "lspconfig".util.root_pattern("go.mod", "go.work", ".git") or
      vim.loop.cwd()
  end,
  single_file_support = true,
}

