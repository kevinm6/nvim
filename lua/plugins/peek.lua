-------------------------------------
--  File         : peek.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 02 Jan 2023, 11:45
-------------------------------------

local M = {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  cmd = { "PeekOpen", "PeekClose" },
  ft = { "md", "markdown" },
--  keys = {
--    "n",
--    "<leader>mp",
--    function()
--      local peek = require "peek"
--      if peek.is_open() then
--        peek.close()
--      else
--        peek.open()
--      end
--    end,
--    desc = "Peek (Markdown Preview)",
--  }
}

function M.config()
  local peek = require "peek"

  -- default config:
  peek.setup {
    auto_load = true,         -- whether to automatically load preview when
                              -- entering another markdown buffer
    close_on_bdelete = true,  -- close preview window on buffer delete

    syntax = true,            -- enable syntax highlighting, affects performance

    theme = 'dark',           -- 'dark' or 'light'

    update_on_change = true,

    -- relevant if update_in_insert == true
    throttle_at = 200000,     -- start throttling when file exceeds this
                              -- amount of bytes in size
    throttle_time = 'auto',   -- minimum amount of time in milliseconds
                              -- that has to pass before starting new render
  }

  vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
  vim.api.nvim_create_user_command("PeekClose", peek.close, {})
end

return M
