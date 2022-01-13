-------------------------------------
-- File: sqlls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/sqlls.lua
-- Last Modified: 12/01/22 - 09:55
-------------------------------------

return {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    root_dir = function()
        return "/Users/Kevin/.local/share/nvim/lsp_servers/sqlls/npm_bin"
      end,
		settings = {}
}
