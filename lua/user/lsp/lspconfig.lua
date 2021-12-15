-------------------------------------
-- File: lspconfig.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp-config.lua
-- Last Modified: 15/12/21 - 10:50
-------------------------------------

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

-- Local variables {
	local lspconfig = require('lspconfig')
	local configs = require('lspconfig/configs')

	local lsp_installer = require "nvim-lsp-installer"
	require("user.lsp.handlers").setup()

	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local M = {
		util = require ('lspconfig.util');
	}
-- Local variables }

function M.available_servers()
  return vim.tbl_keys(configs)
end

-- Surround {
	require('surround').setup {mappings_style = "surround"}
-- Surround }

