--------------------------------------
-- File         : init.lua
-- Description  : NeoVim configuration
-- Author       : Kevin
-- Last Modified: 13 Jul 2024, 16:10
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
else
  vim.opt.shadafile = vim.fn.stdpath "state" .. "/shada/vscnvim.shada"
end

require "plugins"

-- local lazy_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
-- if not vim.uv.fs_stat(lazy_path) then
--   vim.fn.system {
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "--single-branch",
--     "https://github.com/folke/lazy.nvim.git",
--     lazy_path,
--   }
-- end
-- vim.opt.rtp:prepend(lazy_path)
--
-- local has_lazy, lazy = pcall(require, "lazy")
-- if not has_lazy then
--   vim.notify(
--     string.format("Error loading lazy config \n (%s) \n", lazy),
--     vim.log.levels.ERROR,
--     { timeout = 2000, title = "Lazy" }
--   )
--   return
-- else
--   require "lazy_config"
-- end