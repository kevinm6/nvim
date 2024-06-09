-------------------------------------
-- File         : coding_helper.lua
-- Description  : useful plugins
-- Author       : Kevin
-- Last Modified: 31 May 2024, 13:01
-------------------------------------

return {
  ---Autopairs
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    config = function(_, o)
      o.mappings = {
        ["<"] = { action = "open", pair = "<>", neigh_pattern = "^r.", register = { cr = false } },
        [">"] = { action = "close", pair = "<>", register = { cr = false } },
      }

      require("mini.pairs").setup(o)

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
    config = true,
  },

  ---Text-Object
  {
    "echasnovski/mini.ai",
    event = { "BufRead", "BufNewFile" },
    version = false,
    config = true,
  },

  ---WhichKey
  {
    "echasnovski/mini.clue",
    event = "VeryLazy",
    version = false,
    config = function(_, o)
      local miniclue = require "mini.clue"

      o.window = {
        delay = 360,
      }
      o.triggers = {
        -- Leader triggers
        { mode = "n", keys = "<leader>" },
        { mode = "x", keys = "<leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Mark
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      }

      o.clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers { show_contents = true },
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      }
      miniclue.setup(o)

      vim.api.nvim_set_hl(0, "MiniClueSeparator", { link = "WinSeparator" })
      vim.api.nvim_set_hl(0, "MiniClueDescSingle", { fg = "#9c9c9c" })
      vim.api.nvim_set_hl(0, "MiniClueDescGroup", { link = "Identifier" })
    end,
  },
}
