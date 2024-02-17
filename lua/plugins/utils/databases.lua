-------------------------------------
--  File         : databases.lua
--  Description  : DB config and help
--  Author       : Kevin
--  Last Modified: 12 Sep 2023, 12:09
-------------------------------------

local M = {
  {
    "kndndrj/nvim-dbee",
    ft = { "sql", "mysql" },
    cmd = "Dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function(_, o)
      local dbee = require "dbee"
      -- set location for stored connection config
      o.sources = {
        require("dbee.sources").FileSource:new(vim.fn.stdpath "state".."/dbee/connection.json")
      }
      dbee.setup(o)

      vim.keymap.set("x", "<localleader>q", function()
        local start_pos = vim.fn.getpos("'<")[2]
        local end_pos = vim.fn.getpos("'>")[2]
        local buf_content = vim.api.nvim_buf_get_lines(0, start_pos-1, end_pos+1, false)
        local content_as_string = table.concat(buf_content, "\n")
        dbee.execute(content_as_string)
      end, { desc = "Run query" })

      vim.keymap.set("n", "<localleader>q", function()
        local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content_as_string = table.concat(buf_content, "\n")
        dbee.execute(content_as_string)
      end, { desc = "Run query" })
      vim.keymap.set("n", "<leader>Rq", function()
        local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content_as_string = table.concat(buf_content, "\n")
        dbee.execute(content_as_string)
      end, { desc = "Run query" })
    end,
  },
  {
    "tpope/vim-dadbod",
    enabled = false,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        init = function()
          vim.g.dbs = {
            -- imdb = "postgres://:@localhost/imdb",
            -- lezione = "postgres://:@localhost/lezione",
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
  },
}

return M