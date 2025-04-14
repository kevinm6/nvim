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
  root_dir = function(bufnr, cb)
    local dir = vim.fs.root(bufnr, {
      "tsconfig.json",
      "package.json",
      "jsconfig.json",
      ".git",
    }) or vim.uv.cwd()
    cb(dir)
  end,
  -- root_markers = {
  --   "tsconfig.json",
  --   "jsconfig.json",
  --   "package.json",
  --   ".git",
  -- },
  init_options = {
    host_info = "neovim",
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsForImportStatements = true,
    },
  },
  single_file_support = true,
}
