-------------------------------------
-- File         : comment.lua
-- Description  : Comment config
-- Author       : Kevin
-- Last Modified: 04 Jan 2023, 15:16
-------------------------------------

local M = {
  "numToStr/Comment.nvim",
  event = "BufReadPre",
  keys = {
    { "gcc", mode = {"n", "v"} },
    { "gbc", mode = {"n", "v"} },
    { "gbO", mode = {"n", "v"} },
    { "gbo", mode = {"n", "v"} },
    { "gcO", mode = {"n", "v"} },
    { "gcA", mode = {"n", "v"} },
    { "gco", mode = {"n", "v"} },
    { "/", function()
    require "comment.api".toggle.linewise.current(vim.fn.visualmode())
  end, desc = "comment", mode = "v" },
  }
}

function M.config()
  local comment = require "Comment"

  comment.setup {
    padding = true,
    sticky = true,
    ignore = "^$",
    ---LHS of toggle mappings in NORMAL + VISUAL mode
    ---@type table
    toggler = {
      ---Line-comment toggle keymap
      line = 'gcc',
      ---Block-comment toggle keymap
      block = 'gbc',
    },

    ---LHS of operator-pending mappings in NORMAL + VISUAL mode
    ---@type table
    opleader = {
      ---Line-comment keymap
      line = 'gc',
      ---Block-comment keymap
      block = 'gb',
    },

    ---LHS of extra mappings
    ---@type table
    extra = {
      ---Add comment on the line above
      above = 'gcO',
      ---Add comment on the line below
      below = 'gco',
      ---Add comment at the end of line
      eol = 'gcA',
    },
    pre_hook = function(ctx)
      if
        vim.bo.filetype == "typescriptreact"
        or vim.bo.filetype == "javascriptreact"
        or vim.bo.filetype == "javascript"
        or vim.bo.filetype == "typescript"
      then

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
    end,
  }

end

return M