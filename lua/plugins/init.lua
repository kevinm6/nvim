-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 11 May 2024, 11:50
-------------------------------------

local M = {
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

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
      vim.cmd.colorscheme 'kurayami'
    end
  },

  ---Statusline
  {
    dir = vim.fn.stdpath 'config' .. "/lua/lib/ui/statusline.lua",
    event = 'VeryLazy',
    cmd = "ToggleStatusline",
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      require "lib.ui.statusline".toggle()
    end
  },

  ---Winbar
  {
    dir = vim.fn.stdpath 'config' .. "/lua/lib/ui/winbar.lua",
    event = { "BufReadPre", "BufNewFile" },
    cmd = 'ToggleWinbar',
    config = function()
      require "lib.ui.winbar".toggle()
    end
  },

  ---UI-lib used by other plugins
  "MunifTanjim/nui.nvim",

  ---ZenMode
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
          cursorline = true       -- disable cursorline
        }
      }
      o.plugins = {
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false },
        twilight = { enabled = true }
      }
    end,
  },

  ---Luarocks
  ---integrate luarocks into neovim
  {
    "vhyrro/luarocks.nvim",
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      --NOTE: for macOS replace into
      -- ~/.local/share/nvim/lazy/luarocks.nvim/.rocks/share/lua/5.1/magick/wand/lib.lua:220
      --  lib = try_to_load("/opt/homebrew/lib/libMagickWand-7.Q16HDRI.dylib", function()
      rocks = { "magick", "xml2lua", "mimetypes", "lua-curl", "promise-async" }
    }
  },

  ---Image in NeoVim
  {
    "3rd/image.nvim",
    ft = { 'markdown', 'vimwiki', 'png', 'jpeg', 'jpg', 'image_nvim' },
    dependencies = 'luarocks.nvim',
    opts = function(_, o)
      o.backend = 'kitty'
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
      o.hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp' } -- render image files as images when opened
    end
  },

  ---Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = '*', -- latest release (not commit)
    event = {
      "BufReadPre " ..
      vim.fn.expand "~" ..
      "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**/*.md",
      "BufNewFile " ..
      vim.fn.expand "~" ..
      "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main/**/*.md",
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
    event = { "BufReadPre *.ipynb", "BufNewFile *.ipynb" },
    init = function(p)
      if vim.fn.argc() == 1 then
        local argv = tostring(vim.fn.argv(0))
        local stat = vim.uv.fs_stat(argv)

        local jupyter_notebooks = vim.endswith(argv, 'ipynb')
        if stat or jupyter_notebooks then
          require "lazy".load { plugins = { p.name } }
        end
      end
      if not require("lazy.core.config").plugins[p.name]._.loaded then
        vim.api.nvim_create_autocmd('BufNew', {
          pattern = '*.ipynb',
          callback = function()
            require "lazy".load { plugins = { p.name } }
          end,
        })
      end
    end,
    config = function(_, o)
      o.custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = true
        }
      }
      require "jupytext".setup(o)
    end
  },

  ---Molten
  {
    "benlubas/molten-nvim",
    ft = { "qmd", "jupyter_notebook", "quarto" },
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "image.nvim" },
    init = function()
      vim.g.python_host_prog = vim.env.VIRTUAL_ENV or
          vim.fn.stdpath 'data' .. "/.venv/bin"

      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
    end,
    config = function()
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
    end
  },

  ---Otter
  ---spawns lsp-server for injected languages
  {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "html", "javascript", "typescript" },
    dependencies = { "nvim-lspconfig" },
    config = function(_, o)
      o.buffers = { set_filetype = true }

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
        vim.keymap.set("n", tbl[1], tbl[2], { desc = "otter:" .. tbl[3] })
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

  ---Quarto
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
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    config = true,
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

  -- {
  --   "apple/pkl-neovim",
  --   ft = "pkl",
  -- }
}

return M