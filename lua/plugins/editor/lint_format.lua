-------------------------------------
-- File         : lint_format.lua
-- Description  : Linter and Formatter plugins and config
-- Author       : Kevin
-- Last Modified: 06/04/2025 - 18:30
-------------------------------------

return {
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
      lint.linters.flake8.args = {
        "--extend-ignore E302,E111,E501,W391",
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
      vim.g.disable_autoformat = true

      o.formatters_by_ft = {
        python = { "ruff" },
        bash = { "beautysh" },
        zsh = { "beautysh" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt", "prettier" },
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
            latex = "tex"
          },
          lang_to_ft = {
            bash = "sh"
          }
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

  ---NeovimDev
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
}