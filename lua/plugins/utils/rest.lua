-------------------------------------
-- File         : rest.lua
-- Descriptions : curl & http wrapper for API testing and more
-- Author       : Kevin
-- Last Modified: 18 Sep 2023, 09:24
-------------------------------------

local M = {
   "rest-nvim/rest.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   ft = { "http", "https" },
   config = function(_, o)
      o.result_split_horizontal = true

      require "rest-nvim".setup(o)

      vim.keymap.set("n", "<leader>Rr", "<Plug>RestNvim", { desc = "Run Request under cursor", buffer = true })
      vim.keymap.set("n", "<leader>Rl", "<Plug>RestNvimLast", { desc = "Run Last Request", buffer = true })
      vim.keymap.set("n", "<leader>Rp", "<Plug>RestNvimPreview", { desc = "Preview Request cURL command", buffer = true })
      vim.keymap.set("n", "<leader>Rf", function() require("rest-nvim").run_file(vim.fn.expand "%") end, { desc = "Run File", buffer = true })
   end
}

return M
