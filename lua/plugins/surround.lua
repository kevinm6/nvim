--------------------------------------
-- File         : surround.lua
-- Description  : Surround config
-- Author       : Kevin
-- Last Modified: 04 Jan 2023, 11:09
--------------------------------------

local M = {
  "ur4ltz/surround.nvim",
  event = "BufReadPre",
  keys = {
    -- Normal & Visual Keymaps
    { mode = { "v", "n" }, "s.", function() require "surround".repeat_last() end, desc = "Repeat" },
    { mode = { "v", "n" }, "sa", function() require "surround".surround_add(true) end, desc = "Add" },
    { mode = { "v", "n" }, "sd", function() require "surround".surround_delete() end, desc = "Delete" },
    { mode = { "v", "n" }, "sr", function() require "surround".surround_replace() end, desc = "Replace" },
    { mode = { "v", "n" }, "sq", function() require "surround".toggle_quotes() end, desc = "Quotes" },
    { mode = { "v", "n" }, "sb", function() require "surround".toggle_brackets() end, desc = "Brackets" },
  }
}

function M.config()
  local surround = require "surround"

  surround.setup {
    context_offset = 100,
    load_autogroups = false,
    load_keymaps = true,
    mappings_style = "sandwich",
    map_insert_mode = true,
    quotes = {"'", '"'},
    brackets = {"(", '{', '['},
    space_on_closing_char = false,
    pairs = {
      nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}, { "<", ">" }},
      linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}, { "*", "*"}}
    },
    prefix = "s"
  }
end

return M
