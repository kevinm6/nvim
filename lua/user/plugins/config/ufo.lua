-------------------------------------
--  File         : ufo.lua
--  Description  : ufo plugin configuration (folding)
--  Author       : Kevin
--  Last Modified: 24 Jul 2022, 12:46
-------------------------------------

local ok, ufo = pcall(require, "ufo")
if not ok then return end

vim.wo.foldcolumn = '1'
vim.wo.foldlevel = 99
vim.wo.foldenable = true

-- local handler = function(virtText, lnum, endLnum, width, truncate)
--     local newVirtText = {}
--     local suffix = ('  %d '):format(endLnum - lnum)
--     local sufWidth = vim.fn.strdisplaywidth(suffix)
--     local targetWidth = width - sufWidth
--     local curWidth = 0
--     for _, chunk in ipairs(virtText) do
--         local chunkText = chunk[1]
--         local chunkWidth = vim.fn.strdisplaywidth(chunkText)
--         if targetWidth > curWidth + chunkWidth then
--             table.insert(newVirtText, chunk)
--         else
--             chunkText = truncate(chunkText, targetWidth - curWidth)
--             local hlGroup = chunk[2]
--             table.insert(newVirtText, {chunkText, hlGroup})
--             chunkWidth = vim.fn.strdisplaywidth(chunkText)
--             -- str width returned from truncate() may less than 2nd argument, need padding
--             if curWidth + chunkWidth < targetWidth then
--                 suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
--             end
--             break
--         end
--         curWidth = curWidth + chunkWidth
--     end
--     table.insert(newVirtText, {suffix, 'MoreMsg'})
--     return newVirtText
-- end
-- buffer scope handler
-- will override global handler if it is existed
-- local bufnr = vim.api.nvim_get_current_buf()

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
