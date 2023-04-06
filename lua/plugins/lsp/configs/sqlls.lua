-----------------------------------
--  File         : sqls.lua
--  Description  : sqls configuration
--  Author       : Kevin
--  Last Modified: 06 Apr 2023, 17:29
-----------------------------------

local M = {
  "joe-re/sql-language-server",
  ft = { "sql", "mysql", "psql" },
}

function M.config()
  return {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    single_file_support = true,
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
    -- on_attach = function(client, bufnr)
    --   require("sqls").on_attach(client, bufnr)
    -- end
  }
end

return M
