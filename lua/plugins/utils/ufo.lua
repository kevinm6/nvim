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
  dependencies = { "kevinhwang91/promise-async" },
  opts = function(_, o)
    vim.o.foldcolumn = "auto"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    -- vim.o.statuscolumn = "%s%{v:relnum?v:relnum:v:lnum}%=%C "

    o.open_fold_hl_timeout = 150
    o.preview = {
      win_config = {
        border = "single",
        winhighlight = "Special:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-b>",
        scrollD = "<C-f>",
      },
    }
    o.close_fold_kinds_for_ft = { default = { "imports", "comment" } }
    o.provider_selector = function(_, filetype, _)
      return ftMap[filetype] or { "treesitter", "indent" }
    end

    local ufo = require "ufo"
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

-- NOTE: to remove signcolumn lines, build Neovim from source after modify
-- `src/nvim/drawline.c:420`
-- https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1500423577
