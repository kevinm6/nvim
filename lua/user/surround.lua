--------------------------------------
-- File: surround.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/
-- Last Modified: 17/12/21 - 08:57
--------------------------------------

local status_ok, surround = pcall(require, "surround")
if not status_ok then
	return
end

surround.setup {
  context_offset = 100,
  load_autogroups = false,
  mappings_style = "surround",
  map_insert_mode = true,
  quotes = {"'", '"'},
  brackets = {"(", '{', '['},
  pairs = {
    nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
    linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}}
  },
  prefix = "s"
}
