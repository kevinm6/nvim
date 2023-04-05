-------------------------------------
-- File         : sourcekit.lua
-- Description  : LSP for swift and more (from Apple)
-- Author       : Kevin
-- Last Modified: 04 Apr 2023, 09:51
-------------------------------------

local util = require "lspconfig".util

return {
  cmd = { "/usr/bin/xcrun", "sourcekit-lsp" },
  filetypes = { "swift" },
  root_dir = util.root_pattern("Package.swift", ".git")
}

