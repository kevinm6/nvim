-------------------------------------
-- File: pyright.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "pyright"

configs[name] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = function(startpath)
      return M.search_ancestors(startpath, matcher)
    end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true
        }
      }
    },
    single_file_support = true
}

-- PYTHON {
  -- lspconfig.pyright.setup {
  --   cmd = { "pyright-langserver", "--stdio" },
  --   filetypes = { "python" },
  --   root_dir = function(startpath)
  --     return M.search_ancestors(startpath, matcher)
  --   end,
  --   settings = {
  --     python = {
  --       analysis = {
  --         autoSearchPaths = true,
  --         diagnosticMode = "workspace",
  --         useLibraryCodeForTypes = true
  --       }
  --     }
  --   },
  --   single_file_support = true
  -- }
-- PYTHON }


