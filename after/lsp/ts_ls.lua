---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "ojs",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  init_options = {
    host_info = "neovim",
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsForImportStatements = true,
    },
  },
  single_file_support = true,
}