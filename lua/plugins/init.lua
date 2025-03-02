-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 17 Nov 2024, 10:50
-------------------------------------

local M = {
  "nvim-lua/plenary.nvim",

  ---Colorscheme
  {
    "kevinm6/kurayami.nvim",
    lazy = false,
    dev = true,
    priority = 1000,
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      vim.cmd.colorscheme "kurayami"
    end,
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

  ---UI-lib used by other plugins
  "MunifTanjim/nui.nvim",

  ---Image in NeoVim
  {
    "3rd/image.nvim",
    cond = false,
    -- pin = true, -- DON'T update for now -> https://github.com/3rd/image.nvim/issues/191
    -- dev = true,
    ft = { "markdown", "vimwiki", "png", "jpeg", "jpg", "image_nvim" },
    opts = function(_, o)
      o.backend = "kitty"
      o.processor = "magick_cli"
      o.window_overlap_clear_enabled = true -- toggles images when windows are overlapped
      -- o.editor_only_render_when_focused = true -- auto show/hide images when the editor gains/looses focus
      o.window_overlap_clear_ft_ignore = {}
      o.integrations = {
        markdown = {
          enabled = true,
          sizing_strategy = "auto",
          download_remote_images = true,
          clear_in_insert_mode = true,
          only_render_image_at_cursor = true,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
      }
      o.hijack_file_patterns = { "*.svg", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" } -- render image files as images when opened
    end,
  },

  ---Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- latest release (not commit)
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**.md",
    },
    opts = function(_, o)
      o.preferred_link_style = "markdown"
      o.open_app_foreground = true
      o.ui = { -- using `markdown.nvim`
        enable = false,
        -- checkboxes = {},
        -- bullets = {},
        -- external_link_icon = {},
      }
      -- o.disable_frontmatter = false
      o.daily_notes = {
        folder = "04 Daily",
        date_format = "%a, %d %b %Y",
        alias_format = "%-d %B, %Y",
      }
      o.workspaces = {
        {
          name = "personal",
          path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/*Main",
        },
        {
          name = "work",
          path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/*Work",
        },
        {
          name = "uni",
          path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/*Uni",
        },
      }
      o.templates = {
        folder = "101 templates",
        date_format = "%a, %d %b %Y",
        time_format = "HH:mm",
      }
      o.mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = "Obsidian❭ GoTo File" },
        },
        ["<C-cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { expr = true, buffer = true, desc = "Obsidian❭ Smart Action" },
        },
      } -- disable default mappings of plugin
      o.attachments = {
        img_folder = "_assets/",
      }
      o.note_path_func = function(spec)
        return string.format("%s.md", spec.title)
      end

      o.note_frontmatter_func = function(note)
        local out = {
          title = note.title,
          created = note.created or os.date "%a, %d %b %Y",
          modified = note.modified or os.date "%a, %d %b %Y",
          tags = note.tags,
        }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end

      o.image_name_func = function()
        local img_name = vim.fn.input { prompt = "Image name (avoid spaces): " }
        return img_name
      end

      -- vim.keymap.set("n", "gf", function()
      --   return require("obsidian").util.gf_passthrough()
      -- end, { noremap = false, expr = true, buffer = true, desc = "Obsidian❭ GoTo File" })
      vim.keymap.set("n", "<localleader>Oc", function()
        return require("obsidian").util.toggle_checkbox()
      end, { buffer = true, desc = "Obsidian❭ Checkbox" })
      vim.keymap.set("n", "<localleader>Oq", function()
        return vim.cmd.ObsidianQuickSwitch()
      end, { buffer = true, desc = "Obsidian❭ QuickSwitch" })
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
    event = { "BufReadPre *.ipynb", "BufNewFile *.ipynb" },
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
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
    end,
    config = function()
      vim.keymap.set(
        "n",
        "<localleader>R",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, noremap = true, desc = "run operator selection" }
      )
      vim.keymap.set(
        "n",
        "<localleader>rl",
        ":MoltenEvaluateLine<CR>",
        { silent = true, noremap = true, desc = "evaluate line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>rc",
        ":MoltenReevaluateCell<CR>",
        { silent = true, noremap = true, desc = "re-evaluate cell" }
      )
      vim.keymap.set(
        "v",
        "<localleader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, noremap = true, desc = "evaluate visual selection" }
      )

      vim.keymap.set("n", "<leader>M", function() end, { desc = "Molten" })
      vim.keymap.set("n", "<leader>MI", function()
        vim.cmd.MoltenInfo()
      end, { desc = "MoltenInfo" })
      vim.keymap.set("n", "<leader>Ml", function()
        vim.cmd.MoltenEvaluateLine()
      end, { desc = "MoltenEvaluateLine" })
      vim.keymap.set("v", "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "MoltenEvaluateVisual" })
      vim.keymap.set("n", "<leader>Ma", function()
        vim.cmd.MoltenEvaluateArgument()
      end, { desc = "MoltenEvaluateArgument" })
      vim.keymap.set("n", "<leader>Mo", function()
        vim.cmd.MoltenEvaluateOperator()
      end, { desc = "MoltenEvaluateOperator" })
      vim.keymap.set("n", "<leader>Mc", function()
        vim.cmd.MoltenReevaluateCell()
      end, { desc = "MoltenReevaluateCell" })
    end,
  },

  ---Otter
  ---spawns lsp-server for injected languages
  {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "markdown", "html", "javascript", "typescript" },
    opts = function(_, o)
      o.buffers = { set_filetype = true }

      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "html",
        callback = function()
          require("otter").activate { "javascript", "php", "css" }
        end,
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "javascript",
        callback = function()
          require("otter").activate { "html", "php", "regex" }
        end,
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "php",
        callback = function()
          require("otter").activate { "html", "javascript" }
        end,
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "qmd", "quarto" },
        callback = function()
          require("otter").activate { "quarto", "markdown", "python" }
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