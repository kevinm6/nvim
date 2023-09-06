-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 24 Sep 2023, 12:12
-------------------------------------

--- Set buffer keymaps based on supported capabilities of the
--- passed client and buffer id
--- @param client any client passed to attach config
local set_buf_keymaps = function(client, _)
   if client.name == "jdtls" then
      client.server_capabilities.documentHighlightProvider = false
      return
   end

   local has_telescope, tele_builtin = pcall(require, "telescope.builtin")

   -- local opts = { noremap = true, silent = true }
   vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float()
   end, { buffer = true, desc = "Open float" })

   vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
         vim.lsp.buf.hover()
      end
   end, { desc = "Hover | PeekFold", buffer = true })

   if client.server_capabilities.declarationProvider then
      vim.keymap.set("n", "gD", function()
         if has_telescope then
            tele_builtin.lsp_declarations()
         else
            vim.lsp.buf.declaration()
         end
      end, { buffer = true, desc = "GoTo declaration" })
   end
   if client.server_capabilities.definitionProvider then
      vim.keymap.set("n", "gd", function()
         if has_telescope then
            tele_builtin.lsp_definitions()
         else
            vim.lsp.buf.definition()
         end
      end, { buffer = true, desc = "GoTo definition" })
   end
   if client.server_capabilities.implementationProvider then
      vim.keymap.set("n", "gI", function()
         if has_telescope then
            tele_builtin.lsp_incoming_calls {}
         else
            vim.lsp.buf.implementation()
         end
      end, { buffer = true, desc = "GoTo implementation" })
   end
   if client.server_capabilities.referencesProvider then
      vim.keymap.set("n", "gr", function()
         if has_telescope then
            tele_builtin.lsp_references {}
         else
            vim.lsp.buf.references()
         end
      end, { buffer = true, desc = "GoTo references" })
   end

   vim.keymap.set("n", "<leader>ll", function()
      vim.lsp.codelens.run()
   end, { buffer = true, desc = "CodeLens Action" })
   vim.keymap.set("n", "<leader>la", function()
      vim.lsp.buf.code_action()
   end, { buffer = true, desc = "Code Action" })
   vim.keymap.set("n", "<leader>lI", function()
      vim.cmd.LspInfo {}
   end, { buffer = true, desc = "Lsp Info" })
   vim.keymap.set("n", "<leader>lL", function()
      vim.cmd.LspLog {}
   end, { buffer = true, desc = "Lsp Log" })
   vim.keymap.set("n", "<leader>r", function()
      vim.lsp.buf.rename()
   end, { buffer = true, desc = "Rename" })
   vim.keymap.set("n", "<leader>lq", function()
      vim.diagnostic.setloclist()
   end, { buffer = true, desc = "Lsp trueDiagnostics" })
   -- Diagnostics
   vim.keymap.set("n", "<leader>dj", function()
      vim.diagnostic.goto_next { buffer = true }
   end, { desc = "Next Diagnostic" })
   vim.keymap.set("n", "<leader>dk", function()
      vim.diagnostic.goto_prev { buffer = true }
   end, { desc = "Prev Diagnostic" })
end

--- Set buffer capabilities based if supported by the
--- passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr any|integer buffer id passed to attach config
local set_buf_capabilities = function(client, bufnr)
   -- TODO: remove check for nvim_v0.10 after update
   if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint(bufnr, true)
   end

   -- lsp-document_highlight
   if client.server_capabilities.documentHighlightProvider and
      client.supports_method "textDocument/documentHighlight" then
      local lsp_document_highlight =
      vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = false })
      vim.api.nvim_clear_autocmds {
         buffer = bufnr,
         group = lsp_document_highlight,
      }
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
         group = lsp_document_highlight,
         buffer = bufnr,
         callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
         group = lsp_document_highlight,
         buffer = bufnr,
         callback = vim.lsp.buf.clear_references,
      })
   end

   if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
   end

   -- Formatting
   if client.server_capabilities.documentFormattingProvider then
      local user_lib_format = require "user_lib.format"
      vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
         user_lib_format.toggle_format_on_save()
      end, {})

      vim.api.nvim_create_user_command("Format", function()
         user_lib_format.lsp_format(bufnr)
      end, { force = true })

      vim.keymap.set("n", "<leader>lf", function()
         user_lib_format.lsp_format(bufnr)
      end, { desc = "Format" })
      vim.keymap.set("n", "<leader>lF", function()
         vim.cmd.LspToggleAutoFormat()
      end, { desc = "Toggle AutoFormat" })
   end

   if client.server_capabilities.documentRangeFormattingProvider then
      vim.keymap.set("v", "<leader>lf", function()
         require("user_lib.functions").range_format()
      end, { desc = "Range format" })
   end
end

-- Custom configs to apply when starting lsp
--- @param client any client passed to attach config
local custom_init = function(client)
   client.config.flags = client.config.flags or {}
   client.config.flags.allow_incremental_sync = true
end

--- Custom configs to apply when attaching lsp to buffer
--- @param client any client passed to attach config
--- @param bufnr any|integer buffer id passed to attach config
local custom_attach = function(client, bufnr)
   require("plugins.lsp.handlers").setup()
   require("plugins.lsp.codelens").setup_codelens_refresh(client, bufnr)

   set_buf_keymaps(client, bufnr)
   set_buf_capabilities(client, bufnr)
end

local M = {
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
      keys = {
         { "<leader>l", nil, desc = "LSP" },
      },
      config = function(_, _)
         local lspconfig = require "lspconfig"
         local lsputil = require "lspconfig.util"

         -- Update capabilities with extended
         local ext_capabilities = nil
         local has_cmp, cmp_nvim_lsp =  pcall(require, "cmp_nvim_lsp")
         if not has_cmp then
            ext_capabilities = vim.lsp.protocol.make_client_capabilities()
         else
            ext_capabilities = cmp_nvim_lsp.default_capabilities()
         end

         ext_capabilities.textDocument.completion.completionItem.snippetSupport = true

         -- HACK: this is to avoid errors on lsp that support only single encoding (ex: clangd)
         --       maybe is resolved with this change on nvim_v0.10
         -- `https://github.com/neovim/neovim/commit/ca26ec34386dfe98b0edf3de9aeb7b66f40d5efd`
         -- ext_capabilities.offsetEncoding = "utf-8"

         local default_lsp_config = {
            on_init = custom_init,
            on_attach = custom_attach,
            capabilities = ext_capabilities,
            flags = { debounce_text_changes = 150 },
         }

         require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            --- @param server_name string name of the server of which handler is being set
            function(server_name)
               if server_name ~= "jdtls" then
                  lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
               end
            end,

            -- Next, you can provide targeted overrides for specific servers.
            -- Manage server with custom setup
            ["lua_ls"] = function()
               require "neodev".setup()

               local runtime_path = vim.split(package.path, ";")
               table.insert(runtime_path, "lua/?.lua")
               table.insert(runtime_path, "lua/?/init.lua")

               lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  settings = {
                     Lua = {
                        runtime = {
                           path = runtime_path,
                        },
                        diagnostics = {
                           enable = true,
                           globals = { "vim", "pcall", "format" },
                           disable = { "lowercase-global" },
                        },
                        completion = {
                           enable = true,
                           autoRequire = true,
                           keywordSnippet = "Both",
                           callSnippet = "Both",
                           displayContext = 2,
                        },
                        workspace = {
                           library = {
                              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                              [vim.fn.stdpath "config" .. "/lua"] = true,
                           },
                           checkThirdParty = false,
                       },
                        hint = { enable = true },
                     },
                  },
               }))
            end,
            ["jsonls"] = function()
               lspconfig.jsonls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  settings = {
                     json = {
                        schemas = require("schemastore").json.schemas() or nil,
                     },
                  },
                  setup = {
                     commands = {
                        Format = {
                           function()
                              vim.lsp.buf.range_formatting(
                                 {},
                                 { 0, 0 },
                                 { vim.fn.line "$", 0 }
                              )
                           end,
                        },
                     },
                  },
               }))
            end,
            ["sqlls"] = function()
               local databases_path =
               vim.fn.expand "~/Informatica/Anno2/Semestre1/Basi di Dati"
               lspconfig.sqlls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  settings = {
                     sqls = {
                        workspace = {
                           connections = {
                              {
                                 driver = "postgresql",
                                 dbName = "postgres",
                                 proto = "tcp",
                                 user = "Kevin",
                                 port = 5432,
                                 passwd = "",
                                 host = "localhost",
                                 path = databases_path,
                              },
                              {
                                 driver = "postgresql",
                                 dbName = "imdb",
                                 proto = "tcp",
                                 user = "Kevin",
                                 port = 5432,
                                 passwd = "",
                                 host = "localhost",
                                 path = databases_path,
                              },
                              {
                                 driver = "postgresql",
                                 dbName = "lezione",
                                 proto = "tcp",
                                 user = "Kevin",
                                 port = 5432,
                                 passwd = "",
                                 host = "localhost",
                                 path = databases_path,
                              },
                              {
                                 driver = "postgresql",
                                 dbName = "freshrss",
                                 proto = "tcp",
                                 user = "Kevin",
                                 port = 5432,
                                 passwd = "",
                                 host = "localhost",
                                 path = databases_path,
                              },
                           },
                        },
                     },
                  },
               }))
            end,
            ["grammarly"] = function()
               lspconfig.grammarly.setup(
                  vim.tbl_deep_extend("force", default_lsp_config, {
                     filetypes = { "markdown", "text" },
                     autostart = false,
                  })
               )
            end,
            ["clangd"] = function()
               lspconfig.clangd.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  cmd = {
                     "clangd",
                     "--background-index",
                     "--suggest-missing-includes",
                     "--clang-tidy",
                     "--header-insertion=iwyu",
                  },
                  init_options = {
                     clangdFileStatus = true,
                  },
                  offsetEncoding = "utf-8",
                  inlayHints = {
                     enabled = true,
                     parameterNames = true,
                     deducedTypes = true,
                  },
               }))
            end,
            ["gopls"] = function()
               lspconfig.gopls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  root_dir = function(fname)
                     local Path = require "plenary.path"

                     local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
                     local absolute_fname = Path:new(fname):absolute()

                     if
                        string.find(absolute_cwd, "/cmd/", 1, true)
                        and string.find(absolute_fname, absolute_cwd, 1, true)
                     then
                        return absolute_cwd
                     end

                     return lsputil.root_pattern("go.mod", "go.work", ".git")(fname)
                  end,
                  settings = {
                     gopls = {
                        codelenses = {
                           test = true,
                           gc_details = false,
                           generate = true,
                           regenerate_cgo = true,
                           tidy = true,
                           upgrade_dependency = true,
                           vendor = true,
                        },
                        analyses = {
                           unusedparams = true,
                        },
                        staticcheck = true,
                        -- hints = {
                        --   assignVariableTypes = true,
                        --   compositeLiteralFields = true,
                        --   compositeLiteralTypes = true,
                        --   constantValues = true,
                        --   functionTypeParameters = true,
                        --   parameterNames = true,
                        --   rangeVariableTypes = true,
                        -- }
                     },
                  },
                  flags = {
                     debounce_text_changes = 200,
                  },
               }))
            end,
            ["tsserver"] = function()
               lspconfig.tsserver.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  root_dir = lsputil.root_pattern(
                     "tsconfig.json",
                     "package.json",
                     "jsconfig.json",
                     ".git"
                  ) or vim.loop.cwd(),
                  init_options = {
                      preferences = {
                        includeCompletionsWithSnippetText = true,
                        includeCompletionsForImportStatements = true,
                      }
                  }
               }))
            end,
            ["bashls"] = function()
               lspconfig.bashls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  cmd = { "bash-language-server", "start" },
                  filetypes = { "sh", "bash", "zsh" },
                  allowList = { "sh", "bash", "zsh" },
                  settings = {
                     allowList = { "sh", "bash", "zsh" },
                  },
                  on_attach = function(client, _)
                     client.server_capabilities.documentHighlightProvider = false
                  end,
               }))
            end,
            ["erlangls"] = function()
               lspconfig.erlangls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
                  docs = {
                     description = [[
                         https://github.com/erlang-ls/erlang_ls
                         ]],
                  },
                  root_dir = lsputil.root_pattern("rebar.config", "erlang.mk", ".git")
                     or vim.loop.cwd(),
               }))
            end,
         }

         -- sourcekit is still not available on mason-lspconfig
         lspconfig.sourcekit.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            cmd = { "/usr/bin/xcrun", "sourcekit-lsp" },
            filetypes = { "swift" },
            root_dir = lsputil.root_pattern("Package.swift", ".git"),
         }))
      end,
   },

   {
      "williamboman/mason.nvim",
      cmd = "Mason",
      keys = {
         { "<leader>C", nil, desc = "Packages" },
         { "<leader>Cm", vim.cmd.Mason, desc = "Mason" },
      },
      --- @param o table options passed to config
      opts = function(_, o)
         local icons = require "user_lib.icons"

         o.install_root_dir = vim.fn.stdpath "data" .. "/mason"

         o.ui = {
            border = "rounded",
            width = 0.7,
            height = 0.7,
            icons = {
               package_installed = icons.package_manager.done_sym,
               package_pending = icons.package_manager.working_sym,
               package_uninstalled = icons.package_manager.removed_sym,
            },
            keymaps = {
               -- Keymap to uninstall a server
               uninstall_package = "D",
            },
         }
         o.registries = {
            "github:mason-org/mason-registry",
         }
      end,
   },

   {
      "williamboman/mason-lspconfig.nvim",
      --- @param o table options passed to config
      opts = function(_, o)
         local icons = require "user_lib.icons"

         o.ensure_installed = {
            "lua_ls",
            "vimls",
            "tsserver",
            "sqlls",
            "pyright",
            "jsonls",
            "gopls",
            "yamlls",
            "html",
            "bashls",
            "clangd",
            "rust_analyzer",
            "intelephense",
            "ocamllsp",
            "erlangls",
            "dockerls",
         }
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
         }
         o.pip = { install_args = {} }
         o.log_level = vim.log.levels.INFO
         o.max_concurrent_installers = 2
      end,
   },

   {
      "mfussenegger/nvim-lint",
      event = "InsertEnter",
      config = function()
         local lint = require "lint"
         lint.linters_by_ft = {
            markdown = { "markdownlint" },
            json = { "jsonlint" },
            javascript = {
               "eslint_d"
            },
            typescript = {
               "eslint_d"
            },
            python = { "flake8" },
            gitcommit = { "commitlint" },
            php = { "php" },
            yaml = { "yamllint" },
         }

         vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
               if lint then
                  lint.try_lint()
               end
            end,
         })
      end

   },

   -- TODO: to be removed later
   {
      "jose-elias-alvarez/null-ls.nvim",
      event = "LspAttach",
      dependencies = { "nvim-lua/plenary.nvim" },
      --- @param o table options passed to config
      opts = function(_, o)
         local null_ls = require "null-ls"

         o.debounce = 150
         o.save_after_format = false
         o.debug = false
         o.on_attach = o.on_attach
         o.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git")

         o.sources = {
            null_ls.builtins.formatting.prettier.with {
               extra_filetypes = { "toml", "solidity" },
               extra_args = function(params)
                  return params.options
                     and {
                        "--no-semi",
                        "--single-quote",
                     }
                     and params.options.tabSize
                     and { "--tab-width", params.options.tabSize }
               end,
            },
            null_ls.builtins.formatting.black.with {
               extra_args = function(params)
                  return params.options
                     and { "--fast" }
                     and params.options.tabSize
                     and { "--tab-width", params.options.tabSize }
               end,
            },
            null_ls.builtins.formatting.stylua.with {
               extra_args = function(params)
                  return params.options
                     and params.options.tabSize
                     and { "--indent-width", params.options.tabSize }
               end,
            },
            null_ls.builtins.formatting.google_java_format.with {
               extra_args = function(params)
                  return params.options
                     and params.options.tabSize
                     and { "--tab-width", params.options.tabSize }
               end,
            },

            null_ls.builtins.formatting.yamlfmt.with {
               extra_args = function(params)
                  return params.options
                     and params.options.tabSize
                     and { "--tab-width", params.options.tabSize }
               end,
            },

            null_ls.builtins.code_actions.gitsigns.with {
               config = {
                  filter_actions = function(title)
                     return title:lower():match "blame" == nil
                  end,
               },
            },
            null_ls.builtins.code_actions.gitrebase,
            null_ls.builtins.code_actions.refactoring,

            null_ls.builtins.completion.luasnip,
            null_ls.builtins.completion.tags,

            null_ls.builtins.diagnostics.zsh,

            null_ls.builtins.hover.dictionary,
            null_ls.builtins.hover.printenv,
         }
      end,
   },
}

return M
