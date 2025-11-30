--------------------------------------
-- File         : init.lua
-- Description  : NeoVim configuration
-- Author       : Kevin
-- Last Modified: 30 Nov 2025, 20:38
--------------------------------------

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.colorscheme "kurayami"

-- check if NeoVim or Vim
if not vim.fn.has "nvim" == 1 then
  vim.cmd.source "~/.config/vim/vimrc"
  return
end

-- Use other Shadafile for VSCode
if not vim.g.vscode then
  vim.opt.shadafile = vim.fn.stdpath "state" .. "/shada/main.shada"

  ---Statusline & Winbar
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      require("lib.ui.statusline").toggle()
      require("lib.ui.winbar").toggle()
    end
  })
  if vim.o.diff then return end

  require "km"
else
  vim.opt.shadafile = vim.fn.stdpath "state" .. "/shada/vscnvim.shada"
end