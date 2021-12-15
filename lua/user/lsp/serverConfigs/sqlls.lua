-------------------------------------
-- File: sqlls.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "sqlls"

configs[name] = {
  local sql_root_pattern = M.util.root_pattern(".sqllsrc.json")
    cmd = { "sql-language-server" },
    filetypes = { "sql", "mysql" },
    root_dir = function(fname)
			return sql_root_pattern(fname) or vim.loop.os_homedir()
		end,
    settings = {}
}


-- SQL {
  -- local sql_root_pattern = M.util.root_pattern(".sqllsrc.json")
	-- lspconfig.sqlls.setup {
  --   cmd = { "sql-language-server" },
  --   filetypes = { "sql", "mysql" },
  --   root_dir = function(fname)
			-- return sql_root_pattern(fname) or vim.loop.os_homedir()
		-- end,
  --   settings = {}
	-- }
-- SQL }
