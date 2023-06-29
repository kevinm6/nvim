-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 21 Jul 2023, 09:00
-------------------------------------

local function parsers_to_be_installed()
   local parsers = {
      "c", "comment", "cpp", "css", "dot", "dockerfile", "bash",
      "gitignore", "gitattributes", "gitcommit", "git_rebase", "go",
      "vimdoc", "html", "http", "json", "json5", "jsdoc",
      "latex", "erlang", "ruby", "lua", "java", "javascript",
      "markdown", "markdown_inline", "rust", "ocaml",
      "ocaml_interface", "php", "python", "regex", "python",
      "phpdoc", "scala", "scheme", "sql", "swift", "todotxt",
      "vim", "yaml", "org", "ini",
   }
   if vim.fn.has "mac" == 1 then return parsers else return {} end
end

local M = {
   {
      "nvim-treesitter/nvim-treesitter",
      event = "BufReadPre",
      build = ":TSUpdate",
      keys = {
         {
            "<leader>T",
            nil,
            desc = "Treesitter",
         },
         {
            "<leader>Tp",
            function()
               vim.cmd.InspectTree()
            end,
            desc = "TS Inspector",
         },
         {
            "<leader>Th",
            function()
               vim.cmd.Inspect()
            end,
            desc = "TS Highlight",
         },
      },
      dependencies = {
         "JoosepAlviste/nvim-ts-context-commentstring",
         "nvim-treesitter/nvim-treesitter-refactor",
         "nvim-treesitter/nvim-treesitter-context",
         "windwp/nvim-ts-autotag",
         {
            "HiPhish/rainbow-delimiters.nvim",
            config = function()
               local rainbow_delimiters = require "rainbow-delimiters"
               vim.g.rainbow_delimiters = {
                  strategy = {
                     [""] = rainbow_delimiters.strategy["global"],
                     vim = rainbow_delimiters.strategy["local"],
                  },
                  query = {
                     [""] = "rainbow-delimiters",
                     -- lua = "rainbow-blocks",
                  },
                  highlight = {
                     "RainbowDelimiterRed",
                     "RainbowDelimiterYellow",
                     "RainbowDelimiterBlue",
                     "RainbowDelimiterOrange",
                     "RainbowDelimiterGreen",
                     "RainbowDelimiterViolet",
                     "RainbowDelimiterCyan",
                  },
                  blacklist = { "html" },
               }
            end,
         },
      },
      opts = function(_, o)
         o.ensure_installed = parsers_to_be_installed()
         o.sync_install = false -- install languages synchronously (only applied to `ensure_installed`)
         o.ignore_install = {}
         o.highlight = {
            enable = true, -- false will disable the whole extension
            disable = {}, -- list of language that will be disabled
            additional_vim_regex_highlighting = { "markdown" },
         }
         o.autopairs = {
            enable = true,
         }
         o.incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<CR>",
               node_incremental = "<CR>",
               scope_incremental = "<S-CR>",
               node_decremental = "<BS>",
            },
         }
         o.indent = {
            enable = true,
            disable = {
               "css",
               "python",
               "yaml",
            },
         }
         o.context_commentstring = {
            enable = true,
            enable_autocmd = false,
            config = {
               css = "/* %s */"
            }
         }
         o.autotag = {
            enable = true,
            disable = {},
         }
         o.playground = {
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
         }
         o.refactor = {
            highlight_definitions = {
               enable = true,
               -- Set to false if you have an `updatetime` of ~100.
               clear_on_cursor_move = true,
            },
            highlight_current_scope = { enable = false },
            smart_rename = {
               enable = true,
               keymaps = {
                  smart_rename = "gR",
               },
            },
            navigation = {
               enable = true,
               keymaps = {
                  goto_definition_lsp_fallback = "gd",
                  list_definitions = "gD",
                  list_definitions_toc = "gO",
                  goto_next_usage = "<C-n>",
                  goto_previous_usage = "<C-p>",
               },
            },
         }
      end,

      config = function(_, o)
         require("nvim-treesitter.install").prefer_git = true
         require("nvim-treesitter.configs").setup(o)
      end,
   },
}

return M
