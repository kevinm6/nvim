vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.autoindent = true

vim.opt_local.spell = true

vim.g.vimtex_compiler_latexmk = {
  aux_dir = vim.fn.stdpath "cache" .. "/vimtex/aux_dir/" .. vim.fn.expand "%:t:r",
}