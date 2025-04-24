local bin = vim.fn.glob(
  "/Applications/Xcode*.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
  true,
  false,
  true
)

---@type vim.lsp.Config
return {
  cmd = { bin },
  filetypes = { "swift" },
  root_dir = function(bufnr, cb)
    cb(vim.fs.root(bufnr, ".git"))
  end,
}