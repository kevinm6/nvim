-----------------------------------
-- File         : yanky.lua
-- Description  : yanky plugin config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/yanky.lua
-- Last Modified: 10/04/2022 - 11:14
-----------------------------------

local ok, ynky = pcall(require, "yanky")
if not ok then return end


ynky.setup({
  ring = {
    history_length = 10,
    storage = "shada",
    sync_with_numbered_registers = true,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
})
