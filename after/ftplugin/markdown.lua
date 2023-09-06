-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra config
-- Author       : Kevin
-- Last Modified: 29 Sep 2023, 09:15
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 3
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 100
vim.opt_local.foldmethod = "syntax"
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "tcoqln"
vim.opt_local.comments:append { "nb:+", "nb:>", "nb:-", "nb:." }

vim.opt.spell = false
vim.opt.spellfile = "~/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"

vim.api.nvim_create_autocmd("BufEnter", {
   pattern = "*.md",
   callback = function()
      vim.cmd [[
         syntax match @text.todo.unchecked.markdown '\v(\s+)?-\s\[\s\]'hs=e-4 conceal cchar=☐
         syntax match @text.todo.checked.markdown '\v(\s+)?-\s\[x\]'hs=e-4 conceal cchar=
      ]]
   end
})

-- add custom mappings only for markdown files
-- if plugin 'peek' is installed
local has_peek, peek = pcall(require, "peek")
if has_peek then
   vim.keymap.set("n", "<leader>mp", function()
      if peek.is_open() then
         peek.close()
      else
         peek.open()
      end
   end, { desc = "Markdown Preview [Peek]" })
else
   vim.notify("Peek is not installed or loaded!\n Can't preview markdown!", vim.log.levels.WARN)
end
