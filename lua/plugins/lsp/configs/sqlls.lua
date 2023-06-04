-----------------------------------
--  File         : sqls.lua
--  Description  : sqls configuration
--  Author       : Kevin
--  Last Modified: 10 Jun 2023, 09:10
-----------------------------------

local M = {
  "joe-re/sql-language-server",
  ft = { "sql", "mysql", "psql" },
}

local databases_path = vim.fn.expand "~/Informatica/Anno2/Semestre1/Basi di Dati"

function M.config()
  return {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    single_file_support = true,
    root_dir = require "lspconfig.util".root_pattern "/Users/Kevin/.config/sql-language-server/.sqllsrc.json",
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
            path = databases_path,
          },
          {
            driver = "postgresql",
            dbName = "imdb",
            proto = "tcp",
            user = "Kevin",
            port = 5432,
            passwd = "",
            host = "localhost",
            path = databases_path,
          },
          {
            driver = "postgresql",
            dbName = "lezione",
            proto = "tcp",
            user = "Kevin",
            port = 5432,
            passwd = "",
            host = "localhost",
            path = databases_path,
          },
          {
            driver = "postgresql",
            dbName = "freshrss",
            proto = "tcp",
            user = "Kevin",
            port = 5432,
            passwd = "",
            host = "localhost",
            path = databases_path,
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
