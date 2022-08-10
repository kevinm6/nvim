-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra confi
-- Author       : Kevin
-- Last Modified: 04 Aug 2022, 23:28
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.foldmethod = "syntax"

vim.opt.spell = false
vim.opt.spellfile = "/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"

-- Add custom mappings only for markdown files
local md_mappings = {
  m = {
    name = "Markdown",
    o = {
      function() vim.cmd "MarkdownPreview" end,
      "Start MarkdownPreview"
    },
    s = {
      function() vim.cmd "MarkdownPreviewStop" end,
      "Stop MarkdownPreview"
    },
    t = {
      function() vim.cmd "MarkdownPreviewToggle" end,
      "Toggle MarkdownPreview"
    },
    m = {
      function() vim.cmd "Glow" end,
      "Floating Markdown Preview (Glow)"
    },
  },
}

local wk = require "which-key"
wk.register(md_mappings, {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
})
