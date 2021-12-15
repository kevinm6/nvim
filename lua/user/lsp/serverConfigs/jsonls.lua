-------------------------------------
-- File: jsonls.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "jsonls"

configs[name] = {
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	capabilities = capabilities,
}


-- JSON {
	-- Enable (broadcasting) snippet capability for completion
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	-- lspconfig.jsonls.setup {
	-- 	capabilities = capabilities,
	-- }
-- JSON }


