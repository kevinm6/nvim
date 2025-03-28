local mod_cache = nil

return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  -- root_markers = { "go.mod", "go.work", ".git" },
  settings = {
    gopls = {
      codelenses = {
        test = true,
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  root_dir = function(bufnr, cb)
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    if not mod_cache then
      local result = vim.system({ "go", "env", "GOMODCACHE" }):wait().stdout
      if result and result[1] then
        mod_cache = vim.trim(result[1])
      else
        mod_cache = vim.fn.system "go env GOMODCACHE"
      end
    end
    if mod_cache and vim.api.nvim_buf_get_name(bufnr):sub(1, #mod_cache) == mod_cache then
      local clients = vim.lsp.get_lsp_clients { name = "gopls" }
      if #clients > 0 then
        return cb(clients[#clients].config.root_dir)
      end
    end
    return cb(vim.fs.root(0, { "go.work", "go.mod", ".git" }))
  end,
  single_file_support = true,
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
  },
}
