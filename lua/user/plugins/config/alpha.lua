-----------------------------------
--	File: alpha.lua
--	Description: alplha config for Neovim
--	Author: Kevin
--	Last Modified: 18 Jul 2022, 09:59
-----------------------------------

local ok, alpha = pcall(require, "alpha")
if not ok then
	return
end

local icons = require "user.icons"

local dashboard = require "alpha.themes.dashboard"

local newline = [[
]]

local date = function()
	return os.date("  %d/%m/%Y   %H:%M")
end

local nvim_version = function()
	local v = vim.version()
	local v_info = (icons.ui.Version .. " v" .. v.major .. "." .. v.minor .. "." .. v.patch)
	return v_info
end

dashboard.section.header.val = {
	[[               ]] .. date() .. newline,
	[[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
	[[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
	[[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
	[[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
	[[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
	[[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
	[[
  ]],
	[[                      ]] .. nvim_version(),
}

dashboard.section.buttons.val = {
	dashboard.button("n", icons.ui.NewFile .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
	dashboard.button("N", icons.ui.Note .. " Notes", "<cmd>e ~/Documents/Notes/notes.org <BAR> startinsert <CR>"),
	dashboard.button("t", icons.ui.Telescope .. " Open Telescope", "<cmd>Telescope <CR>"),
	dashboard.button("f", icons.documents.Files .. " Find file", "<cmd>Telescope find_files <CR>"),
	dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
	dashboard.button("R", icons.git.Repo .. " Find project", "<cmd>Telescope project <CR>"),
	dashboard.button("u", icons.ui.Uni .. " University", "<cmd>e $CS <CR>"),
	dashboard.button("d", icons.ui.Dev .. " Developer", "<cmd>e ~/Documents/Developer <CR>"),
	dashboard.button("p", icons.ui.Packer .. " Packer", "<cmd> PackerSync <CR>"),
	dashboard.button("P", icons.ui.Plugin .. " Plugins Configuration", "<cmd>e $NVIMDOTDIR/lua/user/plugins/init.lua<CR>"),
	dashboard.button("L", icons.ui.List .. " LspInstaller", "<cmd>LspInstallInfo <CR>"),
	dashboard.button("g", icons.ui.Git .. " Git", "<cmd>Git <CR>"),
	dashboard.button("l", icons.kind.Text .. " Live text grep", "<cmd>Telescope live_grep <CR>"),
	-- dashboard.button("s", icons.ui.SignIn .. " Find Session", "<cmd>Telescope sessions save_current=false <CR>"),
	dashboard.button(
		"C",
		icons.ui.Gear .. " Config",
		"<cmd>cd $NVIMDOTDIR <CR> <BAR> <cmd>e $NVIMDOTDIR/init.lua <CR>"
	),
	dashboard.button("h", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
	dashboard.button("c", icons.documents.Files .. " Close", "<cmd>Alpha<CR>"),
	dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
}

local footer = function()
  local plugins = #(vim.fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1)) +
  #(vim.fn.globpath("~/.local/share/nvim/site/pack/packer/opt", "*", 0, 1))
	local plugins_count = string.format(
    "           %s %d Plugins  \n\n",
    icons.ui.Plugin, plugins
	)

  local my_url =  "https://github.com/kevinm6/nvim"
	local myself = string.format(
    "%s %s %s",
    icons.ui.BoldChevronLeft, my_url, icons.ui.BoldChevronRight
  )

	return plugins_count..newline..newline..myself
end

dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

-- dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.opts)
