return {
  cmd = { "clangd", "--clang-tidy" },
  root_markers = { ".clangd", "compile_commands.json" },
  filetypes = { "c", "cpp" },
  init_options = {
    clangdFileStatus = true,
  },
  inlayHints = {
    enabled = true,
    parameterNames = true,
    deducedTypes = true,
  },
}
