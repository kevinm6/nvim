-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 17 Nov 2024, 10:49
-------------------------------------

return {
  ---Nvim-lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   event = { "BufRead", "BufNewFile" },
  --   dependencies = {
  --     "mason.nvim",
  --     "mason-lspconfig.nvim",
  --   },
  --   cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
  --   config = function()
  --     -- require("lspconfig.ui.windows").default_options.border = "rounded"
  --
  --     -- sourcekit is still not available on mason-lspconfig
  --
  --     vim.keymap.set("n", "<leader>l", function() end, { desc = "LSP" })
  --   end,
  -- },

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
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = function(_, o)
  --     local lspconfig = require "lspconfig"
  --     local lsputil = require "lspconfig.util"
  --     local default_lsp_config = get_default_lsp_config()
  --
  --     o.ensure_installed = {
  --       "lua_ls",
  --       "vimls",
  --       "marksman",
  --       "ts_ls",
  --       "sqls",
  --       "pyright",
  --       "jsonls",
  --       "gopls",
  --       "yamlls",
  --       "html",
  --       "bashls",
  --       "clangd",
  --       "intelephense",
  --       "texlab",
  --     }
  --
  --     require("mason-lspconfig").setup(o)
  --
  --     require("mason-lspconfig").setup_handlers {
  --       -- The first entry (without a key) will be the default handler
  --       -- and will be called for each installed server that doesn't have
  --       --- @param server_name string name of the server of which handler is being set
  --       function(server_name)
  --         lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
  --       end,
  --
  --       -- Java LSP (jdtls) is managed via `nvim-jdtls` plugin and configured into
  --       -- 'ftplugin/java.lua'
  --       jdtls = function() end,
  --     }
  --   end,
  -- },

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
        yaml = { "yamlfmt", "prettier" },
        -- java = { "google-java-format" },
      }

      o.stop_after_first = true

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

  ---NeovimDevelopment
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
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

  -- expose function to servers that uses ad-hoc-plugin
  -- and adds custom features to LSP (like nvim-jdtls & nvim-metals)
  -- capabilities = init_capabilities,
  -- on_init = custom_init,
  -- on_attach = custom_attach,
}
