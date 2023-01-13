-----------------------------------
--  File         : neotest.lua
--  Description  : neotest plugin config
--  Author       : Kevin
--  Last Modified: 12 Jan 2023, 09:11
-----------------------------------

local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>RR", function() require "neotest".run.run() end, desc = "Run Test" },
    { "<leader>RC", function() require "neotest".run.run(vim.fn.expand "%") end, desc = "Run Current File" },
    { "<leader>Rs", function() require "neotest".run.stop() end, desc = "Run Stop" },

  }
}

return M
