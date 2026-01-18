-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 18 Jan 2026, 19:14
-------------------------------------

--NOTE: snippets variables
--https://code.visualstudio.com/docs/editing/userdefinedsnippets#_variables

require("blink.cmp").setup {
  fuzzy = { implementation = "prefer_rust" },
  keymap = {
    preset = "default",
    ["<Up>"] = {},
    ["<Down>"] = {},
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-l>"] = { "select_and_accept" },
    ["<C-i>"] = { "snippet_forward", "fallback" },
    ["<C-S-i>"] = { "snippet_backward", "fallback" },
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<M-l>"] = vim.g.ai_completion and require("minuet").make_blink_map() or {},
  },
  term = { enabled = true, keymap = { preset = "inherit" } },
  cmdline = {
    keymap = {
      ["<C-i>"] = { 'show_and_insert', 'select_next' },
      ['<C-S-i>'] = { 'show_and_insert', 'select_prev' },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-l>"] = { "select_and_accept", "fallback" },
      ["<C-Space>"] = { "show", "hide" },
    }
  },
  appearance = {
    nerd_font_variant = "mono",
  },

  sources = {
    -- default = { "snippets", "lsp", "path", "buffer", },
    providers = {
      buffer = {
        opts = {
          enable_in_ex_commands = true
        }
      },
      snippets = {
        opts = {
          extended_filetypes = {
            lua = { "luadoc", "nvim_lua" },
            sh = { "shelldoc" },
            java = { "javadoc", "java_tests" },
          },
        },
      },
      -- minuet = {
      --   enabled = function() return vim.g.ai_completion end,
      --   name = 'minuet',
      --   module = 'minuet.blink',
      --   async = true,
      --   -- Should match minuet.config.request_timeout * 1000,
      --   -- since minuet.config.request_timeout is in seconds
      --   timeout_ms = 3000,
      --   score_offset = 50
      -- },
      -- dbee = { name = "cmp-dbee", module = "blink.compat.source" }
    },
  },
  signature = {
    enabled = true,
    window = {
      max_width = math.ceil(vim.o.columns * 0.6),
      max_height = math.ceil(vim.o.lines * 0.4),
    },
  },
  completion = {
    trigger = { prefetch_on_insert = false }, -- Recommended to avoid unnecessary request
    accept = { auto_brackets = { enabled = true } },
    menu = {
      scrollbar = false,
      min_width = 32,
      winblend = vim.o.pumblend,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        components = {
          label = { ellipsis = true, width = { fill = true, max = 32 } },
          label_description = { ellipsis = true, width = { fill = true } },
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon
            end,
          },
        },
      },
    },
    documentation = {
      auto_show = true,
      window = {
        min_width = 24,
        scrollbar = false,
        direction_priority = {
          menu_north = { "e", "n", "w", "s" },
          menu_south = { "e", "n", "s", "w" },
        },
      },
    },
    ghost_text = { enabled = true },
  },
}