-------------------------------------
--  File         : dadbod.lua
--  Description  : DB config and help
--  Author       : Kevin
--  Last Modified: 12 Sep 2023, 12:09
-------------------------------------

local M = {
   "tpope/vim-dadbod",
   cmd = { "DB", "DBUI" },
   ft = { "sql", "mysql", "plsql" },
   dependencies = {
      {
         "kristijanhusak/vim-dadbod-ui",
         init = function()
            vim.g.dbs = {
               imdb = "postgres://:@localhost/imdb",
               lezione = "postgres://:@localhost/lezione",
            }

            local icons = require "lib.icons"
            vim.g.db_ui_icons = {
               expanded = {
                  db = icons.ui.DownTriangle,
                  buffers = icons.ui.DownTriangle,
                  saved_queries = icons.ui.DownTriangle,
                  schemas = icons.ui.DownTriangle,
                  schema = icons.ui.DownTriangle,
                  tables = icons.ui.DownTriangle,
                  table = icons.ui.DownTriangle,
               },
               collapsed = {
                  db = icons.ui.RightTriangle,
                  buffers = icons.ui.RightTriangle,
                  saved_queries = icons.ui.RightTriangle,
                  schemas = icons.ui.RightTriangle,
                  schema = icons.ui.RightTriangle,
                  tables = icons.ui.RightTriangle,
                  table = icons.ui.RightTriangle,
               },
               saved_query = icons.ui.BookMark,
               new_query = icons.ui.Search,
               tables = icons.ui.Table,
               buffers = icons.lsp.buffer,
               add_connection = '['..icons.ui.Plus..']',
               connection_ok = icons.diagnostics.status_ok,
               connection_error = icons.diagnostics.status_not_ok,
            }

         end
      },
   }
}

return M

