-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 11/05/2025, 09:35
-------------------------------------

return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "1.*",
  opts = {
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
    },
    term = { enabled = true, keymap = { preset = "inherit" } },
    cmdline = {
      keymap = {
        ["<C-i>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "hide" },
        ["<Tab>"] = { "show_and_insert", "select_next" },
        -- ["<Tab>"] = {
        --   function(cmp)
        --     if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
        --       return cmp.accept()
        --     end
        --   end,
        --   "show_and_insert",
        --   "select_next",
        -- },
        ["<S-Tab>"] = { "show_and_insert", "select_prev" },
        ["<C-e>"] = { "cancel" },
      },
      -- completion = { menu = { auto_show = false } }
    },
  },
  appearance = {
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "snippets", "lsp", "markdown", "path", "buffer", },
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
      markdown = {
        name = "RenderMarkdown",
        module = "render-markdown.integ.blink",
      },
      -- lazydev = {
      --   name = "LazyDev",
      --   module = "lazydev.integrations.blink",
      --   -- make lazydev completions top priority (see `:h blink.cmp`)
      --   score_offset = 100,
      -- },
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
    accept = {
      auto_brackets = { enabled = true },
    },
    list = {
      selection = {
        preselect = function(ctx)
          return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
        end,
        auto_insert = function(ctx)
          return ctx.mode == "cmdline"
        end,
      },
    },
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