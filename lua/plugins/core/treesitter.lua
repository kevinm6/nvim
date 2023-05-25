-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 24 May 2023, 12:08
-------------------------------------

local M = {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            "class",
            "function",
            "method",
            "for",
            "if",
            "while",
            'switch',
            'case',
          },
        },
        exact_patterns = {},
      }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    keys = {
      { "<leader>Tp", function() vim.cmd.InspectTree {} end, desc = "TS Inspector" },
      { "<leader>Th", function() vim.cmd.Inspect {} end, desc = "TS Highlight" }
    },
    dependencies = {
       "JoosepAlviste/nvim-ts-context-commentstring",
      {
        "windwp/nvim-ts-autotag",
        ft = {
          "html", "javascript", "typescript", "javascriptreact", "typescriptreact",
          "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown",
          "glimmer", "handlebars", "hbs",
        },
        opts = {
          enable = true,
          filetypes = {
            "html", "javascript", "typescript", "javascriptreact", "typescriptreact",
            "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown",
            "glimmer", "handlebars", "hbs",
          },
        },
      },
      "p00f/nvim-ts-rainbow",
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = function()

      require "nvim-treesitter.install".prefer_git = true

      require "nvim-treesitter.configs".setup {
        ensure_installed = vim.fn.has "mac" == 1  and {
          "c", "comment", "cpp", "css", "dot", "dockerfile",
          "bash", "gitignore", "gitattributes", "gitcommit", "git_rebase", "go", "vimdoc",

          "html", "http", "json", "json5", "jsdoc", "latex", "erlang", "ruby",
          "lua", "java", "javascript", "markdown", "markdown_inline", "rust",
          "ocaml", "ocaml_interface", "php", "python", "regex", "python", "phpdoc",
          "scala", "scheme", "sql", "swift", "todotxt", "vim", "yaml", "org", "ini"
          } or {},
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = {},
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {}, -- list of language that will be disabled
          additional_vim_regex_highlighting = false,
        },
        autopairs = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
        indent = {
          enable = true,
          disable = {
            "css",
            "python",
            "yaml",
          },
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        autotag = {
          enable = true,
          filetypes = {
            'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
            'xml',
            'php',
            'glimmer','handlebars','hbs'
          },
          disable = { "xml" },
        },
        rainbow = {
          enable = true,
          colors = {
            "#c7aA6D",
            "LawnGreen",
            "Gold",
            "DodgerBlue",
            "#68a0b0",
            "Orchid",
            "Cornsilk",
            -- "Salmon",
          },
          disable = { "html" },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keymaps = {
            open = "gtd",
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        refactor = {
          highlight_definitions = {
            enable = false,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = false,
          },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "gRr",
            },
          },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = "gnd",
              list_definitions = "gnD",
              list_definitions_toc = "gO",
              goto_next_usage = "]",
              goto_previous_usage = "[",
            },
          },
        },
      }
    end
  }
}

return M
