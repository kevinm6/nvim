-------------------------------------
-- File: sumneko_lua.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:20
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "sumneko_lua"

configs[name] = {
	default_config = {
    filetypes = {'lua'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
    settings = { 
			Lua = { 
				runtime = {
					version = 'LuaJIT',
				},
				diagnostics = {
					globals = {'vim'},
				},
				telemetry = { enable = false },
			},
			
		};
  };
}


-- Lua {
	-- lspconfig.sumneko_lua.setup {
	-- 	cmd = { "lua-language-server" },
	-- 	settings = {
	-- 		Lua = {
	-- 			runtime = {
	-- 				version = 'LuaJIT', -- LuaJIT version for Neovim
	-- 				path = vim.split(package.path, ';')
	-- 			},
	-- 			diagnostics = {
	-- 				globals = {'vim'},
	-- 			},
	-- 			workspace = {
	-- 				[vim.fn.expand('$VIMRUNTIME/lua')] = true,
	-- 				[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
	-- 			},
	-- 			telemetry = { enable = false },
	-- 		},
	-- 	},
	-- }
-- Lua }


