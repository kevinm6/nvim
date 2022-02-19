-----------------------------------
-- File: lsp-installer.lua
-- Description: Lsp-Installer config
-- Author: Kevin
-- Source: https://github.com/kevinm6/lua/user/lsp/lsp-installer.lua
-- Last Modified: 19/02/2022 - 13:50
-------------------------------------

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server.name == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server.name == "pyright" then
		local pyright_opts = require("user.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server.name == "jdtls" then
		return
		-- local jdtls_opts = require("user.lsp.settings.jdtls")
		-- opts = vim.tbl_deep_extend("force", jdtls_opts, opts)
	end

	if server.name == "sqlls" then
		local sqlls_opts = require("user.lsp.settings.sqlls")
		opts = vim.tbl_deep_extend("force", sqlls_opts, opts)
	end

	if server.name == "ltex" then
		local ltex_opts = require("user.lsp.settings.ltex")
		opts = vim.tbl_deep_extend("force", ltex_opts, opts)
	end

	if server.name == "emmet_ls" then
		local emmet_ls_opts = require "user.lsp.settings.emmet_ls"
		opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
	end

	server:setup(opts)
end)

