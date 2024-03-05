-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 26 Feb 2024, 21:31
-------------------------------------

---Auto Stop LSP client if no more buffers attached.
--@param client table client attached to buffer
--@param bufnr number buffer id of which client is attached
-- local set_auto_stop_lsp = function(client, bufnr)
--   if (vim.fn.has "nvim-0.10" ~= 1) then return end

--   vim.api.nvim_create_autocmd("BufDelete", {
--     group = vim.api.nvim_create_augroup("_lsp_timeout", { clear = false }),
--     buffer = bufnr,
--     callback = function(ev)
--       local clients = vim.lsp.get_clients({ name = client.name, bufnr = bufnr })[1] or
--       vim.lsp.get_clients({ name = client.name })[1]
--       local attached_bufs = clients.attached_buffers
--       local n_bufs = 0
--       for _, _ in pairs(attached_bufs) do
--         n_bufs = n_bufs + 1
--       end

--       if n_bufs == 1 and attached_bufs[ev.buf] or n_bufs == 0 then
--         vim.defer_fn(function()
--           vim.lsp.stop_client(clients.id)

--           vim.notify("No more clients attached. Stopped.",
--             vim.log.levels.INFO, {
--               title = "LSP: " .. clients.name,
--             }
--           )
--         end, 6000)
--       end
--     end
--   })
-- end


--- Set buffer keymaps based on supported capabilities of the
--- passed client and buffer id
--- @param client any client passed to attach config
local set_buf_keymaps = function(client, bufnr)
  if client.name == "jdtls" then
    client.server_capabilities.documentHighlightProvider = false
  end

  local has_telescope, tele_builtin = pcall(require, "telescope.builtin")

  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = "[L]SP: "..desc })
  end

  -- local opts = { noremap = true, silent = true }
  map("gl", function() vim.diagnostic.open_float() end, "Open float")

  map("K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, "Hover | PeekFold" )

  if client.server_capabilities.declarationProvider then
    map("gD", function()
      if has_telescope then
        tele_builtin.lsp_definitions()
      else
        vim.lsp.buf.declaration()
      end
    end, "[G]oTo [D]eclaration")
  end
  if client.server_capabilities.definitionProvider then
    map("gd", function()
      if has_telescope then
        tele_builtin.lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end, "[G]oTo [D]efinitions")

    map("<leader>ld", function()
      if has_telescope then
        tele_builtin.lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end, "[G]oTo [D]efinitions")
  end
  if client.server_capabilities.implementationProvider then
    map("gI", function()
      if has_telescope then
        tele_builtin.lsp_incoming_calls()
      else
        vim.lsp.buf.implementation()
      end
    end, "[I]ncoming-Calls")
  end
  if client.supports_method "callHierarchy/outgoingCalls" then
    map("gC", function()
      if has_telescope then
        tele_builtin.lsp_outgoing_calls()
      else
        vim.lsp.buf.outgoing_calls()
      end
    end, "Outgoing-[C]alls")
  end
  if client.server_capabilities.referencesProvider then
    map("gr", function()
      if has_telescope then
        tele_builtin.lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, "[G]oTo [R]eferences")
    map("<leader>lr", function()
      if has_telescope then
        tele_builtin.lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, "[G]oTo [R]eferences")
  end

  map("gs", function()
    if has_telescope then
      tele_builtin.lsp_document_symbols()
    else
      vim.lsp.buf.document_symbol()
    end
  end, "LSP Symbols" )

  map("<leader>ls", function()
    if has_telescope then
      tele_builtin.lsp_document_symbols()
    else
      vim.lsp.buf.document_symbol()
    end
  end, "[S]ymbols")

  map("<leader>lt", function()
    if has_telescope then
      tele_builtin.lsp_typedefs()
    else
      vim.lsp.buf.type_definition()
    end
  end, "[T]ypeDef")

  map("<leader>lws", function()
    if has_telescope then
      tele_builtin.lsp_workspace_symbols()
    else
      vim.lsp.buf.workspace_symbol()
    end
  end, "[W]orkspace [S]ymbols")

  map("<leader>ll", function() vim.lsp.codelens.run() end, "CodeLens Action")
  map("<leader>la", function() vim.lsp.buf.code_action() end, "Code [A]ction")
  map("<leader>lI", function() vim.cmd.LspInfo {} end, "[I]nfo")
  map("<leader>lL", function() vim.cmd.LspLog {} end, "[L]og")
  map("<leader>r", function() vim.lsp.buf.rename() end, "[R]ename")
  map("<leader>lq", function() vim.diagnostic.setloclist() end, "[Q]FDiagnostics")
  -- Diagnostics
  map("]d", function() vim.diagnostic.goto_next { buffer = true } end, "Next [D]iagnostic")
  map("[d", function() vim.diagnostic.goto_prev { buffer = true } end, "Prev [D]iagnostic")
  map("<leader>dj", function() vim.diagnostic.goto_next { buffer = true } end, "Next Diagnostic")
  map("<leader>dk", function() vim.diagnostic.goto_prev { buffer = true } end, "Prev Diagnostic")
end

--- Set buffer capabilities based if supported by the
--- passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr any|integer buffer id passed to attach config
local set_buf_funcs_for_capabilities = function(client, bufnr)
  local map = vim.keymap.set

  if client.supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
  -- TODO: remove check for nvim_v0.10 after update
  if vim.lsp.inlay_hint then
    vim.api.nvim_create_user_command("InlayHints", function()
      if vim.lsp.inlay_hint.is_enabled(bufnr) then
        vim.lsp.inlay_hint.enable(bufnr, false)
      else
        vim.lsp.inlay_hint.enable(bufnr, true)
      end
    end, { desc = "Toggle Inlay hints" })
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
    local lib_format = require "lib.format"
    vim.api.nvim_create_user_command("LspAutoFormat", function()
      lib_format.toggle_format_on_save()
    end, {})

    vim.api.nvim_create_user_command("Format", function()
      lib_format.lsp_format(bufnr)
    end, { force = true })

    map("n", "<leader>lf", function()
      lib_format.lsp_format(bufnr)
    end, { desc = "Format", buffer = true })
    map("n", "<leader>lF", function()
      vim.cmd.LspToggleAutoFormat()
    end, { desc = "Toggle AutoFormat", buffer = true })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    map("v", "<leader>lf", function()
      require("lib_format").lsp_format(bufnr)
    end, { desc = "Range format", buffer = true })
  end

  vim.api.nvim_create_user_command("LspCapabilities", function()
    require("lib.utils").get_current_buf_lsp_capabilities()
  end, {})
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
  require("plugins.lsp.codelens").setup_codelens_refresh(client, bufnr)
  require("plugins.lsp.handlers").setup()

  set_buf_keymaps(client, bufnr)
  set_buf_funcs_for_capabilities(client, bufnr)
  -- set_auto_stop_lsp(client, bufnr)
end

local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
    keys = {
      { "<leader>l", nil, desc = "LSP" },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local lsputil = require "lspconfig.util"

      require('lspconfig.ui.windows').default_options.border = 'rounded'

      -- Update capabilities with extended from cmp_nvim_lsp
      local ext_capabilities = nil
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not has_cmp then
        ext_capabilities = vim.lsp.protocol.make_client_capabilities()
      else
        ext_capabilities = cmp_nvim_lsp.default_capabilities()
      end

      ext_capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- ext_capabilities.textDocument.completion.completionItem.resolveSupport = {
      --   properties = {
      --     "documentation",
      --     "detail",
      --     "additionalTextEdits"
      --   }
      -- }

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
          else
            return
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
                  globals = { "vim", "format", "pandoc", "quarto" },
                  disable = {},
                },
                -- completion = {
                --    enable = true,
                --    autoRequire = true,
                --    keywordSnippet = "Both",
                --    callSnippet = "Both",
                --    displayContext = 2,
                -- },
                workspace = {
                  library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                  },
                  checkThirdParty = false,
                },
                hint = {
                  enable = true,
                  arrayIndex = "Auto",
                  await = true,
                  paramName = "Disable",
                  paramType = false,
                  semicolon = "SameLine",
                  setType = false
                },
                telemetry = { enable = false }
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
        ["yamlls"] = function()
          lspconfig.yamlls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            settings = {
              yaml = {
                schemaDownload = { enable = true },
                validate = true,
              }
            }
          }))
        end,

        ["sqls"] = function()
          lspconfig.sqls.setup(
            vim.tbl_deep_extend("force", default_lsp_config, {
              on_attach = function(client, bufnr)
                custom_attach(client, bufnr)
                require "sqls".on_attach(client, bufnr)
              end,
              -- on_new_config = function (new_config, new_root_dir)
              --   local default_config_yml = vim.env['XDG_CONFIG_HOME'].."/sqls/config.yml"
              --   local cwd_workspace_yml = vim.uv.cwd().."/config.yml"
              --   local yml_to_load = default_config_yml

              --   if lsputil.path.is_file(cwd_workspace_yml) then
              --     yml_to_load = cwd_workspace_yml
              --   end
              --   return { "sqls", "-config", yml_to_load }
              -- end
          })
          )
        end,
        ["marksman"] = function()
          lspconfig.marksman.setup(
            vim.tbl_deep_extend("force", default_lsp_config, {
              filetypes = { "markdown", "quarto" },
              root_dir = lsputil.root_pattern(".git", "marksman.toml", "_quarto.yml")
            })
          )
        end,
        ["pyright"] = function()
          lspconfig.pyright.setup(
            vim.tbl_deep_extend("force", default_lsp_config, {
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = false,
                    diagnosticMode = "openFilesOnly",
                  },
                },
              },
              root_dir = function(fname)
                return lsputil.root_pattern(".git", "setup.py", "setup.cfg",
                  "pyproject.toml", "requirements.txt")(
                    fname
                  ) or lsputil.path.dirname(fname)
              end,
            })
          )
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
            init_options = {
              clangdFileStatus = true,
            },
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
        ["intelephense"] = function()
          lspconfig.intelephense.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            root_dir = lsputil.root_pattern("composer.json", ".git") or vim.uv.cwd(),
            init_options = {
              globalStoragePath = vim.fn.expand "~/.local/php/"
              -- clearCache = true
            }
          }))
        end,
        -- ["erlangls"] = function()
        --   lspconfig.erlangls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
        --     docs = {
        --       description = [[
        --                  https://github.com/erlang-ls/erlang_ls
        --                  ]],
        --     },
        --     root_dir = lsputil.root_pattern("rebar.config", "erlang.mk", ".git")
        --       or vim.loop.cwd(),
        --   }))
        -- end,
      }


      -- sourcekit is still not available on mason-lspconfig
      lspconfig.sourcekit.setup(vim.tbl_deep_extend("force", default_lsp_config, {
        cmd = {
          vim.fn.glob(
            "/Applications/Xcode*.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
            true, true)[1]
        },
        filetypes = { "swift" },
        root_dir = function(filename, _)
          local git_root = lsputil.find_git_ancestor(filename)
          return git_root
        end
      }))
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    --- @param o table options passed to config
    opts = function(_, o)
      local icons = require "lib.icons"

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
      local icons = require "lib.icons"

      o.ensure_installed = {
        "lua_ls",
        "vimls",
        "marksman",
        "tsserver",
        "sqls",
        "pyright",
        "jsonls",
        "gopls",
        "yamlls",
        "html",
        "bashls",
        "clangd",
        "intelephense",
        "ocamllsp",
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

  {
    "nvimtools/none-ls.nvim",
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

  -- Go
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- Java
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "java",
  },

  -- SQL
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
    config = function()
      vim.keymap.set("n", "<localleader>s", "<cmd>SqlsShowDatabases<cr>", { desc = "SqlsShowDatabases", buffer = 0 })
      vim.keymap.set("n", "<localleader>S", "<cmd>SqlsShowSchemas<cr>", { desc = "SqlsShowSchemas", buffer = 0 })
      vim.keymap.set("n", "<localleader>t", "<cmd>SqlsShowTables<cr>", { desc = "SqlsShowTables", buffer = 0 })
      vim.keymap.set("n", "<localleader>c", "<cmd>SqlsShowConnections<cr>", { desc = "SqlsShowConnections", buffer = 0 })
      vim.keymap.set("n", "<localleader>C", "<cmd>SqlsSwitchConnection<cr>", { desc = "SqlsSwitchConnection", buffer = 0 })
    end
  },

  -- Scala
  {
    "scalameta/nvim-metals",
    ft = "scala",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  },

  -- Json
  {
    "b0o/SchemaStore.nvim",
    ft = "json",
  }
}

return M