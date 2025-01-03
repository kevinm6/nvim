-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 03 Jan 2025, 00:25
-------------------------------------

return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v0.*",
  opts = {
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

      cmdline = {
        ["<C-i>"] = { "select_and_accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "hide" },
        ["<C-e>"] = { "cancel" },
      },
    },
    appearance = {
      nerd_font_variant = "mono",
    },

    sources = {
      default = { "snippets", "lsp", "path", "buffer", "lazydev" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
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
      },
      min_keyword_length = function(ctx)
        return ctx.mode == "cmdline" and 2 or 0
      end,
    },
    signature = {
      enabled = true,
      window = {
        max_width = math.ceil(vim.o.columns * 0.6),
        max_height = math.ceil(vim.o.lines * 0.4),
      },
    },
    completion = {
      -- keyword = {
      --  regex = "[-_/]\\|\\k",
      --  exclude_from_prefix_regex = "[\\.]",
      -- },
      accept = {
        auto_brackets = { enabled = true },
      },
      list = {
        selection = function(ctx)
          return ctx.mode == "cmdline" and "auto_insert" or "preselect"
        end,
      },
      menu = {
        scrollbar = false,
        min_width = 32,
        winblend = vim.o.pumblend,
        draw = {
          treesitter = { "lsp" },
          -- align_to = "kind_icon",
          -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
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
  },
}