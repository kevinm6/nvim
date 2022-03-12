-----------------------------------
--	File: alpha.lua
--	Description: alplha config for Neovim
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/alpha.lua
--	Last Modified: 12/03/2022 - 12:18
-----------------------------------

local ok, alpha = pcall(require, "alpha")
if not ok then return end

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
  dashboard.button("n", icons.ui.NewFile .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
  dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
  dashboard.button("R", icons.git.Repo .. " Find project", "<cmd>Telescope project <CR>"),
  dashboard.button("u", icons.ui.Uni .. " University", "<cmd>e $CS <CR>"),
  dashboard.button("p", icons.ui.Packer .. " Packer", "<cmd>PackerSync <CR>"),
  dashboard.button("P", icons.ui.Plugin .. " Plugin Configuration", "<cmd>e $NVIMDOTDIR/lua/user/plugins.lua<CR>"),
  dashboard.button("L", icons.ui.List .. " LspInstaller", "<cmd>LspInstallInfo <CR>"),
  dashboard.button("g", icons.ui.Git .. " Git", "<cmd>WhichKey <leader>g <CR>"),
  dashboard.button("t", icons.ui.List .. " Find text", "<cmd>Telescope live_grep <CR>"),
  -- dashboard.button("s", icons.ui.SignIn .. " Find Session", "<cmd>Telescope sessions save_current=false <CR>"),
  dashboard.button("c", icons.ui.Gear .. " Config", "<cmd>cd $NVIMDOTDIR <CR> <BAR> <cmd>e $NVIMDOTDIR/init.lua <CR>"),
  dashboard.button("h", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
}

local function footer()
  return icons.ui.BoldChevronLeft .. " https://github.com/kevinm6/nvim " .. icons.ui.BoldChevronRight
end

dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

dashboard.opts.opts.noautocmd = false
vim.cmd [[ autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2 ]]

alpha.setup(dashboard.opts)
