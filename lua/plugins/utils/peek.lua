-------------------------------------
--  File         : peek.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 02 Jul 2023, 13:07
-------------------------------------

local M = {
   "toppair/peek.nvim",
   build = "deno task --quiet build:fast",
   cmd = { "PeekOpen", "PeekClose" },
   ft = { "md", "markdown" },
   config = function()
      vim.api.nvim_create_user_command("PeekOpen", function() require"peek".open() end, {})
      vim.api.nvim_create_user_command("PeekClose", function() require"peek".close() end, {})
   end
}

return M
