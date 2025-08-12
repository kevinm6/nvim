vim.api.nvim_set_option_value("readonly", true, { buf = 0 })
if not vim.fn.executable "pdftotext" then
  vim.notify("vim-pdf: pdftotext is not found.\nStop converting...", vim.log.levels.ERROR, { title = "PDF file" })
  return
end

require("lib.pdf").load_pdf(vim.api.nvim_buf_get_name(0))