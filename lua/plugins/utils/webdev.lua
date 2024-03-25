-------------------------------------
-- File         : webdev.lua
-- Descriptions : curl & http wrapper for API testing and more
-- Author       : Kevin
-- Last Modified: 26 Mar 2024, 13:40
-------------------------------------

local M = {
  {
    "vhyrro/luarocks.nvim",
    name = "luarocks",
    init = function(p)
      package.path = package.path .. ";" .. p.dir .. "/.rocks/share/lua/5.1/?/?.lua;"
      package.path = package.path ..
          ";" .. vim.env.HOME .. "/.luarocks/share/lua/5.1/?/init.lua"
      package.path = package.path .. ";" .. vim.env.HOME ..
          "/.luarocks/share/lua/5.1/?.lua"
    end,
    config = true
  },
  {
    "rest-nvim/rest.nvim",
    -- commit = "b43d338",
    dependencies = { "luarocks" },
    ft = { "http", "https" },
    config = function(_, o)
      o.result_split_horizontal = true
      o.skip_ssl_verification = true
      o.encode_url = true

      require "rest-nvim".setup(o)

      vim.keymap.set("n", "<localleader>r", "<cmd>Rest run<cr>",
        { desc = "Run Request under cursor", buffer = true })
      vim.keymap.set("n", "<localleader>l", "<cmd>Rest last<cr>",
        { desc = "Run Last Request", buffer = true })
      vim.keymap.set("n", "<localleader>p", "<Plug>RestNvimPreview",
        { desc = "Preview Request cURL command", buffer = true })
      vim.keymap.set("n", "<localleader>R", "<cmd>Rest run document<cr>",
        { desc = "Run File", buffer = true })
    end
  }
}

return M