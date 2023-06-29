-------------------------------------
-- File         : comment.lua
-- Description  : Comment config
-- Author       : Kevin
-- Last Modified: 14 Jul 2023, 17:24
-------------------------------------

local M = {
   "numToStr/Comment.nvim",
   event = { "BufReadPre", "BufNewFile" },
   keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
      {
         "/",
         function()
            require("Comment.api").toggle.linewise.current(vim.fn.visualmode())
         end,
         desc = "comment",
         mode = "v",
      },
   },
   opts = function(_, o)
      o.ignore = "^$"

      o.pre_hook = function(ctx)
         require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
         local javascript_filetypes = {
           typescriptreact = true,
           javascriptreact = true,
           javascript = true,
           typescript = true,
         }

         if javascript_filetypes[vim.bo.filetype] then
            local U = require "Comment.utils"

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
               location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
               location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring {
               key = type,
               location = location,
            }
         end
      end
   end,
}

return M
