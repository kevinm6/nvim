-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 16 Nov 2025, 13:31
-------------------------------------

---Plugin: load on start
vim.pack.add({
  ---QoL plugins
  "https://github.com/echasnovski/mini.nvim",

  "https://github.com/folke/snacks.nvim",

  ---Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

---Plugin: lazy loading
vim.pack.add({
  ---Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },

  ---DAP
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  {
    src = "https://github.com/mfussenegger/nvim-dap",
    data = {
      ev = "VimEnter",
      config = function ()
        vim.cmd.packadd "nvim-nio"
        vim.cmd.packadd "nvim-dap-ui"
        require("plugins.dap")
      end
    }
  },

  ---Mason
  {
    src = "https://github.com/williamboman/mason.nvim",
    data = {
      cmd = { "Mason" },
      config = function()
        require("mason").setup {
          ui = {
            border = "rounded",
            width = 0.7,
            height = 0.7,
            icons = {
              package_installed = "✓",
              package_pending = "⟳",
              package_uninstalled = "-",
            },
            keymaps = {
              uninstall_package = "x",
              toggle_help = "?",
            },
          },
        }
      end
    }
  },
  ---Lint & Format
  ---- Lint (Nvim-Lint) "mfussenegger/nvim-lint", event = "InsertEnter"
  {
    src = "https://github.com/mfussenegger/nvim-lint",
    data = {
      ev = "InsertEnter",
      config = function()
        local lint = require "lint"
        lint.linters_by_ft = {
          markdown = { "markdownlint" },
          json = { "biomejs" },
          javascript = { "biomejs", "eslint_d" },
          typescript = { "biomejs", "eslint_d" },
          python = { "ruff" },
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
      end
    }
  },
  ---Formatter (Conform)
  -- "stevearc/conform.nvim", event = { "BufWritePre" }, cmd = { "Format", "ConformInfo" }
  {
    src = "https://github.com/stevearc/conform.nvim",
    data = {
      cmd = { "Format", "ConformInfo" },
      ev = "BufWritePre",
      config = function()
        local conform = require "conform"
        local opts = {}
        vim.g.disable_autoformat = true

        opts.formatters_by_ft = {
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
          -- java = { "google-java-format" },
        }

        opts.format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end

        opts.formatters = {
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

        conform.setup(opts)

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

        vim.keymap.set("n", "<leader>lf", function()
          conform.format { async = true, lsp_fallback = true }
        end, { desc = "Format <buf>", })
        require("lib").user_command_toggle("ToggleAutoFormat", "disable_autoformat", {
          title = "Auto-Format (on-save)",
          desc = "AutoFormat (on-save)",
        })
      end
    }
  },

  ---Markdown
  {
    src = "https://github.com/MeanderingProgrammer/markdown.nvim",
    data = {
      ft = { "markdown", "quarto" },
      config = function()
        require("render-markdown").setup {
          enabled = false, -- not rendering on enter md files
          file_types = { "markdown", "quarto", "markdown.mdx" },
          anti_conceal = { enabled = false },
          latex = {
            enabled = false,
            converter = "utftex",
          },
          acknowledge_conflicts = true,
          heading = {
            icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
          },
          checkbox = {
            unchecked = { -- Replaces '[ ]' of 'task_list_marker_unchecked'
              icon = "󰄱 ",
            },
            checked = { -- Replaces '[x]' of 'task_list_marker_checked'
              icon = "󰄵 ",
            },
            custom = {
              todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
            },
          }
        }

        vim.keymap.set("n", "<localleader>r", ":RenderMarkdown toggle", { desc = "Render Markdown" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "TabLine" })
      end
    }
  },

  ---Databases
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  {
    src = "https://github.com/kndndrj/nvim-dbee",
    data = {
      cmd = { "Dbee" },
      config = function()
        vim.cmd.packadd "nui.nvim"
        require "plugins.databases"
      end
    }
  },

  ---Go
  {
    src = "https://github.com/ray-x/go.nvim",
    data = {
      ft = "go",
      config = function()
        require("go").setup {
          icons = { breakpoint = "", currentpos = "" },
          diagnostic = {
            signs = { "", "", "", "󱧢" },
          }
        }

        vim.keymap.set("n", "<leader>df", "<cmd>GoTestFunc<CR>", { desc = "Go Test function" })
        vim.keymap.set("n", "<leader>dF", "<cmd>GoTestFile<CR>", { desc = "Go Test File" })
        vim.keymap.set("n", "<leader>lh", function()
          local to_search = vim.fn.input "Docs for: "
          if to_search ~= "" then
            vim.cmd.GoDoc(to_search)
          end
        end, { desc = "Go Doc" })
      end
    }
  },
  ---Java
  {
    src = "https://github.com/mfussenegger/nvim-jdtls",
    data = { ft = "java" }
  },
  ---Json
  {
    src = "https://github.com/b0o/SchemaStore.nvim",
    data = { ft = { "json", "json5" } }
  },
  ---SQL
  {
    src = "https://github.com/nanotee/sqls.nvim",
    data = { ft = "sql" }
  },
  ---Scala
  {
    src = "https://github.com/scalameta/nvim-metals",
    data = { ft = { "scala", "sbt" } }
  },
  ---LaTex
  {
    src = "https://github.com/lervag/vimtex",
    data = {
      ft = { "tex", "plaintex", "bib" },
      config = function()
        ---LaTeX
        vim.g.vimtex_view_method = "sioyek"
        vim.g.vimtex_quickfix_mode = 0 -- don't open qflist on compile errors
        vim.g.vimtex_mappings_prefix = "\\"
        vim.g.vimtex_fold_enabled = 1
        vim.g.tex_conceal = "abdmg"
        vim.g.vimtex_toc_config = {
          split_pos = "rightbelow",
          split_width = 20,
          show_help = 0,
        }
        -- Latex warnings to ignore
        vim.g.vimtex_quickfix_ignore_filters = {
          "Underfull",
          "Overfull",
          "Font shape",
          "package",
          -- "Command terminated with space",
          -- "LaTeX Font Warning: Font shape",
          -- "Package caption Warning: The option",
          -- "Package enumitem Warning: Negative labelwidth",
          -- [[Package caption Warning: Unused \\captionsetup]],
          -- "Package typearea Warning: Bad type area settings!",
          -- [[Package fancyhdr Warning: \\headheight is too small]],
          -- "Package hyperref Warning: Token not allowed in a PDF string",
        }
        vim.g.vimtex_log_ignore = {
          "Underfull",
          "Overfull",
          "specifier changed t",
          "Token not allowed in a PDF string",
        }

        vim.api.nvim_create_autocmd("BufReadPre", {
          pattern = "*.tex",
          callback = function(ev)
            vim.b.vimtex_main = ev.file
          end,
        })
      end
    }
  },
  ---Color Picker
  {
    src = "https://github.com/ziontee113/color-picker.nvim",
    data = {
      cmd = { "PickColor" },
      config = function()
        require("color-picker").setup {
          ["icons"] = { "", "" },
          ["border"] = "rounded",
        }
      end
    }
  },
  ---Nvim colorizer
  {
    src = "https://github.com/norcalli/nvim-colorizer.lua",
    data = { cmd = { "ColorizerToggle" } }
  },
  ---Jupyter Notebook
  {
    src = "https://github.com/GCBallesteros/jupytext.nvim",
    data = {
      ft = { "quarto", "qmd" },
      config = function()
        require("jupytext").setup {
          custom_language_formatting = {
            python = { extension = "qmd", style = "quarto", force_ft = "quarto" },
          }
        }
      end
    }
  },
  ---Molten
  {
    src = "https://github.com/benlubas/molten-nvim",
    version = vim.version.range("^1.0.0"),
    data = {
      ft = { "qmd", "jupyter_notebook", "quarto" },
      config = function()
        --   build = ":UpdateRemotePlugins",
        vim.g.molten_auto_open_html_in_browser = true
        vim.g.molten_image_provider = "snacks.nvim"
        vim.g.molten_output_virt_lines = true -- pad to don't cover actual lines
        vim.g.molten_output_win_max_height = math.floor(vim.o.lines * 0.8)
        vim.g.molten_output_win_max_width = math.floor(vim.o.columns * 0.8)

        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("_molten_keymaps", { clear = true }),
          pattern = { "qmd", "jupyter_notebook", "quarto" },
          callback = function(ev)
            vim.keymap.set(
              "n",
              "<localleader>R",
              ":MoltenEvaluateOperator<CR>",
              { silent = true, buffer = ev.buf, noremap = true, desc = "run operator selection" }
            )
            vim.keymap.set(
              "n",
              "<localleader>rl",
              ":MoltenEvaluateLine<CR>",
              { silent = true, buffer = ev.buf, noremap = true, desc = "evaluate line" }
            )
            vim.keymap.set(
              "n",
              "<localleader>rc",
              ":MoltenReevaluateCell<CR>",
              { silent = true, buffer = ev.buf, noremap = true, desc = "re-evaluate cell" }
            )
            vim.keymap.set(
              "v",
              "<localleader>r",
              ":<C-u>MoltenEvaluateVisual<CR>gv",
              { silent = true, buffer = ev.buf, noremap = true, desc = "evaluate visual selection" }
            )

            vim.keymap.set("n", "<leader>M", function() end, { desc = "Molten" })
            vim.keymap.set("n", "<leader>MI", function()
              vim.cmd.MoltenInfo()
            end, { buffer = ev.buf, desc = "MoltenInfo" })
            vim.keymap.set("n", "<leader>Ml", function()
              vim.cmd.MoltenEvaluateLine()
            end, { buffer = ev.buf, desc = "MoltenEvaluateLine" })
            vim.keymap.set("v", "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv",
              { buffer = ev.buf, desc = "MoltenEvaluateVisual" })
            vim.keymap.set("n", "<leader>Ma", function()
              vim.cmd.MoltenEvaluateArgument()
            end, { buffer = ev.buf, desc = "MoltenEvaluateArgument" })
            vim.keymap.set("n", "<leader>Mo", function()
              vim.cmd.MoltenEvaluateOperator()
            end, { buffer = ev.buf, desc = "MoltenEvaluateOperator" })
            vim.keymap.set("n", "<leader>Mc", function()
              vim.cmd.MoltenReevaluateCell()
            end, { buffer = ev.buf, desc = "MoltenReevaluateCell" })
          end
        })
      end
    }
  },
  ---Quarto
  {
    src = "https://github.com/quarto-dev/quarto-nvim",
    data = {
      ft = "quarto",
      config = function()
        require("quarto").setup {
          codeRunner = {
            enabled = false,
            default_method = "molten",
            ft_runners = { python = "molten", markdown = "molten" },
            never_run = { "yaml" },
          }
        }

        vim.keymap.set("n", "<localleader>qa", function()
          quarto.activate()
        end, { silent = true, desc = "Quarto❭ activate" })
        vim.keymap.set("n", "<localleader>qp", function()
          quarto.quartoPreview()
        end, { silent = true, desc = "Quarto❭ preview" })
        vim.keymap.set("n", "<localleader>qP", function()
          quarto.quartoClosePreview()
        end, { silent = true, desc = "Quarto❭ close Preview" })
        vim.keymap.set("n", "<localleader>qh", function()
          quarto.searchHelp()
        end, { silent = true, desc = "Quarto❭ search help" })
      end
    }
  },
  ---DataViewer (csv, tsv ...)
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  {
    src = "https://github.com/vidocqh/data-viewer.nvim",
    data = {
      ft = { "sqlite", "tsv", "csv" },
      config = function()
        vim.cmd.packadd "plenary.nvim"
        require("data-viewer").setup {}

        vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
        vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
        vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
        vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
      end
    }
  },
  ---Otter: spawns lsp-server for injected languages
  {
    src = "https://github.com/jmbuhr/otter.nvim",
    data = {
      ft = { "quarto", "markdown", "html", "javascript", "typescript" },
      config = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "html",
          callback = function()
            require("otter").activate { "javascript", "php", "css" }
          end,
        })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "javascript",
          callback = function()
            require("otter").activate { "html", "php" }
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "php",
          callback = function()
            require("otter").activate { "html", "javascript" }
          end,
        })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "qmd", "quarto" },
          callback = function()
            require("otter").activate { "quarto", "markdown", "python" }
            vim.treesitter.language.register("markdown", "python")
            -- vim.treesitter.language.register("quarto", "markdown")
            vim.treesitter.language.register("quarto", "python")
            vim.treesitter.start()
          end,
        })
      end
    }
  },

  ---Webdev
  {
    src = "https://github.com/rest-nvim/rest.nvim",
    data = {
      ft = "http",
      config = function ()
        ---@class rest.Config
        vim.g.rest_nvim = {
          request = {
            skip_ssl_verification = true,
          },
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "http", "https" },
          callback  = function()
            vim.keymap.set("n", "<localleader>r", "<cmd>Rest run<cr>", { desc = "Run Request under cursor", buffer = true })
            vim.keymap.set("n", "<localleader>l", "<cmd>Rest last<cr>", { desc = "Run Last Request", buffer = true })
            vim.keymap.set(
              "n",
              "<localleader>p",
              "<Plug>RestNvimPreview",
              { desc = "Preview Request cURL command", buffer = true }
            )
            vim.keymap.set("n", "<localleader>R", "<cmd>Rest run document<cr>", { desc = "Run File", buffer = true })
          end
        })
      end
    }
  }
}, {
  load = function(p)
    local data = p.spec.data or {}
    local lazy = (data.cmd or data.ft or data.ev)
    if data.cmd then
      for _, cmd in ipairs(data.cmd) do
        vim.api.nvim_create_user_command(cmd, function()
          vim.cmd.packadd(p.spec.name)
          if p.spec.data and p.spec.data.config then
            p.spec.data.config()
          end
          vim.cmd(cmd)
        end, {})
      end
    end
    if data.ft then
      vim.api.nvim_create_autocmd("FileType", {
        pattern = data.ft,
        callback = function()
          vim.cmd.packadd(p.spec.name)
          if p.spec.data and p.spec.data.config then
            p.spec.data.config()
          end
        end
      })
    end
    if data.ev then
      vim.api.nvim_create_autocmd(data.ev, {
        callback = function()
          vim.cmd.packadd(p.spec.name)
          if p.spec.data and p.spec.data.config then
            p.spec.data.config()
          end
        end
      })
    end
    if not lazy then
      vim.cmd.packadd(p.spec.name)
    end
  end,
})

require("plugins.snacks")
require("plugins.coding_helper")
require("plugins.treesitter")
require("plugins.completion")

---Hooks to be used for some plugins installation or updates that requires other steps
---@param ev table
local function hooks(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  vim.print(name, kind)

  if (kind == "install" or kind == "update") then
    vim.cmd.packadd { args = { name }, bang = false }
    local title = string.format("vim.pack 󰅂 %s", name)
    local msg_info = string.format("building '%s' due to install/update plugin", name)
    if name == "nvim-treesitter" then
      vim.notify(msg_info, vim.log.levels.INFO, { title = title })
      require("nvim-treesitter").update()
    end
    if name == "blink.cmp" then
      vim.notify(msg_info, vim.log.levels.INFO, { title = title })
      require("blink.cmp.fuzzy.build").build()
    end
    if name == "go.nvim" then
      vim.notify(msg_info, vim.log.levels.INFO, { title = title })
      require("go.install").update_all_sync()
    end
  end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })