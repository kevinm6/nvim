-------------------------------------
--  File         : grammarly.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 14 Oct 2022, 20:49
-------------------------------------

local util = require "lspconfig".util

return {
  filetypes = { "markdown", "txt", "text" },
  single_file_support = true,
  autostart = false,
  root_dir = util.find_git_ancestor,
}
