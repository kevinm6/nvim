-------------------------------------
-- File: clangd.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "clangd"

configs[name] = {
    capabilities = capabilities,
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = M.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    single_file_support = true
}


-- CLANG {
  -- lspconfig.clangd.setup {
  --   capabilities = capabilities,
  --   cmd = { "clangd", "--background-index" },
  --   filetypes = { "c", "cpp", "objc", "objcpp" },
  --   root_dir = M.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  --   single_file_support = true
  -- }
-- CLANG }

