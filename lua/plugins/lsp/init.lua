-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 24 Mar 2024, 13:27
-------------------------------------

--- Create capabilities and set default values
local function init_capabilities()
  -- Update capabilities with extended from cmp_nvim_lsp if available
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend(
      'force', capabilities,
      cmp_nvim_lsp.default_capabilities()
    )
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
end

--- Set buffer keymaps based on supported capabilities of the
--- passed client and buffer id
--- @param client any client passed to attach config
local function set_buf_keymaps(client, bufnr)
  local _, tele_builtin = pcall(require, "telescope.builtin")

  local nmap = function(tbl)
    vim.keymap.set('n', tbl[1], tbl[2], { buffer = bufnr, desc = "LSP:" .. tbl[3] })
  end

  nmap { "K", function()
    return require("ufo").peekFoldedLinesUnderCursor() or
        vim.lsp.buf.hover()
  end, "Hover | PeekFold" }

  nmap { "<leader>lr", vim.lsp.buf.rename, "[r]ename" }

  if client.server_capabilities.declarationProvider then
    nmap { "gD", vim.lsp.buf.declaration, "[g]oTo [D]eclaration" }
  end
  if client.server_capabilities.definitionProvider then
    nmap { "gd", tele_builtin.lsp_definitions or vim.lsp.buf.definition, "[g]oTo [d]efinitions" }
  end
  if client.server_capabilities.implementationProvider then
    nmap { "<leader>li", vim.lsp.buf.implementation, "[I]ncoming-Calls" }
  end
  if client.supports_method "callHierarchy/incomingCalls" then
    nmap { "<leader>li", vim.lsp.buf.outgoing_calls, "[I]ncoming-Calls" }
  end
  if client.supports_method "callHierarchy/outgoingCalls" then
    nmap { "<leader>lo", vim.lsp.buf.outgoing_calls, "[O]utgoing-Calls" }
  end
  if client.server_capabilities.referencesProvider then
    nmap { "gr", tele_builtin.lsp_references or vim.lsp.buf.references, "[g]oTo [r]eferences" }
  end

  nmap { "<leader>lt", tele_builtin.lsp_type_definitions or vim.lsp.buf.type_definition, "[t]ypeDef" }

  nmap { "<leader>ls", tele_builtin.lsp_document_symbols or vim.lsp.buf.document_symbol, "[w]orkspace [s]ymbols" }
  nmap { "<leader>lws", tele_builtin.lsp_workspace_symbols or vim.lsp.buf.workspace_symbol, "[w]orkspace [s]ymbols" }
  nmap { "<leader>lwa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd folder" }
  nmap { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove folder" }
  nmap { "<leader>lwl", function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, "[w]orkspace [r]emove folder" }

  nmap { "<leader>ll", vim.lsp.codelens.run, "CodeLens Action" }
  nmap { "<leader>la", vim.lsp.buf.code_action, "Code [a]ction" }

  -- Enable completion on <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

--- Set buffer capabilities based if supported by the
--- passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr any|integer buffer id passed to attach config
local function set_buf_funcs_for_capabilities(client, bufnr)
  local autocmd = vim.api.nvim_create_autocmd
  local usercmd = vim.api.nvim_create_user_command

  -- InlayHints
  if client.supports_method "textDocument/inlayHint" then
    -- TODO: remove check for nvim_v0.10 after update
    if vim.lsp.inlay_hint then
      vim.api.nvim_create_user_command("InlayHints", function()
        --   vim.lsp.inlay_hint.enable(bufnr, true)
        if vim.lsp.inlay_hint.is_enabled(bufnr) then
          vim.lsp.inlay_hint.enable(bufnr, false)
        else
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end, { desc = "Toggle Inlay hints" })
    end
  end

  -- lsp-document_highlight
  if client.server_capabilities.documentHighlightProvider then
    autocmd({ "CursorHold", "CursorHoldI" }, {
      -- group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      -- group = lsp_document_highlight,
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
    usercmd("LspAutoFormat", function()
      lib_format.toggle_format_on_save()
    end, {})

    usercmd("Format", function()
      lib_format.lsp_format(bufnr)
    end, { force = true })

    vim.keymap.set("n", "<leader>lf", function()
      lib_format.lsp_format(bufnr)
    end, { desc = "Format", buffer = true })
    vim.keymap.set("n", "<leader>lF", function()
      vim.cmd.LspToggleAutoFormat()
    end, { desc = "Toggle AutoFormat", buffer = true })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    local lib_format = require "lib.format"
    vim.keymap.set("v", "<leader>lf", function()
      lib_format.lsp_format(bufnr)
    end, { desc = "Range format", buffer = true })
  end

  usercmd("LspCapabilities", function()
    require("lib.utils").get_current_buf_lsp_capabilities()
  end, {})
end

-- Custom configs to apply when starting lsp
--- @param client any client passed to attach config
local function custom_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
  client.config.flags.debounce_text_changes = 150
end

--- Custom configs to apply when attaching lsp to buffer
--- @param client any client passed to attach config
--- @param bufnr any|integer buffer id passed to attach config
local function custom_attach(client, bufnr)
  require("plugins.lsp.handlers").setup(client, bufnr)

  set_buf_keymaps(client, bufnr)
  set_buf_funcs_for_capabilities(client, bufnr)
end

--- Set default lsp config table to be passed to every server
local function get_default_lsp_config()
  local capabilities = init_capabilities()
  local default_config = {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = capabilities
  }
  return default_config
end


local M = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
    -- Lua dev
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    -- keys = {
    --   { "<leader>l", nil, desc = "LSP" },
    -- },
    config = function()
      local lspconfig = require "lspconfig"
      local lsputil = require "lspconfig.util"
      local default_lsp_config = get_default_lsp_config()

      require('lspconfig.ui.windows').default_options.border = 'rounded'

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

      vim.keymap.set("n", "<leader>l", function() end, { desc = "LSP" })
      -- Global Diagnostics keymaps
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next [d]iagnostic" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev [d]iagnostic" })
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open float" })
      vim.keymap.set("n", "<leader>ld",
        require("telescope.builtin").diagnostics or vim.diagnostic.setloclist
        , { desc = "QF [d]iagnostics" })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = function(_, o)
      local icons = require "lib.icons"

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
          uninstall_package = "D",
        }
      }
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
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
        "dockerls",
      }
      o.automatic_installation = true
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
    end,
    config = function(_, o)
      local lspconfig = require "lspconfig"
      local lsputil = require "lspconfig.util"
      local default_lsp_config = get_default_lsp_config()
      require("mason-lspconfig").setup(o)

      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        --- @param server_name string name of the server of which handler is being set
        function(server_name)
          lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
        end,

        -- Java LSP (jdtls) is managed via nvim-jdtls plugin and configured into
        -- 'ftplugin/java.lua'
        ["jdtls"] = function() end,

        -- Custom setup and overrides for servers
        ["lua_ls"] = function()
          require "neodev".setup({
            library = { plugins = { "nvim-dap-ui" }, types = true }
          })

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
                  disable = { "undefined-field" },
                },
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                    quote_style = "double",
                    continuation_indent = 2
                  }
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
                    vim.api.nvim_get_runtime_file("", true),
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
                schemas = require('schemastore').yaml.schemas(),
                validate = true,
                schemaStore = {
                  enable = true,
                  url = ''
                }
              }
            }
          }))
        end,
        -- ["sqls"] = function()
        --   lspconfig.sqls.setup(
        --     vim.tbl_deep_extend("force", default_lsp_config, {
        --       on_attach = function(client, bufnr)
        --         custom_attach(client, bufnr)
        --         require "sqls".on_attach(client, bufnr)
        --       end,
        --     })
        --   )
        -- end,
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
                    diagnosticMode = 'workspace'
                  }
                }
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

              local absolute_cwd = Path:new(vim.uv.cwd()):absolute()
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
            filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
            root_dir = lsputil.root_pattern(
              "tsconfig.json",
              "package.json",
              "jsconfig.json",
              ".git"
            ) or vim.uv.cwd(),
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
    end
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
        python = { "pyflakes" },
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
    dependencies = { "plenary.nvim" },
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
        -- null_ls.builtins.formatting.stylua.with {
        --   extra_args = function(params)
        --     return params.options
        --       and params.options.tabSize
        --       and { "--indent-width", params.options.tabSize }
        --   end,
        -- },
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
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    enabled = false,
    dependencies = { -- optional packages
      "nvim-lspconfig",
      "nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    build =
    ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- Java
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "nvim-dap" },
    ft = "java",
  },

  -- SQL
  {
    "nanotee/sqls.nvim",
    enabled = false, -- disabled for now (using nvim-dbee for manage DBs)
    ft = { "sql", "mysql" },
    -- config = function()
    --   vim.keymap.set("n", "<localleader>s", "<cmd>SqlsShowDatabases<cr>",
    --     { desc = "SqlsShowDatabases", buffer = 0 })
    --   vim.keymap.set("n", "<localleader>S", "<cmd>SqlsShowSchemas<cr>",
    --     { desc = "SqlsShowSchemas", buffer = 0 })
    --   vim.keymap.set("n", "<localleader>t", "<cmd>SqlsShowTables<cr>",
    --     { desc = "SqlsShowTables", buffer = 0 })
    --   vim.keymap.set("n", "<localleader>c", "<cmd>SqlsShowConnections<cr>",
    --     { desc = "SqlsShowConnections", buffer = 0 })
    --   vim.keymap.set("n", "<localleader>C", "<cmd>SqlsSwitchConnection<cr>",
    --     { desc = "SqlsSwitchConnection", buffer = 0 })
    -- end
  },

  -- Scala
  {
    "scalameta/nvim-metals",
    ft = "scala",
    enabled = false,
    dependencies = {
      "plenary.nvim",
      "nvim-dap",
    },
  },

  -- Json
  {
    "b0o/SchemaStore.nvim",
    ft = { "json", "yml" },
  }
}

return M