-------------------------------------
--  File         : databases.lua
--  Description  : DB config and help
--  Author       : Kevin
--  Last Modified: 08 May 2024, 12:12
-------------------------------------

return {
  "kndndrj/nvim-dbee",
  ft = { "sql", "mysql" },
  -- commit = "5062efbe5dfa3c0c6a51f5112c671f6625053f39",
  cmd = "Dbee",
  build = function()
    require("dbee").install()
  end,
  opts = function(_, o)
    o.default_connection = "default" -- id of default connection set in `connection.json`

    o.drawer = {
      disable_help = true,
      mappings = {
        { key = "<cr>", mode = "n", action = "action_1" },
        { key = "<C-l>", mode = "n", action = "action_1" },
        { key = "o", mode = "n", action = "toggle" },
        { key = "r", mode = "n", action = "refresh" },
        { key = "cw", mode = "n", action = "action_2" },
        { key = "dd", mode = "n", action = "action_3" },
        -- { key = "h", mode = "n", action = "collapse" },
        -- { key = "l", mode = "n", action = "expand" },
        { key = "<CR>", mode = "n", action = "menu_confirm" },
        { key = "y", mode = "n", action = "menu_yank" },
        { key = "<Esc>", mode = "n", action = "menu_close" },
        { key = "q", mode = "n", action = "menu_close" },
      },
    }
    o.extra_helpers = {
      ["postgres"] = {
        ["List All"] = "select * from {{ .Table }}",
      },
    }
    o.sources = { -- stored connection config location
      require("dbee.sources").FileSource:new(vim.fn.stdpath "state" .. "/dbee/connection.json"),
    }
    o.editor = {
      -- mappings for the buffer
      mappings = {
        -- run what's currently selected on the active connection
        { key = "<localleader>r", mode = "v", action = "run_selection" },
        { key = "<C-CR>", mode = "v", action = "run_selection" },
        -- run the whole file on the active connection
        { key = "<localleader>r", mode = "n", action = "run_file" },
      },
    }
    o.result = {
      page_size = 30,
      { key = "L", mode = "n", action = "page_next" },
      { key = "H", mode = "n", action = "page_prev" },
      { key = "<C-n>", mode = "n", action = "page_next" },
      { key = "<C-p>", mode = "n", action = "page_prev" },
      { key = "G", mode = "n", action = "page_last" },
      { key = "gg", mode = "n", action = "page_first" },
    }

    o.call_log = {
      -- mappings for the buffer
      mappings = {
        -- show the result of the currently selected call record
        { key = "<CR>", mode = "n", action = "show_result" },
        { key = "<C-l>", mode = "n", action = "show_result" },
        -- cancel the currently selected call (if its still executing)
        { key = "<C-c>", mode = "n", action = "cancel_call" },
      },
    }
  end,
}
