-------------------------------------
-- File         : pdf.lua
-- Description  : PDF filetype extra config
-- Author       : Kevin
-- Last Modified: 08/02/2025 - 09:43
-------------------------------------

vim.api.nvim_set_option_value("readonly", true, { buf = 0 })
if not vim.fn.executable "pdftotext" then
  vim.notify("vim-pdf: pdftotext is not found.\nStop converting...", vim.log.levels.ERROR)
  return
end

require("lib.pdf").load_pdf(vim.api.nvim_buf_get_name(0))
