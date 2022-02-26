-----------------------------------
--	File: alpha.lua
--	Description: alplha config for Neovim
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/alpha.lua
--	Last Modified: 22/02/2022 - 19:27
-----------------------------------


local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local icons = require "user.icons"

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", icons.documents.Files .. " Find file", "<cmd>Telescope find_files <CR>"),
  dashboard.button("e", icons.ui.NewFile .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
  dashboard.button(
    "p",
    icons.git.Repo .. " Find project",
    "<cmd>lua require('telescope').extensions.projects.projects()<CR>"
  ),
  dashboard.button("p", icons.ui.Download .. " Packer", "<cmd>WhichKey <leader>p <CR>"),
  dashboard.button("l", icons.ui.List .. " LspInstaller", "<cmd>LspInstallInfo <CR>"),
  dashboard.button("g", " Git", "<cmd>WhichKey <leader>g <CR>"),
  dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
  dashboard.button("t", icons.ui.List .. " Find text", "<cmd>Telescope live_grep <CR>"),
  dashboard.button("s", icons.ui.SignIn .. " Find Session", "<cmd>Telescope sessions save_current=false <CR>"),
  dashboard.button("c", icons.ui.Gear .. " Config", "<cmd>e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
}

local function footer()
  return "https://github.com/kevinm6/nvim"
end

dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
