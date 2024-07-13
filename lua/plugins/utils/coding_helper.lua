-------------------------------------
-- File         : coding_helper.lua
-- Description  : useful plugins
-- Author       : Kevin
-- Last Modified: 13 Jul 2024, 09:13
-------------------------------------

return {
  ---Autopairs
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    main = "mini.pairs",
    opts = function(_, o)
      o.mappings = {
        ["<"] = { action = "open", pair = "<>", neigh_pattern = "^r.", register = { cr = false } },
        [">"] = { action = "close", pair = "<>", register = { cr = false } },
      }

      require("lib").user_command_toggle("ToggleAutoPairs", "minipairs_disable", {
        title = "Auto-Pairs",
        desc = "Toggle AutoPairs (mini.pairs)",
      })
    end,
  },

  ---Surround
  {
    "echasnovski/mini.surround",
    version = false,
    event = { "BufRead", "BufNewFile" },
    opts = {},
  },

  ---Text-Object
  {
    "echasnovski/mini.ai",
    event = { "BufRead", "BufNewFile" },
    version = false,
    opts = {},
  },

  ---WhichKey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buf-local Keymaps",
      },
    },
    opts = {
      delay = function(ctx)
        return ctx.plugin and 0 or 300 -- delay more, open only if needed
      end,
      icons = {
        breadcrumb = "❭",
      },
      spec = {
        { "<leader>?", hidden = true },
        { "<leader>g", group = "Git" },
        { "<leader>f", group = "Telescope" },
        { "<leader>d", group = "DAP", icon = "" },
        { "<leader>l", group = "LSP", icon = "" },
        { "<leader>lw", group = "Workspace", icon = "" },
        { "z=", hidden = true }, -- using Telescope w/ ui-select
      },
      win = {
        no_overlap = false, -- avoid resizing win if cursor is on screen bottom
        border = "rounded",
        row = -1,
        padding = { 2, 2 }, -- [top/bottom, right/left]
        wo = {
          winblend = 6,
        },
      },
      layout = {
        align = "center",
      },
      show_help = false,
      show_keys = true,
      -- disable = {
      --   ft = { "oil" },
      -- },
    },
  },
}