-------------------------------------
---- File: jtdls.lua
---- Description: LanguageServerProtocol K configuration
---- Author: Kevin
---- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
---- Last Modified: 15/12/21 - 11:50
---------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "jtdls"

configs[name] = {
		cmd = {
			"/usr/local/Cellar/openjdk/17.0.1_1/libexec/openjdk.jdk/Contents/Home",
			"/Users/Kevin/.local/share/nvim/lsp_servers/jdtls",
			vim.fn.expand"~/.local/share/nvim/lsp_servers/jdtls"
		},
		filetypes = { "java" },
		init_options = {
			jvm_args = {},
			workspace = "~/.cache/workspaces"
		},
		single_file_support = true
}

-- Java {
	-- lspconfig.jdtls.setup {
	-- 	cmd = {
	-- 		"/usr/local/Cellar/openjdk/17.0.1_1/libexec/openjdk.jdk/Contents/Home",
	-- 		"/Users/Kevin/.local/share/nvim/lsp_servers/jdtls",
	-- 		vim.fn.expand"~/.local/share/nvim/lsp_servers/jdtls"
	-- 	},
	-- 	filetypes = { "java" },
	-- 	init_options = {
	-- 		jvm_args = {},
	-- 		workspace = "~/.cache/workspaces"
	-- 	},
	-- 	single_file_support = true
	-- }
-- Java }


