-------------------------------------
-- File: vimls.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "vimls"

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

-- -- VimL {
-- 	lspconfig.vimls.setup {
-- 		cmd = { "vim-language-server", "--stdio" },
--     filetypes = { "vim" },
--     init_options = {
--       diagnostic = {
--         enable = true
--       },
--       indexes = {
--         count = 3,
--         gap = 100,
--         projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
--         runtimepath = true
--       },
--       iskeyword = "@,48-57,_,192-255,-#",
--       runtimepath = "",
--       suggest = {
--         fromRuntimepath = true,
--         fromVimruntime = true
--       },
--       vimruntime = ""
--     },
--     root_dir = function(fname)
-- 			return util.find_git_ancestor(fname) or vim.fn.getcwd()
-- 		end
-- 	}
-- -- VimL }


