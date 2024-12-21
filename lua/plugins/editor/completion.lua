-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 21 Dec 2024, 14:30
-------------------------------------

return {
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
          min_width = 24,
        },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          scrollbar = false,
          draw = {
            treesitter = { "lsp" },
            -- columns = { { "label" }, { "label_description" }, { "kind_icon" }, { "kind" } },
            columns = { { "label" }, { "label_description" }, { "kind_icon", gap = 1, "kind" } },
            -- components = {
            --   label = { width = { fill = false } },
            --   label_description = { width = { fill = false } },
            --   kind = { width = { fill = true } },
            -- },
            -- components = {
            -- label = { width = { fill = false, max = 32 } },
            -- label_description = { ellipsis = true, width = { fill = false } },
            -- kind_icon = {
            --   text = function(ctx)
            --     local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
            --     return kind_icon
            --   end,
            --   highlight = function(ctx)
            --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
            --     return hl
            --   end,
            -- },
            -- kind = {
            --   width = { fill = true },
            --   text = function(ctx)
            --     return ctx.kind
            --   end,
            -- },
            -- },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            min_width = 24,
            scrollbar = false,
          },
        },
        ghost_text = { enabled = true },
      },
    },
  },
  { "kevinm6/snippets", dev = true },
}
