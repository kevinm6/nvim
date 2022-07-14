--------------------------------------
-- File         : init.lua
-- Description  : K NeoVim & gui VimR configuration
-- Author       : Kevin
-- Last Modified: 14 Jul 2022, 09:40
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

local ok, err = pcall(require, "user.plugins")
if not ok then
  vim.notify(
    " Error loading module < user.plugins >\n" .. err,
    "Error",
    { timeout = 4600, title = "INIT ERROR" }
  )
end
