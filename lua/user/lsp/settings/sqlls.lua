-------------------------------------
-- File: settings/sqlls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 11/01/22 - 09:23
-------------------------------------

return {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_dir = function(startpath)
			return M.search_ancestors(startpath, matcher)
	end,
	settings = {},
}

