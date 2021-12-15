-------------------------------------
---- File: html.lua
---- Description: LanguageServerProtocol K configuration
---- Author: Kevin
---- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
---- Last Modified: 15/12/21 - 11:50
---------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "html"

configs[name] = {
  cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true
      }
    },
    root_dir = function(startpath)
        return M.search_ancestors(startpath, matcher)
      end,
    settings = {},
    single_file_support = true
}


-- HTML {
 -- lspconfig.html.setup {
 --  cmd = { "vscode-html-language-server", "--stdio" },
 --    filetypes = { "html" },
 --    init_options = {
 --      configurationSection = { "html", "css", "javascript" },
 --      embeddedLanguages = {
 --        css = true,
 --        javascript = true
 --      }
 --    },
 --    root_dir = function(startpath)
 --        return M.search_ancestors(startpath, matcher)
 --      end,
 --    settings = {},
 --    single_file_support = true
 --  }
-- HTML }

