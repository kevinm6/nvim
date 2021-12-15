-------------------------------------
-- File: lsp_installer.lua
-- Description: nvim-lsp-installer K config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp_installer.lua
-- Last Modified: 15/12/21 - 11:00
-------------------------------------

-- NVIM-LSP-INSTALLER {
	local lsp_installer = require('nvim-lsp-installer')
	lsp_installer.settings({
		ui = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		},
	})

  install_root_dir = vim.fn.expand("~/.local/share/nvim/lsp_servers/")

	lsp_installer.on_server_ready(function(server)

		-- Specify the default options which we'll use to setup all servers
		local default_opts = {
			on_attach = on_attach,
		}

		local server_opts = {}

		-- Use the server's custom settings, if they exist, otherwise default to the default options
		local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
			server:setup(server_options)
	end)
-- nvim-lsp-installer }

