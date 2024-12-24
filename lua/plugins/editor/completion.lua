-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 21 Dec 2024, 14:30
-------------------------------------

return {
  { "kevinm6/snippets", dev = true },
  {
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
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-i>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<C-S-i>"] = { "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            opts = {
              search_paths = {
                vim.fn.expand "~/dev/snippets",
              },
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          min_width = 24,
        },
      },
      completion = {
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
            -- align_to_component = "kind_icon",
            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              label = { ellipsis = true, width = { fill = true, max = 32 } },
              label_description = { ellipsis = true, width = { fill = true, max = 26 } },
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
            border = "rounded",
            direction_priority = {
              menu_north = { "e", "n", "w", "s" },
              menu_south = { "e", "n", "s", "w" },
            },
          },
        },
        ghost_text = { enabled = true },
      },
    },
  },
}
