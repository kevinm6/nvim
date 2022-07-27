--------------------------------------
-- File         : init.lua
-- Description  : K NeoVim & gui VimR configuration
-- Author       : Kevin
-- Last Modified: 25 Jul 2022, 21:33
--------------------------------------

-- check if NeoVim or Vim
if not vim.fn.has "nvim" == 1 then
  vim.cmd "source ~/.config/vim/vimrc"
  return
end

-- Use other Shadafile for Gui (VimR)
if vim.fn.has "gui_vimr" == 1 then
  vim.opt.shadafile = vim.fn.stdpath "cache" .."/shada/gmain.shada"
else
  vim.opt.shadafile = vim.fn.stdpath "cache" .. "/shada/main.shada"
end
