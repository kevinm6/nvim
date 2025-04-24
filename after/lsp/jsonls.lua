-- install with:
--   npm install -g vscode-langservers-extracted
---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_dir = function(bufnr, cb)
    local dir = vim.fs.root(bufnr, { ".git" }) or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    cb(dir)
  end,
  { provideFormatter = true },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}