-------------------------------------
-- File         : rest.lua
-- Descriptions : curl & http wrapper for API testing and more
-- Author       : Kevin
-- Last Modified: 28 May 2023, 20:43
-------------------------------------

local M = {
   "rest-nvim/rest.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   opts = function(_, o)
      -- Open request results in a horizontal split
      o.result_split_horizontal = false
      -- Keep the http file buffer above|left when split horizontal|vertical
      o.result_split_in_place = false
      -- Skip SSL verification, useful for unknown certificates
      o.skip_ssl_verification = false
      -- Encode URL before making request
      o.encode_url = true
      -- Highlight request on run
      o.highlight = {
         enabled = true,
         timeout = 150,
      }
      o.result = {
         -- toggle showing URL, HTTP info, headers at top the of result window
         show_url = true,
         show_http_info = true,
         show_headers = true,
         -- executables or functions for formatting response body [optional]
         -- set them to false if you want to disable them
         formatters = {
            json = "jq",
            html = function(body)
               return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
         },
      }
      -- Jump to request line on run
      o.jump_to_request = false
      o.env_file = ".env"
      o.custom_dynamic_variables = {}
      o.yank_dry_run = true
   end,
}

return M
