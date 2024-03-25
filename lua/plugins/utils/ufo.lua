-------------------------------------
-- File         : ufo.lua
-- Description  : ufo plugin configuration (folding)
-- Author       : Kevin
-- Last Modified: 31 Mar 2024, 19:19
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

local function handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = string.format(' 󰁂 %d ', endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. string.rep(' ', targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end


local M = {
  "kevinhwang91/nvim-ufo",
  event = "BufRead",
  dependencies = { "luarocks" },
  init = function()
    vim.o.foldcolumn = 'auto'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = function(_, o)
    o.fold_virt_text_handler = handler

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
    o.close_fold_kinds_for_ft = { 'imports', 'comment' }
    o.provider_selector = function(_, filetype, _)
      return ftMap[filetype] or { 'treesitter', 'indent' }
    end
  end,
  config = function(_, o)
    local ufo = require "ufo"
    ufo.setup(o)

    vim.keymap.set("n", "zr", function() ufo.openFoldsExceptKinds() end,
      { desc = "Folds less" })
    vim.keymap.set("n", "zR", function() ufo.openAllFolds() end,
      { desc = "Open All Folds" })
    vim.keymap.set("n", "zm", function() ufo.closeFoldsWith() end, { desc = "Folds more" })
    vim.keymap.set("n", "zM", function() ufo.closeAllFolds() end,
      { desc = "Close All Folds" })
  end
}

return M