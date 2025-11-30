-------------------------------------
-- File         : lint_format.lua
-- Description  : Linter and Formatter plugins and config
-- Author       : Kevin
-- Last Modified: 03 Dec 2025, 11:08
-------------------------------------

return {
  ---Linter (Nvim-Lint)
  {
    "mfussenegger/nvim-lint",
    event = "InsertEnter",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        groovy = { "npm-groovy-lint" },
        markdown = { "markdownlint" },
        json = { "biomejs" },
        javascript = { "biomejs", "eslint_d" },
        typescript = { "biomejs", "eslint_d" },
        python = { "ruff" },
        gitcommit = { "commitlint" },
        php = { "php" },
        yaml = { "yamllint" },
      }

      lint.linters["npm-groovy-lint"].args = {
        "--config ", vim.fn.expand "~/.groovylintrc.json"
      }

      lint.linters.markdownlint.args = {
        "--disable MD013 MD001 MD033", -- rules for line-lenght, heading-increment, inline-html
      }

      -- lint.linters.eslint_d.args = {
      --   "--no-warn-ignored", -- <-- this is the key argument
      --   "--format",
      --   "json",
      --   "--stdin",
      --   "--stdin-filename",
      --   function()
      --     return vim.api.nvim_buf_get_name(0)
      --   end,
      -- }

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
        python = {
          -- To fix auto-fixable lint errors.
          -- "ruff_fix",
          -- To run the Ruff formatter.
          "ruff_format",
          -- To organize the imports.
          "ruff_organize_imports",
        },
        bash = { "beautysh" },
        zsh = { "beautysh" },
        css = { "prettier" },
        javascript = { "biomejs", "biome-organize-imports" },
        typescriptreact = { "biomejs", "biome-organize-imports" },
        html = { "prettier" },
        json = { "biome" },
        yaml = { "yamlfmt", "prettier" },
        groovy = { "npm-groovy-lint" }
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
        ["npm-groovy-lint"] = {
          args = { "--config ", vim.fn.expand "~/.groovylintrc.json", "--format" }
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
}