---@type vim.lsp.Config
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  init_options = { provideFormatter = true },
  root_dir = function(bufnr, cb)
    local dir = vim.fs.root(bufnr, { ".git", ".marksman.toml", "_quarto.yml" })
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    cb(dir)
  end,
  settings = {
    css = {
      validate = true,
    },
    less = {
      validate = true,
    },
    scss = {
      validate = true,
    },
  },
  single_file_support = true,
}