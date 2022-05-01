--
--------------------------------------
-- File         : init.lua
-- Description  : K NeoVim & gui VimR configuration
-- Author       : Kevin
-- Last Modified: 31/03/2022 - 10:22
--------------------------------------

-- check if NeoVim or Vim
if not (vim.fn.has("nvim")) == 1 then
  vim.cmd("source ~/.config/vim/vimrc")
  return
end

-- Use other Shadafile for Gui (VimR)
if vim.fn.has("gui_vimr") == 1 then
  vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/gmain.shada")
else
  vim.opt.shadafile = vim.fn.expand("~/.cache/nvim/shada/main.shada")
end

-- Config Files to source
local modules = {
  "user.impatient",
  "user.prefs",
  "user.keymaps",
  "user.plugins",
  "user.vars",
  "user.icons",
  "user.cmp",
  "user.lsp",
  "user.notify",
  "user.gps",
  "user.telescope",
  "user.treesitter",
  "user.autopairs",
  "user.comment",
  "user.gitsigns",
  "user.git-blame",
  "user.nvim-tree",
  "user.bufferline",
  "user.toggleterm",
  "user.whichkey",
  "user.autocommands",
  "user.statusline",
  "user.surround",
  -- "user.renamer",
  "user.todo-comments",
  "user.registers",
  "user.alpha",
  "user.symbol-outline",
  "user.sniprun",
  "user.dap",
  "user.hop",
  "user.colorizer",
  "user.illuminate",
  "user.zen-mode",
  "user.colorscheme",
}

local nModules = 0
for index, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify(
      " Error loading module < " .. module .. " >\n" .. err,
      "Error",
      { timeout = 4600, title = "INIT ERROR" }
    )
  else
    nModules = index
  end
end
print(" ✔ " .. nModules .. " modules loaded")
