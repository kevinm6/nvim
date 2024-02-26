-------------------------------------
-- File         : ufo.lua
-- Description  : ufo plugin configuration (folding)
-- Author       : Kevin
-- Last Modified: 27 Feb 2024, 10:15
-------------------------------------

local ftMap = {
  vim = "indent",
  python = "indent",
  git = '',
  checkhealth = '',
  alpha = '',
  oil = '',
  yaml = "indent",
  [""] = ""
}


local M = {
  "kevinhwang91/nvim-ufo",
  event = "BufRead",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    vim.o.foldcolumn = 'auto'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = function(_, o)
    -- fold_virt_text_handler = handler,

    o.open_fold_hl_timeout = 150
    o.preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        winhighlight = "Special:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-b>",
        scrollD = "<C-f>",
      },
    }
    o.close_fold_kinds = { 'imports', 'comment' }
    o.provider_selector = function(bufnr, filetype, _)
      return ftMap[filetype] or { 'treesitter', 'indent' }
    end
  end,
  config = function(_, o)
    local ufo = require "ufo"
    ufo.setup(o)

    vim.keymap.set("n", "zr", function() ufo.openFoldsExceptKinds() end, { desc = "Folds less" })
    vim.keymap.set("n", "zR", function() ufo.openAllFolds() end, { desc = "Open All Folds" })
    vim.keymap.set("n", "zm", function() ufo.closeFoldsWith() end, { desc = "Folds more" })
    vim.keymap.set("n", "zM", function() ufo.closeAllFolds() end, { desc = "Close All Folds" })
  end
}

return M