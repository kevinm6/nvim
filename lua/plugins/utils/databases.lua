-------------------------------------
--  File         : databases.lua
--  Description  : DB config and help
--  Author       : Kevin
--  Last Modified: 08 May 2024, 12:12
-------------------------------------

return {
  "kndndrj/nvim-dbee",
  ft = { 'sql', 'mysql' },
  cmd = 'Dbee',
  build = function()
    require 'dbee'.install()
  end,
  config = function(_, o)
    o.default_connection = 'default' -- id of default connection set in `connection.json`

    o.drawer = {
      disable_help = true,
      -- mappings = {
      -- { key = "<cr>", mode = "n", action = "action_1" },
      -- { key = "<C-l>", mode = "n", action = "action_1" },
      -- { key = "<space>", mode = "n", action = "toggle" },
      -- }
    }
    o.extra_helpers = {
      ['postgres'] = {
        ["List All"] = "select * from {{ .Table }}"
      }
    }
    o.sources = { -- stored connection config location
      require("dbee.sources").FileSource:new(vim.fn.stdpath "state" ..
        "/dbee/connection.json")
    }
    o.editor = {
      -- mappings for the buffer
      mappings = {
        -- run what's currently selected on the active connection
        { key = "<localleader>r", mode = "v", action = "run_selection" },
        { key = "<C-CR>",         mode = "v", action = "run_selection" },
        -- run the whole file on the active connection
        { key = "<localleader>r", mode = "n", action = "run_file" }
      }
    }
    o.result = {
      page_size = 30,
      { key = "L",     mode = "", action = "page_next" },
      { key = "H",     mode = "", action = "page_prev" },
      { key = "<C-n>", mode = "", action = "page_next" },
      { key = "<C-p>", mode = "", action = "page_prev" },
      { key = "G",     mode = "", action = "page_last" },
      { key = "gg",    mode = "", action = "page_first" },
    }

    o.call_log = {
      -- mappings for the buffer
      mappings = {
        -- show the result of the currently selected call record
        { key = "<CR>",  mode = "", action = "show_result" },
        { key = "<C-l>", mode = "", action = "show_result" },
        -- cancel the currently selected call (if its still executing)
        { key = "<C-c>", mode = "", action = "cancel_call" },
      }
    }
    require "dbee".setup(o)

    -- Run brew services when loading this plugin so the connections are available
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      once = true,
      callback = function(ev)
        if ev.data == 'nvim-dbee' then
          vim.system({ 'brew', 'services', 'run', 'postgresql@14' },
            { text = true, timeout = 10000 }, function(obj)
              vim.notify(obj.stdout, vim.log.levels.INFO, { title = 'Brew Services' })

              if obj.stderr then vim.print(obj.stderr) end
            end)
        end
      end
    })

    -- Stop brew services just before exiting Nvim
    -- I put this here so is created only when starting the service from the autocmd
    -- above (when loading this plugin), if done outside Nvim or without this plugin
    -- the brew services still run as expected
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        vim.system({ 'brew', 'services', 'stop', 'postgresql@14' },
          { text = true, timeout = 6000 }):wait()
      end
    })
  end
}