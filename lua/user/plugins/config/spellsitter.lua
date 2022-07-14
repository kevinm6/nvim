-------------------------------------
-- File         : spellsitter.lua
-- Description  : spellsitter plugin config
-- Author       : Kevin
-- Last Modified: 01 Jul 2022, 16:11
-------------------------------------

local ok, spell = pcall(require, "spellsitter")
if not ok then return end

spell.setup {
  enable = { "md", "txt", "lua" },
  debug = false,
}
