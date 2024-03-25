--------------------------------------
-- File         : init.lua
-- Description  : NeoVim configuration
-- Author       : Kevin
-- Last Modified: 31 Mar 2024, 18:39
--------------------------------------

-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- check if NeoVim or Vim
if not vim.fn.has "nvim" == 1 then
  vim.cmd.source "~/.config/vim/vimrc"
  return
end

-- Use other Shadafile for VSCode
if vim.g.vscode then
  vim.opt.shadafile = vim.fn.stdpath("cache").."/shada/vscnvim.shada"
else
  vim.opt.shadafile = vim.fn.stdpath("cache").."/shada/main.shada"
end

require "config.lazy"