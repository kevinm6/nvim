---@type vim.lsp.Config
return {
  -- cmd = { "biome", "lsp-proxy" },
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = { "astro", "css", "graphql", "html", "javascript", "javascriptreact", "json", "jsonc", "svelte", "typescript", "typescript.tsx", "typescriptreact", "vue" },
  root_markers =  { 'biome.json', 'biome.jsonc', '.git' },
  -- root_dir = function(bufnr, on_dir)
  --   local fname = vim.api.nvim_buf_get_name(bufnr)
  --   local root_files = { 'biome.json', 'biome.jsonc', '.git' }
  --   -- vim.fs.root(0, { "biome.json", "biome.jsonc", ".git" })
  --   local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  --   on_dir(root_dir)
  -- end,
  workspace_required = true
}