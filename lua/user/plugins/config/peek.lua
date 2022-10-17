-------------------------------------
--  File         : peek.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 17 Oct 2022, 15:57
-------------------------------------

local has_peek, peek = pcall(require, "peek")
if not has_peek then return end

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
  -- throttle_time = 'auto',   -- minimum amount of time in milliseconds
                            -- that has to pass before starting new render
}
