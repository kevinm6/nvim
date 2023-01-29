-------------------------------------
--  File         : neorg.lua
--  Description  : neorg plugin config
--  Author       : Kevin
--  Last Modified: 29 Jan 2023, 11:34
-------------------------------------

local M = {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  ft = { "*.norg" },
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.norg.concealer"] = {},
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Documents/Notes",
          }
        }
      },
    }
  },
  dependencies = { "nvim-lua/plenary.nvim" },
}

return M

