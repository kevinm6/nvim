-------------------------------------
-- File: lsp-config.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 10/12/21 - 12:20
-------------------------------------

install_root_dir = "/Users/Kevin/.local/share/nvim/lsp_servers/"

-- Local variables {
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local lspconfig = require('lspconfig')
	local lsp_installer = require('nvim-lsp-installer')
-- Local variables }

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
		'pylsp',
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


-- Lua {
	local runtime_path = vim.split(package.path, ';')
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	lspconfig.sumneko_lua.setup {
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJIT', -- LuaJIT version for Neovim
					path = runtime_path,
					-- path = "/Users/Kevin/.local/share/nvim/lsp_servers/sumneko_lua",
				},
				diagnostics = {
					globals = {'vim'},
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = { enable = false },
			},
		},
	}
-- Lua }


-- Java {
	lspconfig.jdtls.setup {
		cmd = {
			"/usr/local/Cellar/openjdk/17.0.1_1/libexec/openjdk.jdk/Contents/Home",
			"/Users/Kevin/.local/share/nvim/lsp_servers/jdtls"
		},
		filetypes = { "java" },
		init_options = {
			jvm_args = {},
			workspace = "~/.cache/workspaces"
		},
		single_file_support = true
	}
-- Java }


-- VimL {
	lspconfig.vimls.setup {
		cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
      diagnostic = {
        enable = false
      },
      indexes = {
        count = 3,
        gap = 100,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
        runtimepath = true
      },
      iskeyword = "@,48-57,_,192-255,-#",
      runtimepath = "",
      suggest = {
        fromRuntimepath = true,
        fromVimruntime = true
      },
      vimruntime = ""
    },
    root_dir = function(fname)
			return util.find_git_ancestor(fname) or vim.fn.getcwd()
		end
	}
-- VimL }


-- JSON {
	-- Enable (broadcasting) snippet capability for completion
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	lspconfig.jsonls.setup {
		capabilities = capabilities,
	}
-- JSON }


-- SQL {
	lspconfig.sqlls.setup {
    filetypes = { "sql", "mysql" },
    root_dir = function(startpath)
			return M.search_ancestors(startpath, matcher)
		end,
    settings = {}
	}
-- SQL }


-- LaTex {
	lspconfig.ltex.setup {
	cmd = { "ltex-ls" },
    filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
    get_language_id = function(_, filetype)
          local language_id = language_id_mapping[filetype]
          if language_id then
            return language_id
          else
            return filetype
          end
        end,
    root_dir = function(path)
        -- Support git directories and git files (worktrees)
        if M.path.is_dir(M.path.join(path, '.git')) or M.path.is_file(M.path.join(path, '.git')) then
          return path
        end
			end
	}
-- LaTex }


-- Set capabilities {
	for _, srv in pairs(servers) do
		lspconfig[srv].setup {
				capabilities = capabilities
		}
	end
-- Set capabilities }
