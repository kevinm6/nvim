--------------------------------------
-- File         : init.lua
-- Description  : NeoVim configuration
-- Author       : Kevin
-- Last Modified: 16 Jul 2023, 09:57
--------------------------------------

-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- check if NeoVim or Vim
if not vim.fn.has "nvim" == 1 then
  vim.cmd "source ~/.config/vim/vimrc"
  return
end

-- Use other Shadafile for Gui (VimR)
if vim.fn.has "gui_vimr" == 1 then
  vim.opt.shadafile = vim.fn.stdpath "cache" .. "/shada/gmain.shada"
elseif vim.g.vscode then
  vim.opt.shadafile = vim.fn.stdpath "cache" .. "/shada/vsnvim.shada"
  require "config.prefs"
  require "config.vars"
  return
else
  vim.opt.shadafile = vim.fn.stdpath "cache" .. "/shada/main.shada"
end

require "core.lazy"
