-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 10 Jul 2024, 09:12
-------------------------------------

---Create capabilities and set default values
---default and `cmp_nvim_lsp`
---@return table capabilities custom capabilities merged with default
local function init_capabilities()
  -- Update capabilities with extended from cmp_nvim_lsp if available
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end

--- Set buffer keymaps on supported capabilities of the passed client and buffer id
--- @param client table client passed to attach config
--- @param bufnr integer client passed to attach config
local function set_buf_keymaps(client, bufnr)
  local _, tele_builtin = pcall(require, "telescope.builtin")

  local function nmap(tbl)
    vim.keymap.set("n", tbl[1], tbl[2], { buffer = bufnr, desc = "LSP❭ " .. tbl[3] })
  end

  nmap {
    "K",
    function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if winid then
        local buf = vim.api.nvim_win_get_buf(winid)
        vim.wo[winid].list = false
        local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
        for _, k in ipairs(keys) do
          vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = buf })
        end
      else
        vim.lsp.buf.hover()
      end
    end,
    "Hover | PeekFold",
  }

  nmap { "<leader>lr", vim.lsp.buf.rename, "rename" }
  if client.supports_method "textDocument/declaration" then
    nmap { "gD", vim.lsp.buf.declaration, "GoTo Declaration" }
  end
  nmap {
    "gd",
    tele_builtin.lsp_definitions or vim.lsp.buf.definition,
    "GoTo Definitions",
  }
  if client.supports_method "textDocument/implementation" then
    nmap { "<leader>li", vim.lsp.buf.implementation, "implementation" }
  elseif client.supports_method "callHierarchy/incomingCalls" then
    nmap { "<leader>li", vim.lsp.buf.incoming_calls, "incoming-Calls" }
  end

  if client.supports_method "textDocument/signatureHelp" then
    vim.keymap.set("s", "<C-space>", vim.lsp.buf.signature_help, {
      buffer = bufnr,
      desc = "LSP❭ SignatureHelp",
    })
  end

  if client.supports_method "callHierarchy/outgoingCalls" then
    nmap { "<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing-Calls" }
  end
  nmap { "gr", tele_builtin.lsp_references or vim.lsp.buf.references, "GoTo References" }

  nmap {
    "<leader>lt",
    tele_builtin.lsp_type_definitions or vim.lsp.buf.type_definition,
    "TypeDef",
  }

  nmap {
    "<leader>ls",
    tele_builtin.lsp_document_symbols or vim.lsp.buf.document_symbol,
    "Workspace Symbols",
  }

  nmap {
    "<leader>lws",
    tele_builtin.lsp_workspace_symbols or vim.lsp.buf.workspace_symbol,
    "Workspace Symbols",
  }
  if client.supports_method "workspace/workspaceFolders" then
    nmap { "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder" }
    nmap {
      "<leader>lwr",
      vim.lsp.buf.remove_workspace_folder,
      "Workspace Remove Folder",
    }

    nmap {
      "<leader>lwl",
      function()
        print(table.concat(vim.lsp.buf.list_workspace_folders(), "\n"))
      end,
      "Workspace List Folders",
    }
  end

  nmap { "<leader>la", vim.lsp.buf.code_action, "Code Action" }

  nmap { "<leader>ll", vim.lsp.codelens.run, "CodeLens" }

  -- Enable completion on <c-x><c-o>
  -- vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

--- Set buffer capabilities if supported by the passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr integer buffer id passed to attach config
local function set_buf_funcs_for_capabilities(client, bufnr)
  local autocmd = vim.api.nvim_create_autocmd
  local usercmd = vim.api.nvim_create_user_command

  -- Completion
  -- TODO nvim-0.11
  -- if vim.fn.has "nvim-0.11" == 1 then -- and client.supports_method "textDocument/completion" then
  --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  -- end

  -- InlayHints
  if client.supports_method "textDocument/inlayHint" then
    usercmd("ToggleInlayHints", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { desc = "Toggle Inlay hints" })
  end

  -- lsp-document_highlight
  if client.supports_method "textDocument/documentHighlight" then
    local _lsp_hi_group = vim.api.nvim_create_augroup("_lsp_highlight_group", { clear = true })
    autocmd({ "CursorHold", "CursorHoldI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = function()
        return vim.lsp.buf.document_highlight()
      end,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
      callback = function()
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = _lsp_hi_group, buffer = bufnr }
      end,
    })
  end

  usercmd("LspCapabilities", function()
    require("lib.lsp").get_current_buf_lsp_capabilities(client, bufnr)
  end, { desc = "List server capabilities" })

  usercmd("ToggleDiagnostics", function()
    require("lib.lsp").toggle_diagnostics(bufnr)
  end, { desc = "List server capabilities" })
end

-- Custom configs to apply when starting lsp
--- @param client table client passed to attach config
local function custom_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
  client.config.flags.debounce_text_changes = 150
end

--- Custom configs to apply when attaching lsp to buffer
--- It setup handlers, keymaps and capabilities
--- @param client table client passed to attach config
--- @param bufnr integer buffer id passed to attach config
local function custom_attach(client, bufnr)
  require("plugins.lsp.handlers").setup()

  set_buf_keymaps(client, bufnr)
  set_buf_funcs_for_capabilities(client, bufnr)
end

--- Set default lsp config table to be passed to every server
---@return table default_config config with customized init, capabilities and attach
local function get_default_lsp_config()
  local capabilities = init_capabilities()

  return {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = capabilities,
  }
end

return {
  ---Nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
    -- Lua dev
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"
      local default_lsp_config = get_default_lsp_config()

      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- sourcekit is still not available on mason-lspconfig
      lspconfig.sourcekit.setup(vim.tbl_deep_extend("force", default_lsp_config, {
        cmd = {
          vim.fn.glob(
            "/Applications/Xcode*.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
            true,
            true
          )[1],
        },
        filetypes = { "swift" },
        root_dir = function()
          vim.fs.root(0, ".git")
        end,
      }))

      vim.keymap.set("n", "<leader>l", function() end, { desc = "LSP" })
      -- Global Diagnostics keymaps
      -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
      -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open Float" })
      vim.keymap.set(
        "n",
        "<leader>ld",
        require("telescope.builtin").diagnostics or vim.diagnostic.setloclist,
        { desc = "QF Diagnostics" }
      )
    end,
  },

  ---NeovimDevelopment
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },

  ---Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = function(_, o)
      local icons = require "mini.icons"

      o.ui = {
        border = "rounded",
        width = 0.7,
        height = 0.7,
        icons = {
          package_installed = icons.get("file", "done_sym"),
          package_pending = icons.get("file", "working_sym"),
          package_uninstalled = icons.get("file", "removed_sym"),
        },
        keymaps = {
          uninstall_package = "x",
          toggle_help = "?",
        },
      }
    end,
  },

  ---Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function(_, o)
      local lspconfig = require "lspconfig"
      local lsputil = require "lspconfig.util"
      local default_lsp_config = get_default_lsp_config()

      o.ensure_installed = {
        "lua_ls",
        "vimls",
        "marksman",
        "ts_ls",
        "sqls",
        "pyright",
        "jsonls",
        "gopls",
        "yamlls",
        "html",
        "bashls",
        "clangd",
        "intelephense",
        "texlab",
      }

      require("mason-lspconfig").setup(o)

      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        --- @param server_name string name of the server of which handler is being set
        function(server_name)
          lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
        end,

        -- Java LSP (jdtls) is managed via `nvim-jdtls` plugin and configured into
        -- 'ftplugin/java.lua'
        jdtls = function() end,

        -- Custom setup and overrides for servers
        lua_ls = function()
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
                    quote_style = "none",
                    continuation_indent = 2,
                    call_arg_parentheses = "remove",
                  },
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
                    vim.api.nvim_get_runtime_file("", true),
                    vim.fn.stdpath "config" .. "/lua",
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
                  setType = false,
                },
                telemetry = { enable = false },
              },
            },
          }))
        end,

        jsonls = function()
          lspconfig.jsonls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
            setup = {
              commands = {
                Format = {
                  function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
                  end,
                },
              },
            },
          }))
        end,

        yamlls = function()
          lspconfig.yamlls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            settings = {
              yaml = {
                schemaDownload = { enable = true },
                schemas = require("schemastore").yaml.schemas(),
                validate = true,
                schemaStore = {
                  enable = false,
                  -- url = "",
                },
              },
            },
          }))
        end,

        sqls = function()
          lspconfig.sqls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            on_attach = function(client, bufnr)
              custom_attach(client, bufnr)
              require("sqls").on_attach(client, bufnr)
            end,
          }))
        end,

        marksman = function()
          lspconfig.marksman.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            filetypes = { "markdown", "quarto" },
            root_dir = function()
              vim.fs.root(0, { ".git", "marksman.toml", "_quarto.yml" })
            end,
          }))
        end,

        pyright = function()
          lspconfig.pyright.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = false,
                  diagnosticMode = "workspace",
                },
              },
            },
            root_dir = function(fname)
              return vim.fs.root(0, {
                ".git",
                "setup.py",
                "setup.cfg",
                "pyproject.toml",
                "requirements.txt",
                fname,
              }) or vim.fs.dirname(fname)
            end,
          }))
        end,

        clangd = function()
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

        gopls = function()
          lspconfig.gopls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            root_dir = function(fname)
              return lsputil.root_pattern("go.mod", "go.work", ".git")(fname)
            end,
            settings = {
              gopls = {
                codelenses = {
                  test = true,
                  gc_details = true,
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
              },
            },
          }))
        end,

        ts_ls = function()
          lspconfig.ts_ls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            filetypes = { "js", "javascript", "typescript", "ojs", "typescriptreact", "typescript.tsx" },
            root_dir = function()
              return vim.fs.root(0, {
                "tsconfig.json",
                "package.json",
                "jsconfig.json",
                ".git",
              }) or vim.uv.cwd()
            end,
            init_options = {
              preferences = {
                includeCompletionsWithSnippetText = true,
                includeCompletionsForImportStatements = true,
              },
            },
          }))
        end,

        bashls = function()
          lspconfig.bashls.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            cmd = { "bash-language-server", "start" },
            filetypes = { "sh", "bash", "zsh" },
            allowList = { "sh", "bash", "zsh" },
            settings = {
              allowList = { "sh", "bash", "zsh" },
            },
            -- on_attach = function(client, _)
            --   client.server_capabilities.documentHighlightProvider = false
            -- end,
          }))
        end,

        intelephense = function()
          lspconfig.intelephense.setup(vim.tbl_deep_extend("force", default_lsp_config, {
            root_dir = function()
              return vim.fs.root(0, { "composer.json", ".git" }) or vim.uv.cwd()
            end,
            init_options = {
              globalStoragePath = vim.fn.expand "~/.local/php/",
              -- clearCache = true
            },
          }))
        end,
      }
    end,
  },

  ---Linter (Nvim-Lint)
  {
    "mfussenegger/nvim-lint",
    event = "InsertEnter",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        markdown = { "markdownlint" },
        json = { "jsonlint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "flake8" },
        gitcommit = { "commitlint" },
        php = { "php" },
        yaml = { "yamllint" },
      }

      lint.linters.markdownlint.args = {
        "--disable MD013 MD001 MD033", -- rules for line-lenght, heading-increment, inline-html
      }
      -- lint.linters.yamllint.args = {
      --   "--no-warnings", -- output only errors
      -- }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          if not lint then
            return
          end
          lint.try_lint()
        end,
      })
    end,
  },

  ---Formatter (Conform)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "Format", "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        desc = "Format <buf>",
      },
    },
    config = function(_, o)
      local conform = require "conform"

      o.formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        bash = { "beautysh" },
        zsh = { "beautysh" },
        -- css = { "prettier" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { { "yamlfmt", "prettier" } },
        -- java = { "google-java-format" },
      }

      o.format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end

      o.formatters = {
        beautysh = {
          args = { "$FILENAME" },
        },
        injected = {
          lang_to_ext = {
            bash = "sh",
            javascript = "js",
            markdown = "md",
            python = "py",
            ruby = "rb",
            typescript = "ts",
          },
        },
      }
      conform.setup(o)

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            ["start"] = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        conform.format { async = true, lsp_format = "fallback", range = range }
      end, { range = true })

      require("lib").user_command_toggle("ToggleAutoFormat", "disable_autoformat", {
        title = "Auto-Format (on-save)",
        desc = "AutoFormat (on-save)",
      })
    end,
  },

  ---Go
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    opts = function(_, o)
      o.icons = { breakpoint = "", currentpos = "" }
      o.diagnostic = {
        signs = { "", "", "", "󱧢" },
      }
      require("go").setup(o)

      vim.keymap.set("n", "<leader>df", "<cmd>GoTestFunc<CR>", { desc = "Go Test function" })
      vim.keymap.set("n", "<leader>dF", "<cmd>GoTestFile<CR>", { desc = "Go Test File" })
      vim.keymap.set("n", "<leader>lh", function()
        local to_search = vim.fn.input "Docs for: "
        if to_search ~= "" then
          vim.cmd.GoDoc(to_search)
        end
      end, { desc = "Go Doc" })
    end,
  },

  ---Java
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  ---SQL
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
  },

  ---JSON
  {
    "b0o/SchemaStore.nvim",
    ft = { "json", "yaml" },
  },

  -- expose functions below to special servers that uses ad-hoc-plugin
  -- and adds custom features to LSP (like nvim-jdtls & nvim-metals)
  -- set_buf_keymaps = set_buf_keymaps,
  -- set_buf_funcs_for_capabilities = set_buf_funcs_for_capabilities,
  capabilities = init_capabilities,
  on_init = custom_init,
  on_attach = custom_attach,
}