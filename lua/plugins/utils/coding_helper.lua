-------------------------------------
-- File         : coding_helper.lua
-- Description  : useful plugins
-- Author       : Kevin
-- Last Modified: 02/06/2025, 10:16
-------------------------------------

return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      ---Auto-Pairs
      require("mini.pairs").setup {
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "^r.", register = { cr = false } },
          [">"] = { action = "close", pair = "<>", register = { cr = false } },
        }
      }

      require("lib").user_command_toggle("ToggleAutoPairs", "minipairs_disable", {
        title = "Auto-Pairs",
        desc = "Toggle AutoPairs (mini.pairs)",
      })

      ---Surround
      require("mini.surround").setup()

      ---Align
      require("mini.align").setup()

      ---WhichKey
      local miniclue = require("mini.clue")
      require("mini.clue").setup {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),

          { mode = 'n', keys = '<Leader><Leader>', desc = '❭ Buffers' },
          { mode = 'n', keys = '<Leader>n', desc = '❭ Notifications' },
          { mode = 'n', keys = '<Leader>f', desc = '❭ Find' },
          { mode = 'n', keys = '<Leader>l', desc = '❭ LSP' },
          { mode = 'n', keys = '<Leader>lw', desc = 'LSP ❭ Workspace' },
          { mode = 'n', keys = '<Leader>d', desc = '❭ DAP' },
        },
        window = {
          config = {
            height = math.floor(vim.o.lines * 0.26),
            width = math.floor(vim.o.columns * 0.26),
            anchor = "SE",
            border = "rounded",
          },
          delay = 400
        }
      }
    end
  },
}