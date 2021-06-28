-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra confi
-- Author       : Kevin
-- Last Modified: 15 Dec 2022, 09:11
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 100
vim.opt_local.foldmethod = "syntax"
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "tcroqln"
vim.opt_local.comments:append { "nb:+", "nb:>", "nb:-", "nb:." }

vim.opt.spell = false
vim.opt.spellfile = "/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"

-- Add custom mappings only for markdown files
local md_mappings = {
  m = {
    name = "Markdown",
    p = {
      function() require "peek".open() end,
      "Open Peek preview"
    },
    P = {
      function() require "peek".close() end,
      "Close Peek preview"
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
