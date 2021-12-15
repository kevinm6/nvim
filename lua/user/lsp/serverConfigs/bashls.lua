-------------------------------------
---- File: bashls.lua
---- Description: LanguageServerProtocol K configuration
---- Author: Kevin
---- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
---- Last Modified: 15/12/21 - 11:50
---------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "bashls"

configs[name] = {
   cmd = { "bash-language-server", "start" },
    cmd_env = {
      GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"
    },
    filetypes = { "sh" },
    root_dir = M.util.find_git_ancestor,
    single_file_support = true
}


-- BASH {
  -- lspconfig.bashls.setup {
  --  cmd = { "bash-language-server", "start" },
  --   cmd_env = {
  --     GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"
  --   },
  --   filetypes = { "sh" },
  --   root_dir = M.util.find_git_ancestor,
  --   single_file_support = true
  -- }
--  BASH }

