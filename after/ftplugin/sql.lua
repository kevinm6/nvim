vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 90
vim.opt_local.autoindent = true
vim.opt_local.commentstring = "-- %s"

vim.opt.spell = false

---Start postgresql service on sql files (Mac)
-- require("lib").run_brew_service("postgresql@14", false)

vim.api.nvim_create_user_command("UnescapeXml",
    [[:silent! %s/&amp;/&/g | silent! %s/&lt;/</g | silent! %s/&gt;/>/g | silent! %s/&apos;/'/g | silent! %s/&quot;/"/g]],
    { desc = "unescape xml file" })

vim.api.nvim_create_user_command("EscapeXml",
  [[:silent! %s/&/&amp;/g | silent!  %s/</&lt;/g | silent! %s/>/&gt;/g | silent! %s/'/&apos;/g | silent! %s/"/&quot;/g]],
  { desc = "escape xml file" })