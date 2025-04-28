---@type vim.lsp.Config
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "quarto", "markdown.mdx" },
  single_file_support = true,
  root_markers = { ".git", ".marksman.toml", "_quarto.yml" },
  docs = {
    description = [[
  https://github.com/artempyanykh/marksman

  Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.

  Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.

  Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases
  ]],
  },
}