-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra config
-- Author       : Kevin
-- Last Modified: 27 Jul 2024, 09:18
-------------------------------------

-- vim.opt_local.makeprg = "glow"
-- vim.opt_local.errorformat = ""

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

---use QuickView to preview markdown on Mac
if vim.fn.has "mac" == 1 then
  vim.keymap.set("n", "<leader>p", function()
    local buf = vim.api.nvim_buf_get_name(0)
    vim.system({ "qlmanage", "-p", buf, "2&>1", "/dev/null" }, { text = true }):wait()
  end, { desc = "Preview Markdown", buffer = true })
end

local has_rendermd, render_md = pcall(require, "render-markdown")
if has_rendermd then
  vim.keymap.set("n", "<leader>r", function()
    render_md.toggle()
  end, { buffer = true, desc = "Render Markdown" })
end

---Export to PDF
vim.api.nvim_create_user_command("TOpdf", function()
  require("lib.pdf").convert_md_to_pdf()
end, { desc = "Export markdown to pdf" })