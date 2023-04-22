-------------------------------------
--  File         : clangd.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 22 Apr 2023, 12:41
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
   offsetEncoding = "utf-8",
   inlayHints = {
      enabled = true,
      parameterNames = true,
      deducedTypes = true,
   }
}
