-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 03 Dec 2023, 10:48
-------------------------------------

local function parsers_to_be_installed()
  if vim.fn.has "mac" ~= 1 then
    return {}
  else
    return {
      "c", "comment", "cpp", "css", "dot", "dockerfile", "bash", "gitignore",
      "gitattributes", "gitcommit", "git_rebase", "go", "vimdoc", "html", "http",
      "json", "json5", "jsdoc", "latex", "erlang", "ruby", "lua", "java", "javascript",
      "markdown", "markdown_inline", "ocaml", "php",
      "python", "regex", "python", "phpdoc", "scheme", "sql", "swift",
      "todotxt", "vim", "yaml", "ini",
    }
  end
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    cmd = { "Inspect", "InspectTree" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      -- "windwp/nvim-ts-autotag",
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
        end
      },
    },
    opts = function(_, o)
      o.ensure_installed = parsers_to_be_installed()
      o.sync_install = false -- install languages synchronously (only applied to `ensure_installed`)
      o.ignore_install = {}

      o.highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = { "markdown" },
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

          return ok and (stats and stats.size > max_filesize) or
          #vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] > 1000
        end
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
          -- "css",
          "python",
          -- "yaml",
        },
      }
      o.autotag = {
        enable = false,
        disable = {},
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
            goto_definition = false,
            goto_definition_lsp_fallback = "gd",
            list_definitions = "gD",
            list_definitions_toc = "gO",
            goto_next_usage = "<C-n>",
            goto_previous_usage = "<C-p>",
          },
        },
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
    end,

    config = function(_, o)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(o)

      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          css = "/* %s */",
        }
      })

      vim.api.nvim_create_user_command("Inspect", function()
        vim.show_pos()
      end, { desc = "Inspect" })
      vim.api.nvim_create_user_command("InspectTree", function()
        vim.treesitter.inspect_tree()
      end, { desc = "InspectTree" })
    end
  },
}

return M