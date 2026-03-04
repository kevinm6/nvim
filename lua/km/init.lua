-------------------------------------
-- title: init.lua
-- abstract: plugin init scheme
-- author: Kevin
-- date: 02 Mar 2026, 21:07
-------------------------------------

---Hooks to be used for some plugins installation or updates that requires more steps
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if not ev.data then return end
    local kind = ev.data.kind
    if kind ~= "delete" then
      local name, build = ev.data.spec.name, ev.data.spec.data.build
      if not build then return end
      if kind == "update" and not ev.data.active then vim.cmd.packadd { args = { name }, bang = false } end
      vim.notify("vim.pack: Running build (" .. kind .. ") - " .. name, vim.log.levels.INFO, { title = "PackChanged" })
      pcall(build)
    end
  end
})

local ts_utils = require "lib.ts_utils"
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_utils.parsers_to_be_installed(),
  callback = function(ev)
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    ts_utils.attach(ev.buf)
  end
})

---Add github prefix to url
---@param user_repo string the context part of the GitHub url, in format `user/repo`
---@return string the full GitHub url
local function gh(user_repo)
  return "https://github.com/" .. user_repo
end

local mason_dir = vim.fn.stdpath "data" .. "/mason/bin"

--NOTE add mason packs to env PATH
if vim.uv.fs_stat(mason_dir) then
  vim.env.PATH = ("%s:%s"):format(mason_dir, vim.env.PATH)
end

vim.pack.add({
  ---Plugin: load on start
  ---QoL plugins
  {
    src = gh("echasnovski/mini.nvim"),
    data = {
      config = function()
        require "km.coding_helper"
      end
    }
  },

  {
    src = gh("folke/snacks.nvim"),
    data = {
      config = function()
        require "km.snacks"
      end
    },
  },

  ---Treesitter
  {
    src = gh("nvim-treesitter/nvim-treesitter"),
    data = {
      build = function()
        require "nvim-treesitter".install(ts_utils.parsers_to_be_installed()):wait(300000)
        require "nvim-treesitter".update()
      end,
    }
  },

  ---Plugin: lazy loading
  ---Completion
  {
    src = gh("saghen/blink.cmp"),
    version = vim.version.range(">=1.9.1"),
    data = {
      ev = { "InsertEnter", "CmdLineEnter" },
      config = function()
        require "km.completion"
      end,
    }
  },

  ---DAP
  {
    src = gh("mfussenegger/nvim-dap"),
    data = {
      ev = "VimEnter",
      config = function()
        require("dap-view").setup {
          windows = {
            size = 0.24,
          },
          winbar = {
            sections = {
              "watches",
              "scopes",
              "breakpoints",
              "exceptions",
              "repl",
              "console",
              "threads",
            },
            controls = { enabled = true },
          },
          help = { border = "rounded" }
        }
        require "km.dap"
      end
    }
  },
  {
    src = gh("igorlfs/nvim-dap-view"),
    name = "dap-view",
    data = { on_demand = true },
  },

  ---Mason
  {
    src = gh("mason-org/mason.nvim"),
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
  {
    src = gh("mfussenegger/nvim-lint"),
    data = {
      ev = "InsertEnter",
      config = function()
        local lint = require "lint"
        lint.linters_by_ft = {
          groovy = { "npm-groovy-lint" },
          -- markdown = { "markdownlint" },
          json = { "biomejs" },
          javascript = { "biomejs", "eslint_d" },
          typescript = { "biomejs", "eslint_d" },
          html = { "biomejs" },
          python = { "ruff" },
          gitcommit = { "commitlint" },
          php = { "php" },
          yaml = { "yamllint" },
        }
        -- lint.linters["npm-groovy-lint"].args = {
        --   "--config", vim.fn.expand "~/.config/groovylint/.groovylintrc.json",
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
  {
    src = gh("stevearc/conform.nvim"),
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
          groovy = { "npm-groovy-lint" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          css = { "prettier" },
          javascript = { "biome", "biome-organize-imports" },
          typescriptreact = { "biome", "biome-organize-imports" },
          html = { "biome" },
          json = { "biome" },
          -- json = { "biome" },
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
          groovy = { "npm-groovy-lint", "--format" },
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

        vim.keymap.set({ "n", "x", "v" }, "<leader>lf", function()
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
    src = gh("MeanderingProgrammer/markdown.nvim"),
    data = {
      ft = { "markdown", "quarto" },
      config = function()
        local render_markdown = require "render-markdown"
        render_markdown.setup {
          enabled = false, -- not rendering on enter md files
          file_types = { "markdown", "quarto", "markdown.mdx" },
          anti_conceal = { enabled = false },
          latex = { enabled = false, converter = "utftex" },
          acknowledge_conflicts = true,
          completions = { lsp = { enabled = true } },
          heading = {
            icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
          },
          checkbox = {
            unchecked = { -- Replaces '[ ]' of 'task_list_marker_unchecked'
              icon = "󰄱 ",
            },
            checked = { -- Replaces '[x]' of 'task_list_marker_checked'
              icon = "  ",
            },
            custom = {
              todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
            },
          }
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "markdown" },
          callback = function(ev)
            vim.keymap.set("n", "<leader>r", function()
              render_markdown.toggle()
            end, { buffer = ev.buf, desc = "Render Markdown" })
          end
        })

        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "TabLine" })
      end
    }
  },
  {
    src = gh("dhruvasagar/vim-table-mode"),
    data = {
      ft = { "markdown", "quarto" },
      cmd = { "TableModeToggle" },
      config = function()
        vim.g.table_mode_corner = '|'
      end
    }
  },

  ---Databases
  {
    src = gh("MunifTanjim/nui.nvim"),
    data = {}
  },
  {
    src = gh("kndndrj/nvim-dbee"),
    data = {
      cmd = { "Dbee" },
      config = function()
        vim.cmd.packadd "nui.nvim"
        require "km.databases"
      end
    }
  },

  ---Python
  {
    src = gh("mfussenegger/nvim-dap-python"),
    data = {
      ft = { "python" },
      config = function()
        vim.cmd.packadd "nvim-dap"
        local dap_py_venv = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin/python" or
            vim.fn.stdpath "data" .. "/.venv/bin/python3.12"
        if vim.fn.executable(dap_py_venv) then
          require "dap-python".setup(dap_py_venv)
        else
          vim.notify("Nvim-dap-python - python not found", vim.log.levels.WARN, { title = "Nvim-dap-python" })
        end
      end
    }
  },
  ---Go
  {
    src = gh("ray-x/go.nvim"),
    data = {
      build = function()
        require("go.install").update_all_sync()
      end,
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
    src = gh("mfussenegger/nvim-jdtls"),
    data = { ft = "java" }
  },
  ---Json
  {
    src = gh("b0o/SchemaStore.nvim"),
    data = { ft = { "json", "json5" } }
  },
  ---SQL
  {
    src = gh("nanotee/sqls.nvim"),
    data = { ft = "sql" }
  },
  ---Scala
  {
    src = gh("scalameta/nvim-metals"),
    data = { ft = { "scala", "sbt" } }
  },
  ---LaTex
  {
    src = gh("lervag/vimtex"),
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
    src = gh("ziontee113/color-picker.nvim"),
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
  ---Molten
  {
    src = gh("benlubas/molten-nvim"),
    data = {
      build = function() vim.cmd.UpdateRemotePlugins() end,
      ft = { "quarto" },
      config = function()
        vim.g.molten_auto_open_html_in_browser = true
        vim.g.molten_image_provider = "snacks.nvim"
        vim.g.molten_output_virt_lines = true -- pad to don't cover actual lines
        vim.g.molten_output_win_max_height = math.floor(vim.o.lines * 0.8)
        vim.g.molten_output_win_max_width = math.floor(vim.o.columns * 0.8)

        vim.keymap.set(
          "n",
          "<localleader>R",
          ":MoltenEvaluateOperator<CR>",
          { silent = true, buffer = true, noremap = true, desc = "run operator selection" }
        )
        vim.keymap.set(
          "n",
          "<localleader>rl",
          ":MoltenEvaluateLine<CR>",
          { silent = true, buffer = true, noremap = true, desc = "evaluate line" }
        )
        vim.keymap.set(
          "n",
          "<localleader>rc",
          ":MoltenReevaluateCell<CR>",
          { silent = true, buffer = true, noremap = true, desc = "re-evaluate cell" }
        )
        vim.keymap.set(
          "v",
          "<localleader>r",
          ":<C-u>MoltenEvaluateVisual<CR>gv",
          { silent = true, buffer = true, noremap = true, desc = "evaluate visual selection" }
        )

        vim.keymap.set("n", "<leader>M", function() end, { desc = "Molten" })
        vim.keymap.set("n", "<leader>MI", function()
          vim.cmd.MoltenInfo()
        end, { buffer = true, desc = "MoltenInfo" })
        vim.keymap.set("n", "<leader>Ml", function()
          vim.cmd.MoltenEvaluateLine()
        end, { buffer = true, desc = "MoltenEvaluateLine" })
        vim.keymap.set("v", "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv",
          { buffer = true, desc = "MoltenEvaluateVisual" })
        vim.keymap.set("n", "<leader>Ma", function()
          vim.cmd.MoltenEvaluateArgument()
        end, { buffer = true, desc = "MoltenEvaluateArgument" })
        vim.keymap.set("n", "<leader>Mo", function()
          vim.cmd.MoltenEvaluateOperator()
        end, { buffer = true, desc = "MoltenEvaluateOperator" })
        vim.keymap.set("n", "<leader>Mc", function()
          vim.cmd.MoltenReevaluateCell()
        end, { buffer = true, desc = "MoltenReevaluateCell" })
      end
    }
  },
  ---Quarto
  {
    src = gh("quarto-dev/quarto-nvim"),
    data = {
      ft = { "quarto" },
      config = function()
        vim.cmd.packadd "otter.nvim"
        require("quarto").setup {
          codeRunner = {
            default_method = "molten",
            ft_runners = { python = "molten", markdown = "molten" },
            never_run = { "yaml" },
          }
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "quarto",
          callback = function(ev)
            vim.keymap.set("n", "<localleader>qa", function()
              quarto.activate()
            end, { buffer = ev.buf, silent = true, desc = "Quarto❭ activate" })
            vim.keymap.set("n", "<localleader>qp", function()
              quarto.quartoPreview()
            end, { buffer = ev.buf, silent = true, desc = "Quarto❭ preview" })
            vim.keymap.set("n", "<localleader>qP", function()
              quarto.quartoClosePreview()
            end, { buffer = ev.buf, silent = true, desc = "Quarto❭ close Preview" })
            vim.keymap.set("n", "<localleader>qh", function()
              quarto.searchHelp()
            end, { buffer = ev.buf, silent = true, desc = "Quarto❭ search help" })

            local has_otter, otter = pcall(require, "otter")
            if has_otter then
              otter.activate { "python" }
            end
          end
        })

      end
    }
  },
  ---DataViewer (csv, tsv ...)
  {
    src = gh("nvim-lua/plenary.nvim"),
    name = "plenary",
    data = {
      config = function()
        require("lib.lazyload").require_stub("plenary", function()
          vim.cmd.packadd "plenary.nvim"
          require("plenary")
        end)
      end
    }
  },
  {
    src = gh("vidocqh/data-viewer.nvim"),
    data = {
      ft = { "sqlite", "tsv", "csv" },
      config = function()
        require("data-viewer").setup {}

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "csv", "tsv", "sqlite" },
          callback = function(ev)
            vim.keymap.set("n", "<leader>r", function()
              vim.cmd.DataViewer()
            end, { buffer = ev.buf, desc = "Data Viewer" })
          end
        })

        vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
        vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
        vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
        vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
      end
    }
  },
  ---Otter: spawns lsp-server for injected languages
  {
    src = gh("jmbuhr/otter.nvim"),
    data = {
      -- ev = "VimEnter",
      ft = { "quarto", "html", "css", "php", "javascript" },
      config = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "html", "css", "php", "javascript" },
          callback = function()
            require("otter").activate() -- { "javascript", "php", "css" }
          end,
        })

        -- vim.api.nvim_create_autocmd("FileType", {
        --   pattern = { "jupyter_notebook" },
        --   callback = function(_)
        --     require("otter").activate { "jupyter_notebook", "quarto", "qmd", "markdown", "python" }
        --   end,
        -- })
      end
    }
  },

  ---Webdev
  {
    src = gh("rest-nvim/rest.nvim"),
    data = {
      ft = "http",
      config = function()
        ---@class rest.Config
        vim.g.rest_nvim = {
          request = {
            skip_ssl_verification = true,
          },
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern  = { "http", "https" },
          callback = function()
            vim.keymap.set("n", "<localleader>r", "<cmd>Rest run<cr>",
              { desc = "Run Request under cursor", buffer = true })
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
  },

  ---AI
  {
    src = gh("milanglacier/minuet-ai.nvim"),
    name = "minuet",
    data = {
      config = function()
        ---NOTE: create user_command ad hoc to enable, since AI must be on-demand
        vim.api.nvim_create_user_command("AIcompletion", function()
          require "km.ai"
          vim.api.nvim_del_user_command "AIcompletion"
        end, {})
      end
    }
  }
}, {
  load = function(p)
    local p_name = p.spec.name or ""
    local data = p.spec.data or {}
    local lazy = (data.cmd or data.ft or data.ev or data.on_demand)
    assert(p_name, "Plugin name cannot be empty.")
    if data.on_demand then
      require("lib.lazyload").require_stub(p_name, function()
        vim.cmd.packadd(p_name)
        require(p_name)
      end)
    end

    local function run_config()
      if data and data.config then
        data.config()
      end
    end

    if data.cmd then
      for _, cmd in ipairs(data.cmd) do
        require("lib.lazyload").command_stub(cmd, function()
          vim.cmd.packadd(p_name)
          if package.loaded[p_name] == nil then
            run_config()
          end
          vim.cmd(cmd)
        end)
      end
    end
    if data.ft then
      vim.api.nvim_create_autocmd("FileType", {
        once = true,
        pattern = data.ft,
        callback = function()
          vim.cmd.packadd(p_name)
          run_config()
        end
      })
    end
    if data.ev then
      vim.api.nvim_create_autocmd(data.ev, {
        once = true,
        callback = function()
          vim.cmd.packadd(p_name)
          run_config()
        end
      })
    end
    if not lazy then
      vim.cmd.packadd(p_name)
      run_config()
    end
  end,
})