-------------------------------------
-- File         : sqls.lua
-- Description  : sqls server config
-- Author       : Kevin
-- Last Modified: 13/05/2022 - 10:03
-------------------------------------

local sqls_binary = vim.fn.stdpath "data".."/lsp_servers/sqls/sqls"

return {
  cmd = { sqls_binary },
  filetypes = { "sql", "mysql" },
  single_file_support = true,
  -- root_dir = require("lspconfig.util").find_git_ancestor,
	settings = {
		sqls = {
			connections = {
        {
          driver = "postgresql",
          dbName = "postgres",
          proto = "tcp",
          user = "Kevin",
          port = 5432,
          passwd = "",
          host = "localhost",
          path = "/Users/Kevin/Documents/Informatica/2°Anno/1°Semestre/Basi di Dati/",
        },
        {
          driver = "postgresql",
          dbName = "imdb",
          proto = "tcp",
          user = "Kevin",
          port = 5432,
          passwd = "",
          host = "localhost",
          path = "/Users/Kevin/Documents/Informatica/2°Anno/1°Semestre/Basi di Dati/",
        },
        {
          driver = "postgresql",
          dbName = "lezione",
          proto = "tcp",
          user = "Kevin",
          port = 5432,
          passwd = "",
          host = "localhost",
          path = "/Users/Kevin/Documents/Informatica/2°Anno/1°Semestre/Basi di Dati/",
        },
        {
          driver = "postgresql",
          dbName = "freshrss",
          proto = "tcp",
          user = "Kevin",
          port = 5432,
          passwd = "",
          host = "localhost",
          path = "/Users/Kevin/Documents/Informatica/2°Anno/1°Semestre/Basi di Dati/",
        },
      }
		},
	},
  on_attach = function(client, bufnr)
    require("sqls").on_attach(client, bufnr)
  end
}

