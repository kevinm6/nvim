-------------------------------------
-- File         : webdev.lua
-- Descriptions : curl & http wrapper for API testing and more
-- Author       : Kevin
-- Last Modified: 18 Mar 2024, 18:40
-------------------------------------

local M = {
  "rest-nvim/rest.nvim",
  commit = "b43d338",
  dependencies = { "plenary.nvim" },
  ft = { "http", "https" },
  config = function(_, o)
    o.result_split_horizontal = true

    require "rest-nvim".setup(o)

    vim.keymap.set("n", "<leader>Rr", "<Plug>RestNvim",
      { desc = "Run Request under cursor", buffer = true })
    vim.keymap.set("n", "<leader>Rl", "<Plug>RestNvimLast",
      { desc = "Run Last Request", buffer = true })
    vim.keymap.set("n", "<leader>Rp", "<Plug>RestNvimPreview",
      { desc = "Preview Request cURL command", buffer = true })
    vim.keymap.set("n", "<leader>Rf",
      function() require("rest-nvim").run_file(vim.fn.expand "%") end,
      { desc = "Run File", buffer = true })
    vim.keymap.set("n", "<localleader>r", "<Plug>RestNvim",
      { desc = "Run Request under cursor", buffer = true })
    vim.keymap.set("n", "<localleader>l", "<Plug>RestNvimLast",
      { desc = "Run Last Request", buffer = true })
    vim.keymap.set("n", "<localleader>p", "<Plug>RestNvimPreview",
      { desc = "Preview Request cURL command", buffer = true })
    vim.keymap.set("n", "<localleader>R",
      function() require("rest-nvim").run_file(vim.fn.expand "%") end,
      { desc = "Run File", buffer = true })
  end
}

return M