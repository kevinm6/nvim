-------------------------------------
--  File         : clangd.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 04 Jan 2023, 10:56
-------------------------------------

return {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
  -- Required for lsp-status
  init_options = {
    clangdFileStatus = true,
  },
  inlayHints = {
    enabled = true,
    parameterNames = true,
    deducedTypes = true,
  }
}
