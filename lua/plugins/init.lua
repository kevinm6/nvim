-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 28/06/2025, 10:50
-------------------------------------

vim.pack.add({
  ---QoL plugins
  "https://github.com/echasnovski/mini.nvim",

  ---QoL plugins
  "https://github.com/kevinm6/snacks.nvim",

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  ---Mason
  "https://github.com/williamboman/mason.nvim",

  ---Databases
  "https://github.com/kndndrj/nvim-dbee",
  "https://github.com/MunifTanjim/nui.nvim",

  ---DAP
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/mfussenegger/nvim-dap",

  ---Lint & Format
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/stevearc/conform.nvim",

  ---Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },

  ---Folding
  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",

  ---Markdown
  "https://github.com/MeanderingProgrammer/markdown.nvim",

  ---Webdev
  -- TODO: to fix
  -- "https://github.com/rest-nvim/rest.nvim",
})

-- require("color-picker").setup {
--   ["icons"] = { "", "" },
--   ["border"] = "rounded",
-- }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "bib" },
  callback = function()
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
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = { "BufRead *.ipynb", "BufNewFile *.ipynb" },
  callback = function()
    require("jupytext").setup {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      }
    }
  end
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "quarto",
  callback = function()
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
    end, { silent = true, desc = "Quarto❭ aactivate" })
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
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sqlite", "tsv", "csv" },
  callback = function()
    require("data-viewer").setup {}

    vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
    vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
    vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
    vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "quarto", "markdown", "html", "javascript", "typescript" },
  callback = function()
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
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qmd", "jupyter_notebook", "quarto" },
  callback = function()
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
})

local pack = require "lib.pack"

pack.ensure_installed({
  ---Go
  { src = "https://github.com/ray-x/go.nvim" },
  ---Java
  { src = "https://github.com/mfussenegger/nvim-jdtls" },
  ---Json
  { src = "https://github.com/b0o/SchemaStore.nvim" },
  ---SQL
  { src = "https://github.com/nanotee/sqls.nvim" },
  ---LaTex
  { src = "https://github.com/lervag/vimtex" },
  ---Color Picker
  { src = "https://github.com/ziontee113/color-picker.nvim" },
  ---Nvim colorizer
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  ---Jupyter Notebook
  { src = "https://github.com/GCBallesteros/jupytext.nvim" },
  ---Molten
  { src = "https://github.com/benlubas/molten-nvim", version = vim.version.range("^1.0.0") },
  ---Quarto
  { src = "https://github.com/quarto-dev/quarto-nvim" },
  ---DataViewer (csv, tsv ...)
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/vidocqh/data-viewer.nvim" },
  ---Otter: spawns lsp-server for injected languages
  { src = "https://github.com/jmbuhr/otter.nvim" },
})


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

require("plugins.snacks")
require("plugins.coding_helper")
require("plugins.treesitter")
require("plugins.completion")
require("plugins.dap")
require("plugins.databases")
require("plugins.markdown")
require("plugins.ufo")

-- TODO: fix
-- require("plugins.webdev")

---- Lint (Nvim-Lint) & Format (Conform)
---
-- "mfussenegger/nvim-lint", event = "InsertEnter"
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
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
})

---Formatter (Conform)
-- "stevearc/conform.nvim", event = { "BufWritePre" }, cmd = { "Format", "ConformInfo" }
vim.api.nvim_create_autocmd("BufWritePre", {
  once = true,
  callback = function()
    local conform = require "conform"
    local o = {}
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

    vim.keymap.set("n", "<leader>lf", function()
      conform.format { async = true, lsp_fallback = true }
    end, { desc = "Format <buf>", })
    require("lib").user_command_toggle("ToggleAutoFormat", "disable_autoformat", {
      title = "Auto-Format (on-save)",
      desc = "AutoFormat (on-save)",
    })
  end
})

---- end Lint (Nvim-Lint) & Format (Conform)

---- Language specific plugins ----

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = { "scala", "sbt" },
  callback = function()
    ---Scala
    vim.pack.add { "https://github.com/scalameta/nvim-metals" }
  end
})

local function hooks(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  vim.print(name, kind)

  if (kind == "install" or kind == "update") then
    vim.cmd.packadd({ args = { name }, bang = false })
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

  -- -- Run build script after plugin's code has changed
  -- if name == 'plug-1' and (kind == 'install' or kind == 'update') then
  --   vim.system({ 'make' }, { cwd = ev.data.path })
  -- end
  --
  -- -- If action relies on code from the plugin (like user command or
  -- -- Lua code), make sure to explicitly load it first
  -- if name == 'plug-2' and kind == 'update' then
  --   if not ev.data.active then
  --     vim.cmd.packadd('plug-2')
  --   end
  --   vim.cmd('PlugTwoUpdate')
  --   require('plug2').after_update()
  -- end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "go",
  callback = function()
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
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = { "markdown", "quarto" },
  callback = function()
    require("render-markdown").setup {
      -- keys = {
      --   {
      --     "<localleader>r",
      --     { "markdown", "quarto" },
      --     desc = "Render Markdown",
      --   },
      -- },
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

    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "TabLine" })
  end
})
---- end Language specific plugins ----