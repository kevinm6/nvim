-------------------------------------
--  File         : ufo.lua
--  Description  : ufo plugin configuration (folding)
--  Author       : Kevin
--  Last Modified: 02 Jan 2023, 11:45
-------------------------------------

local M = {
  "kevinhwang91/nvim-ufo",
  event = "BufAdd",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter"
  },
  keys = {
    { "zc" }, { "zr" }, { "zR" }, { "zo" },
    { "zO" }, { "zm" }, { "zM" },
  }
}

function M.config()
  local ufo = require "ufo"

  vim.wo.foldcolumn = '1'
  vim.wo.foldlevel = 99
  vim.wo.foldenable = true

  ufo.setup {
    -- fold_virt_text_handler = handler,
    open_fold_hl_timeout = 150,
    preview = {
      win_config = {
        border = {'', '─', '', '', '', '─', '', ''},
        winhighlight = 'Normal:Folded',
        winblend = 0
      },
      mappings = {
        scrollU = '<C-b>',
        scrollD = '<C-f>'
      }
    },
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
  }

  -- require('ufo').setFoldVirtTextHandler(bufnr, handler)
end

return M
