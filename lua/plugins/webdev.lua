-------------------------------------
-- File         : webdev.lua
-- Descriptions : curl & http wrapper for API testing (REST) and more
-- Author       : Kevin
-- Last Modified: 12/08/2025, 09:42
-------------------------------------


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "http", "https" },
  -- dev = true,
  callback  = function()
    vim.pack.add { "https://github.com/kevinm6/rest.nvim" }

    require("rest-nvim").setup {
      skip_ssl_verification = true,
      encode_url = true
    }

    vim.keymap.set("n", "<localleader>r", "<cmd>Rest run<cr>", { desc = "Run Request under cursor", buffer = true })
    vim.keymap.set("n", "<localleader>l", "<cmd>Rest last<cr>", { desc = "Run Last Request", buffer = true })
    vim.keymap.set(
      "n",
      "<localleader>p",
      "<Plug>RestNvimPreview",
      { desc = "Preview Request cURL command", buffer = true }
    )
    vim.keymap.set("n", "<localleader>R", "<cmd>Rest run document<cr>", { desc = "Run File", buffer = true })
  end
})