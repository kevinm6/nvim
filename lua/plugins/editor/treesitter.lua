-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 17 Nov 2024, 10:49
-------------------------------------

local function parsers_to_be_installed()
  if vim.fn.has "mac" ~= 1 then
    return {}
  else
    return {
      "c",
      "comment",
      "cpp",
      "css",
      "dot",
      "dockerfile",
      "bash",
      "gitignore",
      "gitattributes",
      "gitcommit",
      "git_rebase",
      "go",
      "vimdoc",
      "html",
      "http",
      "json",
      "json5",
      "jsdoc",
      "latex",
      "ruby",
      "lua",
      "java",
      "javascript",
      "markdown",
      "markdown_inline",
      "php",
      "python",
      "regex",
      "python",
      "phpdoc",
      "scheme",
      "sql",
      "swift",
      "todotxt",
      "vim",
      "yaml",
      "ini",
    }
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    opts = {
      ensure_installed = parsers_to_be_installed(),
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      ignore_install = {},

      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = { "markdown" },
        disable = function(ft, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          local disable_ft = {
            latex = true,
          }

          if disable_ft[ft] then -- print "TS => disabled for this ft"
            return true
          end
          local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or nil
          return ok and (stats and stats.size > max_filesize) or lines and #lines > 1000
        end,
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
        disable = { "vim" }, -- useful for cedit
      },

      indent = {
        enable = true,
        -- disable = {
        --   "python",
        --   "yaml",
        -- },
      },

      refactor = {
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
      },
    },
    -- config = function(_, o)
    --   require("nvim-treesitter").setup(o)
    --   local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    --   parser_config.freemarker = {
    --   install_info = {
    --       url = "~/dev/tree-sitter-freemarker",
    --       files = { "src/parser.c" },
    --       generate_reqires_npm = true,
    --       requires_generate_from_grammar = false,
    --     },
    --   filetype = "freemarker",
    --   }
    --   vim.filetype.add { extension = {
    --   ftl = "freemarker",
    --   } }
    -- end
  },

  "nvim-treesitter/nvim-treesitter-refactor",
}
