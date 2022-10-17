-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration
-- Author       : Kevin
-- Last Modified: 14 Oct 2022, 10:14
-------------------------------------

local lspbufformat = vim.api.nvim_create_augroup("lsp_buf_format", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = lspbufformat,
  callback = function()
    vim.lsp.buf.formatting_sync()
  end,
})
