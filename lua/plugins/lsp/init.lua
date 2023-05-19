-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 20 May 2023, 12:30
-------------------------------------

local icons = require "util.icons"

local M = {
   "neovim/nvim-lspconfig",
   event = "BufReadPre",
   cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
   dependencies = {
      {
         "williamboman/mason.nvim",
         cmd = "Mason",
         event = "BufReadPre",
         keys = {
            { "<leader>Cm", vim.cmd.Mason, desc = "Mason" },
         },
         opts = function(_, o)
            o.install_root_dir = vim.fn.stdpath "data" .. "/mason"
            o.PATH = "append"

            o.ui = {
               border = "rounded",
               width = 0.7,
               height = 0.7,
               icons = {
                  -- The list icon to use for installed servers.
                  package_installed = icons.package_manager.done_sym,
                  -- The list icon to use for servers that are pending installation.
                  package_pending = icons.package_manager.working_sym,
                  -- The list icon to use for servers that are not installed.
                  package_uninstalled = icons.package_manager.removed_sym,
               },
               keymaps = {
                  -- Keymap to expand a server in the UI
                  toggle_package_expand = "<CR>",
                  -- Keymap to install the server under the current cursor position
                  install_package = "i",
                  -- Keymap to reinstall/update the server under the current cursor position
                  update_server = "u",
                  -- Keymap to check for new version for the server under the current cursor position
                  check_package_version = "c",
                  -- Keymap to update all installed servers
                  update_all_packages = "U",
                  -- Keymap to check which installed servers are outdated
                  check_outdated_packages = "C",
                  -- Keymap to uninstall a server
                  uninstall_package = "D",
                  -- Keymap to cancel a package installation
                  cancel_installation = "<C-c>",
                  -- Keymap to apply language filter
                  apply_language_filter = "<C-f>",
               },
            }
            o.pip = {
               upgrade_pip = false,
               install_args = {},
            }
            o.max_concurrent_installers = 4
            o.registries = {
               "lua:mason-registry.index",
               "github:mason-org/mason-registry",
            }
            o.providers = {
               "mason.providers.registry-api",
               "mason.providers.client",
            }
            o.github = {
               -- The template URL to use when downloading assets from GitHub.
               -- The placeholders are the following (in order):
               -- 1. The repository (e.g. "rust-lang/rust-analyzer")
               -- 2. The release version (e.g. "v0.3.0")
               -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
               download_url_template = "https://github.com/%s/releases/download/%s/%s",
            }
            o.log_level = vim.log.levels.INFO
         end,
      },
      {
         "williamboman/mason-lspconfig.nvim",
         opts = function(_, o)
            local servers_to_install = {
               "lua_ls", "vimls", "tsserver", "sqlls",
               "pyright", "jsonls", "gopls", "yamlls",
               "html", "asm_lsp", "bashls", "clangd",
               "intelephense", "ocamllsp", "erlangls", "dockerls",
            }
            o.ensure_installed = servers_to_install
            o.automatic_installation = {}
            o.ui = {
               border = "rounded",
               icons = {
                  -- The list icon to use for installed servers.
                  server_installed = icons.package_manager.done_sym,
                  -- The list icon to use for servers that are pending installation.
                  server_pending = icons.package_manager.working_sym,
                  -- The list icon to use for servers that are not installed.
                  server_uninstalled = icons.package_manager.removed_sym,
               },
               keymaps = {
                  toggle_server_expand = "<CR>", -- Keymap to expand a server in the UI
                  install_server = "i", -- Keymap to install the server under the current cursor position
                  update_server = "u", -- Keymap to reinstall/update the server under the current cursor position
                  check_server_version = "c", -- Keymap to check for new version for the server under the current cursor position
                  update_all_servers = "U", -- Keymap to update all installed servers
                  check_outdated_servers = "C", -- Keymap to check which installed servers are outdated
                  uninstall_server = "X", -- Keymap to uninstall a server
               },
            }
            o.pip = { install_args = {}, }
            o.log_level = vim.log.levels.INFO
            o.max_concurrent_installers = 2
         end
      },
      {
         "hrsh7th/cmp-nvim-lsp",
         cond = function()
            return require "lazy.core.config".plugins["nvim-cmp"] ~= nil
         end
      },
      "jose-elias-alvarez/null-ls.nvim",
      -- "SmiteshP/nvim-navic",
   },
}

function M.config()
   local lspconfig = require "lspconfig"

   -- Update capabilities with extended
   local ext_capabilities = vim.lsp.protocol.make_client_capabilities()
   ext_capabilities = require("cmp_nvim_lsp").default_capabilities(ext_capabilities)
   ext_capabilities.textDocument.completion.completionItem.snippetSupport = true

   -- HACK: this is to avoid errors on lsp that support only single encoding (ex: clangd)
   ext_capabilities.offsetEncoding = "utf-8"

   -- Custom configs to apply when starting lsp
   local custom_init = function(client)
      client.config.flags = client.config.flags or {}
      client.config.flags.allow_incremental_sync = true
   end

   -- Custom configs to apply when attaching lsp to buffer
   local custom_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      if client.server_capabilities.documentSymbolProvider then
         require("nvim-navic").attach(client, bufnr)
      end

      -- require "inlay-hints".on_attach(client, bufnr)
      require "plugins.lsp.handlers".setup()
      require "plugins.lsp.codelens".setup_codelens_refresh(client, bufnr)
   end

   local default_lsp_config = {
      on_init = custom_init,
      on_attach = custom_attach,
      capabilities = ext_capabilities,
      flags = { debounce_text_changes = 150 },
   }

   -- Manage handlers w/ Mason-lspconfig
   require("mason-lspconfig").setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name)
         if server_name ~= "jdtls" then
            lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
         end
      end,

      -- Next, you can provide targeted overrides for specific servers.
      -- Manage server with custom setup
      ["asm_lsp"] = function()
         lspconfig.asm_lsp.setup(vim.tbl_deep_extend("force", default_lsp_config, { root_dir = require "lspconfig.util".find_git_ancestor }))
      end,
      ["lua_ls"] = function()
         lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.lua_ls"))
      end,
      ["jsonls"] = function()
         lspconfig.jsonls.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.jsonls"))
      end,
      ["sqlls"] = function()
         lspconfig.sqlls.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.sqlls"))
      end,
      ["grammarly"] = function()
         lspconfig.grammarly.setup(vim.tbl_deep_extend("force", default_lsp_config, { autostart = false }))
      end,
      ["clangd"] = function()
         lspconfig.clangd.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.clangd"))
      end,
      ["gopls"] = function()
         lspconfig.gopls.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.gopls"))
      end,
      ["tsserver"] = function() lspconfig.tsserver.setup(vim.tbl_deep_extend("force", default_lsp_config,
        require "plugins.lsp.configs.tsserver"))
      end,
   }

   -- sourcekit is still not available on mason-lspconfig
   lspconfig.sourcekit.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.sourcekit"))

   require("plugins.lsp.null-ls").init(default_lsp_config)
end

return M
