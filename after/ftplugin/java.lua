local f = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
vim.opt_local.makeprg = "javac % && java " .. f

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})