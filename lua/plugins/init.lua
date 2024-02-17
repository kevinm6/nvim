-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 03 Dec 2023, 10:48
-------------------------------------

local M = {
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  {
    "kevinm6/knvim.nvim",
    lazy = false,
    dev = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('knvim')
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
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = true, -- disable cursorline
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
    ft = { "markdown", "vimwiki", "image_nvim", "png", "jpeg", "jpg",  "image_nvim"  },
    init = function()
      package.path = package.path..";"..vim.env.HOME.."/.luarocks/share/lua/5.1/?/init.lua"
      package.path = package.path..";"..vim.env.HOME.."/.luarocks/share/lua/5.1/?.lua"
    end,
    opts = function(_, o)
      o.backend = "kitty"
      o.window_overlap_clear_enabled = true -- toggles images when windows are overlapped
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
    config = function ()
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
      vim.keymap.set("n", "<leader>MI", function() vim.cmd.MoltenInfo() end, { desc = "MoltenInfo" })
      vim.keymap.set("n", "<leader>Ml", function() vim.cmd.MoltenEvaluateLine() end, { desc = "MoltenEvaluateLine" })
      vim.keymap.set("v", "<leader>Mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "MoltenEvaluateVisual" })
      vim.keymap.set("n", "<leader>Ma", function() vim.cmd.MoltenEvaluateArgument() end, { desc = "MoltenEvaluateArgument" })
      vim.keymap.set("n", "<leader>Mo", function() vim.cmd.MoltenEvaluateOperator() end, { desc = "MoltenEvaluateOperator" })
      vim.keymap.set("n", "<leader>Mc", function() vim.cmd.MoltenReevaluateCell() end, { desc = "MoltenReevaluateCell" })

      -- vim.g.molten_initialized = true
    end
  },
  {
    "quarto-dev/quarto-nvim",
    ft = { "qmd" },
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          { "neovim/nvim-lspconfig" },
        },
        opts = {
          buffers = {
            -- if set to true, the filetype of the otterbuffers will be set.
            -- otherwise only the autocommand of lspconfig that attaches
            -- the language server will be executed without setting the filetype
            set_filetype = true,
          },
        },
      },
    },
    opts = function(_, o)
      o.lspFeatures = {
        languages = { "python", "bash", "lua", "html" },
      }
      o.codeRunner = {
        enabled = false,
        default_method = 'molten',
        ft_runners = { python = "molten", markdown = 'molten' }, -- filetype to runner, ie. `{ python = "molten" }`.
        -- Takes precedence over `default_method`
        never_run = { "yaml" }, -- filetypes which are never sent to a code runner
      }
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
        Fragment = { icon = icons.kind.Field, hl = "@constant" }, }
    end
  },

  -- Lua dev
  {
    "folke/neodev.nvim",
    enabled = true,
    config = true
  },

  -- focus on current code
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = true
  },

  -- data viewer (csv, tsv ...)
  {
    'vidocqh/data-viewer.nvim',
    ft = { "sqlite", "tsv", "csv" },
    cmd = { "DataViewerFocusTable", "DataViewer" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, o)
      require "data-viewer".setup(o)

      vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#4fc1ff", bold = true })
      vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#6c7986" })
      vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#626262" })
      vim.api.nvim_set_hl(0, "DataViewerFocusTable", { fg = "#00ff87", bold = true })
    end
  },

  "apple/pkl-neovim"

}

return M