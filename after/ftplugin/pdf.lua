-------------------------------------
--  File         : pdf.lua
--  Description  : use Neovim as pdf reader (need pdftotext binaries)
--  Author       : Kevin
--  Last Modified: 01 Mar 2023, 21:17
-------------------------------------

if vim.fn.exists("g:vim_pdf_loaded") then return end

vim.g.vim_pdf_loaded = 1

local pdf_cache = {}

local function load_pdf()
  if (vim.fn.line('$') < 2 or vim.fn.strpart(vim.fn.getline(1), 1, 3) ~= "PDF") then
    vim.notify("vim-pdf: not a valid pdf file.\nStop converting...", "Error")
    return
  end

  if not vim.fn.executable "pdftotext" then
    vim.notify("vim-pdf: pdftotext is not found.\nStop converting...", "Error")
    return
  end

  vim.cmd "silent %delete"

  local pdf = vim.fn.escape(vim.fn.expand "%", "'")
  local pdf_cache_file
  if pdf_cache[pdf] ~= nil then
    pdf_cache_file = pdf_cache[pdf]
    vim.cmd("silent '[-1read " .. pdf_cache_file .. "'")
  else
    pdf_cache_file = vim.fn.escape(vim.fn.tempname(), "'")
    vim.fn.system("pdftotext -nopgbrk -layout '" .. pdf .. "' '" .. pdf_cache_file .. "'")
    vim.cmd("silent '[-1read " .. pdf_cache_file .. "'")
    pdf_cache[pdf] = pdf_cache_file
  end

  vim.opt_local.nowrite = true
  vim.opt_local.filetype = "text"
end

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*.pdf" },
  callback = load_pdf(),
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
  pattern = { "*.pdf" },
  callback = vim.cmd.update()
})
