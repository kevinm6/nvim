--------------------------------------
-- File: surround.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/
-- Last Modified: 16/12/21 - 16:24
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
  pairs = {
    nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
    linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}}
  },
  prefix = "s"
}
