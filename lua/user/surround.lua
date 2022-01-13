--------------------------------------
-- File: surround.lua
-- Description: Surround config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/surround.lua
-- Last Modified: 17/12/21 - 10:15
--------------------------------------

local status_ok, surround = pcall(require, "surround")
if not status_ok then
	return
end

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
    linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}}
  },
  prefix = "s"
}
