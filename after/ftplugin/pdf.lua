vim.api.nvim_set_option_value("readonly", true, { buf = 0 })
assert(vim.fn.executable "pdftotext" == 1, "PDF - pdftotext is not found.\nCan't convert...")

require("lib.pdf").load_pdf(vim.api.nvim_buf_get_name(0))