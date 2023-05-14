-------------------------------------
--  File         : peek.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 14 May 2023, 10:06
-------------------------------------

local M = {
   "toppair/peek.nvim",
   -- enabled = false,
   build = "deno task --quiet build:fast",
   cmd = { "PeekOpen", "PeekClose" },
   ft = { "md", "markdown" },
   opts = function(_, o)
      o.auto_load = true -- whether to automatically load preview when
      -- entering another markdown buffer
      o.close_on_bdelete = true -- close preview window on buffer delete

      o.syntax = true -- enable syntax highlighting, affects performance

      o.theme = "dark" -- 'dark' or 'light'

      o.update_on_change = true

      -- relevant if update_in_insert == true
      o.throttle_at = 200000 -- start throttling when file exceeds this
      -- amount of bytes in size
      o.throttle_time = "auto" -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
   end
}

function M.config()
   local peek = require "peek"
   vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
   vim.api.nvim_create_user_command("PeekClose", peek.close, {})
end

return M
