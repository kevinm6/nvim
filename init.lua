--------------------------------------
-- File         : init.lua
-- Description  : K NeoVim & gui VimR configuration
-- Author       : Kevin
-- Last Modified: 12 Jun 2022, 13:39
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

-- Config Files to source
local modules = {
  "user.plugins",
  "user.prefs",
  "user.keymaps",
  "user.vars",
  "user.colorscheme",
  "user.autocommands",
  "user.statusline",
  -- "user.winbar", -- TODO: uncomment when in Nvim 0.8
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

print(require("user.icons").ui.Check, nModules, "modules loaded")
