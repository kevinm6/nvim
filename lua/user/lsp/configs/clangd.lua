-------------------------------------
--  File         : clangd.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 14 Oct 2022, 20:49
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
}
