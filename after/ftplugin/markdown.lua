-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra config
-- Author       : Kevin
-- Last Modified: 27 Jul 2024, 09:18
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = false
vim.opt_local.wrap = true
vim.opt_local.textwidth = 100
-- vim.opt_local.linebreak = true
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "tcoqln"
vim.opt_local.comments:append { "nb:+", "nb:>", "nb:-", "nb:." }
vim.opt_local.spell = true

vim.keymap.set("n", "<leader>p", function()
  local buf = vim.api.nvim_buf_get_name(0)
  vim.system({ "qlmanage", "-p", buf, ">", "/dev/null" }, { text = true }):wait()
end, { desc = "Preview Markdown", buffer = true })

---Export to PDF
vim.api.nvim_create_user_command("TOpdf", function()
  require("lib.pdf").convert_md_to_pdf()
end, { desc = "Export markdown to pdf" })

--TODO: check after official release
--marksman isn't starting automatically
-- vim.lsp.start(vim.lsp.config.marksman)