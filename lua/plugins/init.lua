-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 28/06/2025, 10:50
-------------------------------------

local M = {
  "nvim-lua/plenary.nvim",

  ---Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    init = function(p)
      vim.env.PATH = p.dir .. "/bin:" .. vim.env.PATH
    end,
    opts = {
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
    },
  },

  ---Statusline
  {
    dir = vim.fn.stdpath "config" .. "/lua/lib/ui/statusline.lua",
    virtual = true,
    event = "VeryLazy",
    cmd = "ToggleStatusline",
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      require("lib.ui.statusline").toggle()
    end,
  },

  ---Winbar
  {
    dir = vim.fn.stdpath "config" .. "/lua/lib/ui/winbar.lua",
    virtual = true,
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ToggleWinbar",
    config = function()
      require("lib.ui.winbar").toggle()
    end,
  },

  ---LaTeX
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bib" },
    config = function()
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
  },

  ---Jupyter Notebook
  {
    "GCBallesteros/jupytext.nvim",
    event = { "BufRead *.ipynb", "BufNewFile *.ipynb" },
    init = function(p)
      if vim.fn.argc() == 1 then
        local argv = tostring(vim.fn.argv(0))
        local stat = vim.uv.fs_stat(argv)

        local jupyter_notebooks = vim.endswith(argv, "ipynb")
        if stat or jupyter_notebooks then
          require("lazy").load { plugins = { p.name } }
        end
      end
      if not require("lazy.core.config").plugins[p.name]._.loaded then
        vim.api.nvim_create_autocmd("BufNew", {
          pattern = "*.ipynb",
          callback = function()
            require("lazy").load { plugins = { p.name } }
          end,
        })
      end
    end,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },

  ---Molten
  {
    "benlubas/molten-nvim",
    ft = { "qmd", "jupyter_notebook", "quarto" },
    -- version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
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
    end,
  },

  ---Otter
  ---spawns lsp-server for injected languages
  {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "markdown", "html", "javascript", "typescript" },
    opts = function()
      --[[
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "html",
        callback = function()
          require("otter").activate { "javascript", "php", "css" }
        end,
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "javascript",
        callback = function()
          require("otter").activate { "html", "php" }
        end,
      }

      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "php",
        callback = function()
          require("otter").activate { "html", "javascript" }
        end,
      })
      ]]
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "qmd", "quarto" },
        callback = function()
          require("otter").activate { "quarto", "markdown", "python" }
          vim.treesitter.language.register("markdown", "python")
          -- vim.treesitter.language.register("quarto", "markdown")
          vim.treesitter.language.register("quarto", "python")
          vim.treesitter.start()
        end,
      })
      --
    end,
  },

  ---Quarto
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    opts = function(_, o)
      o.codeRunner = {
        enabled = false,
        default_method = "molten",
        ft_runners = { python = "molten", markdown = "molten" },
        never_run = { "yaml" },
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
    end,
  },

  ---Color Picker
  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    opts = {
      ["icons"] = { "", "" },
      ["border"] = "rounded",
    },
  },

  ---Nvim colorizer
  {
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = {},
  },

  ---DataViewer (csv, tsv ...)
  {
    "vidocqh/data-viewer.nvim",
    ft = { "sqlite", "tsv", "csv" },
    cmd = { "DataViewerFocusTable", "DataViewer" },
    config = function(_, o)
      require("data-viewer").setup(o)

      vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
      vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
      vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
      vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
    end,
  },
}

return M