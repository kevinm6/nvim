-------------------------------------
--  File         : cheatsheet.lua.lua
--  Description  : cheatsheet plugin config
--  Author       : Kevin
--  Last Modified: 02 Jan 2023, 11:36
-------------------------------------

local M = {
  "Djancyp/cheat-sheet",
  cmd = "CheatSH",
}

function M.config()
  local cs = require "cheat-sheet"

  cs.setup {
    auto_fill = {
      filetype = true,
      current_word = true,
    },

    main_win = {
      style = "minimal",
      border = "double",
    },

    input_win = {
      style = "minimal",
      border = "double",
    }
  }
end

return M
