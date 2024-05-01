-------------------------------------
--  File         : peek.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 01 May 2024, 12:32
-------------------------------------

return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  cmd = { 'PeekOpen', 'PeekClose' },
  ft = { 'md', 'markdown', 'quarto', 'qmd' },
  config = function(_, o)
    o.app = 'browser'
    require 'peek'.setup(o)
    vim.api.nvim_create_user_command("PeekOpen", function() require "peek".open() end, {})
    vim.api.nvim_create_user_command("PeekClose", function() require "peek".close() end, {})
  end
}