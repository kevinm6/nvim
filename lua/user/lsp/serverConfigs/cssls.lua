-------------------------------------
-- File: cssls.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "cssls"

configs[name] = {
    cmd = { "css-languageserver", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_dir = M.util.root_pattern("package.json", ".git") or bufdir,
    settings = {
      css = { validate = true },
      less = { validate = true },
      scss = { validate = true }
    },
    single_file_support = true
}


-- CSS {
  -- lspconfig.cssls.setup {
  --   cmd = { "css-languageserver", "--stdio" },
  --   filetypes = { "css", "scss", "less" },
  --   root_dir = M.util.root_pattern("package.json", ".git") or bufdir,
  --   settings = {
  --     css = { validate = true },
  --     less = { validate = true },
  --     scss = { validate = true }
  --   },
  --   single_file_support = true
  -- }
-- CSS }

