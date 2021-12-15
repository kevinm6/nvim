-------------------------------------
-- File: lemminx.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "lemminx"

configs[name] = {
    cmd = { "lemminx" },
    filetypes = { "xml", "xsd", "svg" },
    root_dir = M.util.find_git_ancestor,
    single_file_support = true
}


-- LEMMINX {
  -- lspconfig.lemminx.setup {
  --   cmd = { "lemminx" },
  --   filetypes = { "xml", "xsd", "svg" },
  --   root_dir = M.util.find_git_ancestor,
  --   single_file_support = true
  -- }
-- LEMMINX }

