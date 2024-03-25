-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 20 Mar 2024, 09:45
-------------------------------------

local M = {
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  {
    "kevinm6/kurayami.nvim",
    lazy = false,
    dev = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('kurayami')
    end
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = function(_, o)
      o.window = {
        backdrop = 1,
        height = 0.8, -- height of the Zen window
        width = 0.85,
        options = {
          signcolumn = "no",      -- disable signcolumn
          number = false,         -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = true,      -- disable cursorline
        },
      }
      o.plugins = {
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false },
        twilight = { enabled = true },
      }
    end,
  },

  {
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki", "image_nvim", "png", "jpeg", "jpg", "image_nvim" },
    init = function()
      package.path = package.path ..
      ";" .. vim.env.HOME .. "/.luarocks/share/lua/5.1/?/init.lua"
      package.path = package.path .. ";" .. vim.env.HOME ..
      "/.luarocks/share/lua/5.1/?.lua"
    end,
    opts = function(_, o)
      o.backend = "kitty"
      o.window_overlap_clear_enabled = true    -- toggles images when windows are overlapped
      o.editor_only_render_when_focused = true -- auto show/hide images when the editor gains/looses focus
      o.window_overlap_clear_ft_ignore = {}
      o.integrations = {
        markdown = {
          enabled = true,
          sizing_strategy = "auto",
          download_remote_images = true,
          clear_in_insert_mode = true,
          only_render_image_at_cursor = true,
          filetypes = { "markdown", "vimwiki", "quarto" }
        }
      }
      o.hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" } -- render image files as images when opened
    end
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- latest release (not commit)
    event = {
      "BufReadPre " ..
      vim.fn.expand "~" ..
      "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**/*.md",
      "BufNewFile " ..
      vim.fn.expand "~" ..
      "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**/*.md",
      -- "BufReadPre "..vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/daily/*.md",
      -- "BufNewFile "..vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/daily/*.md",
      -- "BufReadPre "..vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/uni/*.md",
      -- "BufNewFile "..vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/uni/*.md",
    },
    dependencies = { "plenary.nvim" },
    opts = function(_, o)
      o.notes_subdir = "notes"
      o.notes_subdir = "notes_subdir"
      o.preferred_link_style = "markdown"
      o.disable_frontmatter = true

      o.daily_notes = {
        folder = "daily",
        date_format = "%d-%M-%Y",
        alias_format = "%-d %B, %Y"
      }

      o.workspaces = {
        {
          name = "personal",
          path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/notes",
        },
        {
          name = "uni",
          path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/uni",
        },
      }

      o.mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true }
        },
        ["<localleader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true }
        }
      }
    end
  },

  -- Jupyter Notebook
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    -- config = true,
    event = { "VeryLazy", "BufReadPre *.ipynb", "BufNewFile *.ipynb" },
    config = function(_, o)
      o.custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = true
        }
      }
      require "jupytext".setup(o)
    end
    -- "goerz/jupytext.vim",
    -- lazy = false,
    -- ft = { "jupyter_notebook" },
    -- init = function()
    --    vim.g.jupytext_enable = 1
    --    vim.g.jupytext_command = 'jupytext'
    --    vim.g.jupytext_fmt = 'md'
    --    vim.g.jupytext_to_ipynb_opts = '--to=ipynb --update'
    -- end
  },
  {
    "benlubas/molten-nvim",
    -- event = { "BufWriteFile ".. vim.fn.expand (vim.b.jupyter_file) },
    event = { "BufReadPre *.ipynb", "BufNewFile *.ipynb" },
    ft = { "qmd", "jupyter_notebook" },
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
    end,
    config = function()
      -- local venv = os.getenv "VIRTUAL_ENV" or vim.fn.stdpath "data".."/python_nvim_venv/bin/python3"
      -- if venv ~= nil and not vim.g.molten_initialized then
      --    venv = tostring(vim.fn.fnamemodify(venv, ":t"))
      --    vim.cmd(string.format("MoltenInit %s", venv))
      -- end

      vim.keymap.set("n", "<localleader>R", ":MoltenEvaluateOperator<CR>",
        { silent = true, noremap = true, desc = "run operator selection" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
        { silent = true, noremap = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>rc", ":MoltenReevaluateCell<CR>",
        { silent = true, noremap = true, desc = "re-evaluate cell" })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, noremap = true, desc = "evaluate visual selection" })

      vim.keymap.set("n", "<leader>M", function() end, { desc = "Molten" })
      vim.keymap.set("n", "<leader>MI", function() vim.cmd.MoltenInfo() end,
        { desc = "MoltenInfo" })
      vim.keymap.set("n", "<leader>Ml", function() vim.cmd.MoltenEvaluateLine() end,
        { desc = "MoltenEvaluateLine" })
      vim.keymap.set("v", "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "MoltenEvaluateVisual" })
      vim.keymap.set("n", "<leader>Ma", function() vim.cmd.MoltenEvaluateArgument() end,
        { desc = "MoltenEvaluateArgument" })
      vim.keymap.set("n", "<leader>Mo", function() vim.cmd.MoltenEvaluateOperator() end,
        { desc = "MoltenEvaluateOperator" })
      vim.keymap.set("n", "<leader>Mc", function() vim.cmd.MoltenReevaluateCell() end,
        { desc = "MoltenReevaluateCell" })

      -- vim.g.molten_initialized = true
    end
  },
  {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "html", "javascript", "typescript" },
    dependencies = { "nvim-lspconfig" },
    config = function(_, o)
      require("otter").setup(o)

      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "html",
        callback = function()
          require("otter").activate({ 'javascript', 'php', 'css' })
        end
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "javascript",
        callback = function()
          require("otter").activate({ 'html', 'php', 'regex' })
        end
      })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "php",
        callback = function()
          require("otter").activate({ 'html', 'javascript' })
        end
      })

      local nmap = function(tbl)
        vim.keymap.set("n", tbl[1], tbl[2], { desc = "otter:"..tbl[3], buffer = true })
      end
      nmap { "<localleader>K", require "otter".ask_hover, "Hover" }
      nmap { "<localleader>r", require "otter".ask_references, "[r]eferences" }
      nmap { "<localleader>R", require "otter".ask_rename, "[R]ename" }
      nmap { "<localleader>d", require "otter".ask_definition, "[d]efinition" }
      nmap { "<localleader>s", require "otter".ask_type_definition, "[t]ype-definition" }
      nmap { "<localleader>f", require "otter".ask_format, "[f]ormat" }

      nmap { "<localleader>ee", require "otter".export, "[e]xport" }
      nmap { "<localleader>ea", require "otter".export_otter_as, "[e]xport otter [a]s" }
    end
  },
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = { "otter.nvim" },
    config = function(_, o)
      local quarto = require "quarto"
      o.codeRunner = {
        enabled = false,
        default_method = 'molten',
        ft_runners = { python = "molten", markdown = 'molten' },
        never_run = { "yaml" }
      }
      quarto.setup(o)

      vim.keymap.set("n", "<localleader>qa", function()
        quarto.activate()
      end, { silent = true, desc = "[q]uarto [a]activate" })
      vim.keymap.set("n", "<localleader>qp", function()
        quarto.quartoPreview()
      end, { silent = true, desc = "[q]uarto [p]review" })
      vim.keymap.set("n", "<localleader>qP", function()
        quarto.quartoClosePreview()
      end, { silent = true, desc = "[q]uarto close [P]review" })
      vim.keymap.set("n", "<localleader>qh", function()
        quarto.searchHelp()
      end, { silent = true, desc = "[q]uarto search [h]elp" })

      vim.keymap.set("n", "<localleader>K", function()
        require "otter".ask_hover()
      end, { silent = true, desc = "Hover" })
      vim.keymap.set("n", "<localleader>gd", function()
        require "otter".ask_definition()
      end, { silent = true, desc = "[g]oto [d]efinition " })
      vim.keymap.set("n", "<localleader>r", function()
        require "otter".ask_rename()
      end, { silent = true, desc = "[g]oto [r]eferences" })
      vim.keymap.set("n", "<localleader>gt", function()
        require "otter".ask_type_definition()
      end, { silent = true, desc = "[g]oto [t]ype definition" })
      vim.keymap.set("n", "<localleader>R", function()
        require "otter".ask_rename()
      end, { silent = true, desc = "[R]ename" })
      vim.keymap.set("n", "<localleader>ds", function()
        require "otter".ask_document_symbols()
      end, { silent = true, desc = "[d]ocument [s]ymbols" })
    end
  },

  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    opts = {
      ["icons"] = { "", "" },
      ["border"] = "rounded",
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    config = true,
  },

  {
    "simrat39/symbols-outline.nvim",
    enabled = false,
    event = "LspAttach",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    keys = {
      {
        "<leader>lO",
        function()
          require("symbols-outline").toggle_outline()
        end,
        desc = "Symbols Outline",
      },
    },
    opts = function(_, o)
      local icons = require "lib.icons"
      o.symbols = {
        File = { icon = icons.kind.File, hl = "@text.uri" },
        Module = { icon = icons.kind.Module, hl = "@namespace" },
        Namespace = { icon = icons.kind.Namespace, hl = "@namespace" },
        Package = { icon = icons.ui.Package, hl = "@namespace" },
        Class = { icon = icons.kind.Class, hl = "@type" },
        Method = { icon = icons.kind.Method, hl = "@method" },
        Property = { icon = icons.kind.Property, hl = "@method" },
        Field = { icon = icons.kind.Field, hl = "@field" },
        Constructor = { icon = icons.kind.Constructor, hl = "@constructor" },
        Enum = { icon = icons.kind.Enum, hl = "@type" },
        Interface = { icon = icons.kind.Interface, hl = "@type" },
        Function = { icon = icons.kind.Function, hl = "@function" },
        Variable = { icon = icons.kind.Variable, hl = "@constant" },
        Constant = { icon = icons.kind.Constant, hl = "@constant" },
        String = { icon = icons.type.String, hl = "@string" },
        Number = { icon = icons.type.Number, hl = "@number" },
        Boolean = { icon = icons.type.Boolean, hl = "@boolean" },
        Array = { icon = icons.type.Array, hl = "@constant" },
        Object = { icon = icons.type.Object, hl = "@type" },
        Key = { icon = icons.kind.Keyword, hl = "@type" },
        Null = { icon = icons.kind.Null, hl = "@type" },
        EnumMember = { icon = icons.kind.EnumMember, hl = "@field" },
        Struct = { icon = icons.kind.Struct, hl = "@type" },
        Event = { icon = icons.kind.Event, hl = "@type" },
        Operator = { icon = icons.kind.Operator, hl = "@operator" },
        TypeParameter = { icon = icons.kind.TypeParameter, hl = "@parameter" },
        Component = { icon = icons.kind.Field, hl = "@function" },
        Fragment = { icon = icons.kind.Field, hl = "@constant" },
      }
    end
  },



  -- data viewer (csv, tsv ...)
  {
    'vidocqh/data-viewer.nvim',
    ft = { "sqlite", "tsv", "csv" },
    cmd = { "DataViewerFocusTable", "DataViewer" },
    dependencies = { "plenary.nvim" },
    config = function(_, o)
      require "data-viewer".setup(o)

      vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
      vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
      vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
      vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
    end
  },

  {
    "apple/pkl-neovim",
    ft = "pkl"
  }
}

return M