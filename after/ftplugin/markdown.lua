-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra confi
-- Author       : Kevin
-- Last Modified: 06 May 2023, 11:06
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

-- Add custom mappings only for markdown files

local has_peek, peek = pcall(require, "peek")
if not has_peek then
   vim.notify("Peek is not installed or loaded!", vim.log.levels.WARN)
   return
end
vim.keymap.set("n", "<leader>mp", function()
   if peek.is_open() then
      peek.close()
   else
      peek.open()
   end
end, { desc = "Markdown Preview [Peek]" })
