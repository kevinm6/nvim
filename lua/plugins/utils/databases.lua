-------------------------------------
--  File         : databases.lua
--  Description  : DB config and help
--  Author       : Kevin
--  Last Modified: 17 Mar 2024, 14:32
-------------------------------------

local M = {
  {
    "kevinm6/nvim-dbee",
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
      o.default_connection = "default" -- id of default connection to set manually on json file

      o.extra_helpers = {
        ["postgres"] = {
          ["List All"] = "select * from {{ .Table }}",
        },
      }
      o.sources = { -- stored connection config location
        require("dbee.sources").FileSource:new(vim.fn.stdpath "state".."/dbee/connection.json")
      }
      o. editor = {
        -- mappings for the buffer
        mappings = {
          -- run what's currently selected on the active connection
          { key = "<localleader>r", mode = "v", action = "run_selection" },
          -- run the whole file on the active connection
          { key = "<localleader>r", mode = "n", action = "run_file" },
        },
      }

      require "dbee".setup(o)
    end
  },
  { -- disabled since I'm using < nvim-dbee >
    "tpope/vim-dadbod",
    enabled = false,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        init = function()
          vim.g.dbs = {
            -- name = "url://username:password@server/db"
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
      }
    }
  }
}

return M