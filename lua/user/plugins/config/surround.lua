--------------------------------------
-- File         : surround.lua
-- Description  : Surround config
-- Author       : Kevin
-- Last Modified: 19 Aug 2022, 23:58
--------------------------------------

local ok, surround = pcall(require, "surround")
if not ok then return end

surround.setup {
  context_offset = 100,
  load_autogroups = false,
  mappings_style = "sandwich",
  map_insert_mode = true,
  quotes = {"'", '"'},
  brackets = {"(", '{', '['},
	space_on_closing_char = false,
  pairs = {
    nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
    linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}, { "*", "*"}}
  },
  prefix = "s"
}
