-------------------------------------
-- File         : ufo.lua
-- Description  : ufo plugin configuration (folding)
-- Author       : Kevin
-- Last Modified: 01 May 2024, 12:31
-------------------------------------

local ftMap = {
  vim = "indent",
  python = "indent",
  git = "",
  checkhealth = "",
  alpha = "",
  oil = "",
  yaml = "indent",
  [""] = "",
}

return {
  "kevinhwang91/nvim-ufo",
  event = "BufRead",
  dependencies = "luarocks.nvim",
  init = function()
    vim.o.foldcolumn = "auto"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = function(_, o)
    -- o.fold_virt_text_handler = handler

    o.open_fold_hl_timeout = 150
    o.preview = {
      win_config = {
        border = "rounded",
        winhighlight = "Special:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-b>",
        scrollD = "<C-f>",
      },
    }
    o.close_fold_kinds_for_ft = { "imports", "comment" }
    o.provider_selector = function(_, filetype, _)
      return ftMap[filetype] or { "treesitter", "indent" }
    end
  end,
  config = function(_, o)
    local ufo = require "ufo"
    ufo.setup(o)

    vim.keymap.set("n", "zr", function()
      ufo.openFoldsExceptKinds()
    end, { desc = "Folds less" })
    vim.keymap.set("n", "zR", function()
      ufo.openAllFolds()
    end, { desc = "Open All Folds" })
    vim.keymap.set("n", "zm", function()
      ufo.closeFoldsWith()
    end, { desc = "Folds more" })
    vim.keymap.set("n", "zM", function()
      ufo.closeAllFolds()
    end, { desc = "Close All Folds" })

    vim.api.nvim_set_hl(0, "UfoPreviewCursorsLine", { link = "Normal" })
    vim.api.nvim_set_hl(0, "UfoPreviewSbar", { link = "PmenuSbar" })
    vim.api.nvim_set_hl(0, "UfoPreviewThumb", { link = "PmenuThumb" })
    vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { link = "Comment" })
  end,
}
