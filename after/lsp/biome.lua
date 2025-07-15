---@type vim.lsp.Config
return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = { "astro", "css", "graphql", "html", "javascript", "javascriptreact", "json", "jsonc", "svelte", "typescript", "typescript.tsx", "typescriptreact", "vue" },
   root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = { 'biome.json', 'biome.jsonc', '.git' }
    -- vim.fs.root(0, { "biome.json", "biome.jsonc", ".git" })
    local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
    on_dir(root_dir)
  end,
  workspace_required = true
}