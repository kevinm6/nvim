-------------------------------------
-- File: lsp_installer.lua
-- Description: nvim-lsp-installer K config
-- Author: Kevin
-- Source: https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/lsp/lsp-installer.lua
-- Last Modified: 15/12/21 - 12:20
-------------------------------------

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Servers {
-- Include the servers you want to have installed by default below
	local servers = {
		'sumneko_lua',
		'vimls',
		'bashls',
		'intelephense',
		'pyright',
		'clangd',
		'cssls',
		'html',
		'jdtls',
		'jsonls',
		'lemminx',
		'ltex',
		'sqlls'
	}

	for _, name in pairs(servers) do
		local server_is_found, server = lsp_installer.get_server(name)
		if server_is_found then
			if not server:is_installed() then
				print("Installing " .. name)
				server:install()
			end
		end
	end
-- Servers }


-- Set capabilities {
	for _, srv in pairs(servers) do
		lspconfig[srv].setup {
				capabilities = capabilities
		}
	end
-- Set capabilities }


lsp_installer.settings {
	ui = {
		server_installed = "✓",
		server_pending = "➜",
		server_uninstalled = "✗"
	},
}

install_root_dir = vim.fn.expand("~/.local/share/nvim/lsp_servers/")

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("handlers").on_attach,
		capabilities = require("handlers").capabilities,
	}

	if server.name == "jsonls" then
		local jsonls_opts = require("serverConfigs.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("serverConfigs.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	 end

	if server.name == "clangd" then
	 	local clangd_opts = require("serverConfigs.clangd")
	 	opts = vim.tbl_deep_extend("force", clangd_opts, opts)
	end

	if server.name == "jtdls" then
		local jtdls_opts = require("serverConfigs.jtdls")
		opts = vim.tbl_deep_extend("force", jtdls_opts, opts)
	end

	if server.name == "vimls" then
		local vimls_opts = require("serverConfigs.vimls")
		opts = vim.tbl_deep_extend("force", vimls_opts, opts)
	end

	if server.name == "sqlls" then
		local sqlls_opts = require("serverConfigs.sqlls")
		opts = vim.tbl_deep_extend("force", sqlls_opts, opts)
	end

	if server.name == "html" then
		local html_opts = require("serverConfigs.html")
		opts = vim.tbl_deep_extend("force", html_opts, opts)
	end

	if server.name == "pyright" then
		local pyright_opts = require("serverConfigs.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server.name == "intelephpsense" then
		local php_opts = require("serverConfigs.intelephpsense")
		opts = vim.tbl_deep_extend("force", php_opts, opts)
	end

	if server.name == "ltex" then
		local ltex_opts = require("serverConfigs.ltex")
		opts = vim.tbl_deep_extend("force", ltex_opts, opts)
	end

	if server.name == "cssls" then
		local cssls_opts = require("serverConfigs.cssls")
		opts = vim.tbl_deep_extend("force", cssls_opts, opts)
	end

	if server.name == "lemminx" then
		local lemminx_opts = require("serverConfigs.lemminx")
		opts = vim.tbl_deep_extend("force", lemminx_opts, opts)
	end

	if server.name == "bashls" then
		local bashls_opts = require("serverConfigs.bashls")
		opts = vim.tbl_deep_extend("force", bashls_opts, opts)
	end

	if server.name == "emmet_ls" then
		local emmet_ls_opts = require("serverConfigs.emmet_ls")
		opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
	end

	if server.name == "go" then
		local go_opts = require("serverConfigs.go")
		opts = vim.tbl_deep_extend("force", go_opts, opts)
	end

	server:setup(opts)
end)
