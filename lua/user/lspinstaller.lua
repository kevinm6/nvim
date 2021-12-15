-------------------------------------
-- File: lspinstaller.lua
-- Description: nvim-lsp-installer K config
-- Author: Kevin
-- Source: https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/lsp/lsp-installer.lua
-- Last Modified: 15/12/21 - 12:20
-------------------------------------

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end


-- Local variables {
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
	local lspconfig = require('lspconfig')
	local luasnip = require('luasnip')
	local lsp_installer = require('nvim-lsp-installer')
-- Local variables }

-- Servers {
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
	--for _, srv in pairs(servers) do
	--	lspconfig[srv].setup {
	--			capabilities = capabilities
	--	}
	--end
-- Set capabilities }


lsp_installer.settings {
	install_root_dir = "/Users/Kevin/.local/share/nvim/lsp_servers/",
	ui = {
		server_installed = "✓",
		server_pending = "↓",
		server_uninstalled = "✗"
	},
}


lsp_installer.on_server_ready(function(server)
	local default_opts = {
    on_attach = on_attach,
	}

	require("lspconfig")[server.name].setup {
		capabilities = capabilities
	}

	local server_opts = {
    ["jdtls"] = function ()
      default_opts,settings = {
        init_options = {
          workspace = vim.fn.expand("~/.local/java/workspace/")
        }
      }
    end,
  }

	local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
  server:setup(server_options)
end)
