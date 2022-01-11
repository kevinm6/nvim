-------------------------------------
-- File: settings/sqlls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/sqlls.lua
-- Last Modified: 11/01/22 - 20:18
-------------------------------------

local M = {}

local config = {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_dir = function(startpath)
			return M.search_ancestors(startpath, matcher)
	end,
	settings = {},
}

return config

