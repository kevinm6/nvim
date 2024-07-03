-------------------------------------
-- File         : webdev.lua
-- Descriptions : curl & http wrapper for API testing (REST) and more
-- Author       : Kevin
-- Last Modified: 01 May 2024, 12:31
-------------------------------------

return {
  "kevinm6/rest.nvim",
  dev = true,
  -- dependencies = { "luarocks.nvim" },
  ft = { "http", "https" },
  config = function(_, o)
    o.skip_ssl_verification = true
    o.encode_url = true

    require("rest-nvim").setup(o)

    vim.keymap.set("n", "<localleader>r", "<cmd>Rest run<cr>", { desc = "Run Request under cursor", buffer = true })
    vim.keymap.set("n", "<localleader>l", "<cmd>Rest last<cr>", { desc = "Run Last Request", buffer = true })
    vim.keymap.set(
      "n",
      "<localleader>p",
      "<Plug>RestNvimPreview",
      { desc = "Preview Request cURL command", buffer = true }
    )
    vim.keymap.set("n", "<localleader>R", "<cmd>Rest run document<cr>", { desc = "Run File", buffer = true })
  end,
}