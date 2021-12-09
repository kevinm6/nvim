-------------------------------------
-- File: lsp-config.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 09/12/21 - 09:50
-------------------------------------

	install_root_dir = "/Users/Kevin/.local/share/nvim/lsp_servers/"

	-- Setup nvim-cmp.
	local cmp = require("cmp")
	local lsp_installer = require("nvim-lsp-installer")
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	local lspconfig = require("lspconfig")
	local luasnip = require("luasnip")

	-- Include the servers you want to have installed by default below
	local servers = {
		"vimls",
		"sumneko_lua",
		"bashls",
		"intelephense",
		"pyright",
		"clangd",
		"cssls",
		"html",
		"jdtls",
		"jsonls",
		"lemminx",
		"ltex",
		"pylsp",
		"sqlls"
		}

	lsp_installer.settings({
		ui = {
				icons = {
						server_installed = "✓",
						server_pending = "➜",
						server_uninstalled = "✗"
				}
		},
		keymaps = {
			toggle_server_expand = "<CR>", "o"
		},
	})


	for _, name in pairs(servers) do
		local server_is_found, server = lsp_installer.get_server(name)
		if server_is_found then
			if not server:is_installed() then
				print("Installing " .. name)
				server:install()
			end
		end
	end

	lsp_installer.on_server_ready(function(server)
  -- Specify the default options which we'll use to setup all servers
  local default_opts = {
    on_attach = on_attach,
  }

  -- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
  local server_opts = {
    -- Provide settings that should only apply to the "eslintls" server
    ["eslintls"] = function()
      default_opts.settings = {
        format = {
          enable = true,
        },
      }
    end,
  }
	-- Use the server's custom settings, if they exist, otherwise default to the default options
  local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
		server:setup(server_options)
	end)

	local runtime_path = vim.split(package.path, ';')
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	lspconfig.sumneko_lua.setup {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup lua path
					path = runtime_path,
					-- path = "/Users/Kevin/.local/share/nvim/lsp_servers/sumneko_lua",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {'vim'},
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {enable = false},
			},
		},
		single_file_support = false
	}


	lspconfig.jdtls.setup {
		cmd = {
			"/usr/local/Cellar/openjdk/17.0.1_1/libexec/openjdk.jdk/Contents/Home",
			"/Users/Kevin/.local/share/nvim/lsp_servers/jdtls"
		},
		filetypes = { "java" },
		-- handlers = {
		--   ["language/status"] = <function 1>,
			-- ["textDocument/codeAction"] = <function 2>,
		--   ["textDocument/rename"] = <function 3>,
		--   ["workspace/applyEdit"] = <function 4>
		-- },
		init_options = {
			jvm_args = {},
			workspace = "~/.cache/workspaces"
		},
		-- root_dir = { 
		-- 				{
              -- 'build.xml', -- Ant
              -- 'pom.xml', -- Maven
              -- 'settings.gradle', -- Gradle
              -- 'settings.gradle.kts', -- Gradle
            -- },
            -- -- Multi-module projects
            -- { 'build.gradle', 'build.gradle.kts' },
          -- } or vim.fn.getcwd(),
		single_file_support = true
	}

	lspconfig.vimls.setup {
		cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
      diagnostic = {
        enable = true
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


	-- Enable (broadcasting) snippet capability for completion
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	lspconfig.jsonls.setup {
		capabilities = capabilities,
	}

	lspconfig.sqlls.setup {
    filetypes = { "sql", "mysql" },
    root_dir = function(startpath)
			return M.search_ancestors(startpath, matcher)
		end,
    settings = {}
	}

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

	-- Setting capabilities
	for _, srv in pairs(servers) do
		require'lspconfig'[srv].setup {
			capabilities = capabilities
		}
	end


	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
			-- Insert-mode
			i = cmp.mapping.confirm({ select = true }),
			-- Command-mode
			c = cmp.mapping.confirm({ select = false }),
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
			{ name = 'ultisnips' },
		},
	})

	-- Use buffer source for `/`
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
			}
		})

	-- Use cmdline & path source for ':'
	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
		{ name = 'path' }
		}, {
		{ name = 'cmdline' }
		})
	})


