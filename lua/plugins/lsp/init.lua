-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 28 May 2023, 13:46
-------------------------------------

local icons = require "user_lib.icons"

local M = {
   "neovim/nvim-lspconfig",
   event = { "BufReadPre", "BufNewFile" },
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
               "lua_ls",
               "vimls",
               "tsserver",
               "sqlls",
               "pyright",
               "jsonls",
               "gopls",
               "yamlls",
               "html",
               "asm_lsp",
               "bashls",
               "clangd",
               "rust_analyzer",
               "intelephense",
               "ocamllsp",
               "erlangls",
               "dockerls",
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
            o.pip = { install_args = {} }
            o.log_level = vim.log.levels.INFO
            o.max_concurrent_installers = 2
         end,
      },
      {
         "hrsh7th/cmp-nvim-lsp",
         cond = function()
            return require("lazy.core.config").plugins["nvim-cmp"] ~= nil
         end,
      },
      "jose-elias-alvarez/null-ls.nvim",
      -- "SmiteshP/nvim-navic",
   },
}

local set_buf_keymaps = function(client, bufnr)
   if client.name == "jdtls" then
      return
   end

   local has_telescope, telescope = pcall(require, "telescope.builtin")

   -- local opts = { noremap = true, silent = true }
   vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float()
   end, { buffer = bufnr, desc = "Open float" })
   vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
   end, { buffer = bufnr })

   if client.server_capabilities.declarationProvider then
      vim.keymap.set("n", "gD", function()
         if has_telescope then
            telescope.lsp_declarations {}
         else
            vim.lsp.buf.declaration()
         end
      end, { buffer = bufnr, desc = "GoTo declaration" })
   end
   if client.server_capabilities.definitionProvider then
      vim.keymap.set("n", "gd", function()
         if has_telescope then
            telescope.lsp_definitions {}
         else
            vim.lsp.buf.definition()
         end
      end, { buffer = bufnr, desc = "GoTo definition" })
   end
   if client.server_capabilities.implementationProvider then
      vim.keymap.set("n", "gI", function()
         if has_telescope then
            telescope.lsp_incoming_calls {}
         else
            vim.lsp.buf.implementation()
         end
      end, { buffer = bufnr, desc = "GoTo implementation" })
   end
   if client.server_capabilities.referencesProvider then
      vim.keymap.set("n", "gr", function()
         if has_telescope then
            telescope.lsp_references {}
         else
            vim.lsp.buf.references()
         end
      end, { buffer = bufnr, desc = "GoTo references" })
   end

   vim.keymap.set("n", "<leader>ll", function()
      vim.lsp.codelens.run()
   end, { buffer = bufnr, desc = "CodeLens Action" })
   vim.keymap.set("n", "<leader>la", function()
      vim.lsp.buf.code_action()
   end, { buffer = bufnr, desc = "Code Action" })
   vim.keymap.set("n", "<leader>lI", function()
      vim.cmd.LspInfo {}
   end, { buffer = bufnr, desc = "Lsp Info" })
   vim.keymap.set("n", "<leader>lL", function()
      vim.cmd.LspLog {}
   end, { buffer = bufnr, desc = "Lsp Log" })
   vim.keymap.set("n", "<leader>r", function()
      vim.lsp.buf.rename()
   end, { buffer = bufnr, desc = "Rename" })
   vim.keymap.set("n", "<leader>lq", function()
      vim.diagnostic.setloclist()
   end, { buffer = bufnr, desc = "Lsp Diagnostics" })
   -- Diagnostics
   vim.keymap.set("n", "<leader>dj", function()
      vim.diagnostic.goto_next { buffer = bufnr }
   end, { desc = "Next Diagnostic" })
   vim.keymap.set("n", "<leader>dk", function()
      vim.diagnostic.goto_prev { buffer = bufnr }
   end, { desc = "Prev Diagnostic" })
end

local set_buf_capabilities = function(client, bufnr)
   -- lsp-document_highlight
   if client.server_capabilities.documentHighlightProvider then
      local lsp_hi_doc_group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
         group = lsp_hi_doc_group,
         buffer = bufnr, -- passing buffer instead of pattern to prevent errors on switching bufs
         callback = function()
            vim.lsp.buf.document_highlight()
         end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" }, {
         group = lsp_hi_doc_group,
         buffer = bufnr, -- passing buffer instead of pattern to prevent errors on switching bufs
         callback = function()
            vim.lsp.buf.clear_references()
         end,
      })
      -- TODO: must be implemented better
      -- else -- fallback w/ treesitter
      --    local lsp_hi_doc_group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true })
      --    autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
      --      group = lsp_hi_doc_group,
      --      buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
      --      callback = function()
      --          require "user_lib.functions".ts_fallback_lsp_highlighting(args.buf)
      --      end
      --    })
      --    autocmd({ "BufEnter", "CursorMoved" }, {
      --      group = lsp_hi_doc_group,
      --      buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
      --      callback = function() vim.lsp.buf.clear_references() end
      --    })
   end

   if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
   end

   -- Formatting
   if client.supports_method "textDocument/formatting" then
      local user_lib_funcs = require "user_lib.functions"
      vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
         if vim.fn.exists "#_format_on_save#BufWritePre" == 0 then
            user_lib_funcs.format_on_save(bufnr, true)
         else
            user_lib_funcs.format_on_save(bufnr)
         end
      end, {})

      vim.api.nvim_create_user_command("Format", function()
         vim.lsp.buf.format()
      end, { force = true })

      vim.keymap.set("n", "<leader>lf", function()
         user_lib_funcs.lsp_format(bufnr)
      end, { desc = "Format" })
      vim.keymap.set("n", "<leader>lF", function()
         vim.cmd.LspToggleAutoFormat()
      end, { desc = "Toggle AutoFormat" })
   end
end

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
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- require "inlay-hints".on_attach(client, bufnr)
      require("plugins.lsp.handlers").setup()
      require("plugins.lsp.codelens").setup_codelens_refresh(client, bufnr)

      set_buf_keymaps(client, bufnr)
      set_buf_capabilities(client, bufnr)
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
         lspconfig.asm_lsp.setup(
            vim.tbl_deep_extend("force", default_lsp_config, { root_dir = require("lspconfig.util").find_git_ancestor })
         )
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
      ["tsserver"] = function()
         lspconfig.tsserver.setup(
            vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.tsserver")
         )
      end,
      ["erlangls"] = function()
         lspconfig.erlangls.setup(
            vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.erlangls")
         )
      end,
   }

   -- sourcekit is still not available on mason-lspconfig
   lspconfig.sourcekit.setup(vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.sourcekit"))

   require("plugins.lsp.null-ls").init(default_lsp_config)
end

return M
