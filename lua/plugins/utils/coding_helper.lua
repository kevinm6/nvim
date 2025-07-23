-------------------------------------
-- File         : coding_helper.lua
-- Description  : useful plugins
-- Author       : Kevin
-- Last Modified: 02/06/2025, 10:16
--  NOTE
--    Font    : Fira Code : 12.5 v|i 92, n/n 90
--    Fallback: Source Code Pro : 13 v|i 92, n/n 90
--    Symbols : Symbols (Only) Nerd Font
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
      local mini_clue = require("mini.clue")
      mini_clue.setup {
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
          mini_clue.gen_clues.builtin_completion(),
          mini_clue.gen_clues.g(),
          mini_clue.gen_clues.marks(),
          mini_clue.gen_clues.registers(),
          mini_clue.gen_clues.windows(),
          mini_clue.gen_clues.z(),

          { mode = 'n', keys = '<Leader><Leader>', desc = '❭ Buffers' },
          { mode = 'n', keys = '<Leader>n', desc = '❭ Notifications' },
          { mode = 'n', keys = '<Leader>f', desc = '❭ Find' },
          { mode = 'n', keys = '<Leader>l', desc = '❭ LSP' },
          { mode = 'n', keys = '<Leader>lw', desc = 'LSP ❭ Workspace' },
          { mode = 'n', keys = '<Leader>d', desc = '❭ DAP' },
          { mode = 'n', keys = '<Leader>g', desc = '❭ Git' },
          { mode = 'n', keys = '<Leader>t', desc = '❭ Terminal' },
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

      local mini_icons = require("mini.icons")
      mini_icons.setup {
        filetype = {
          telescope = { glyph = " " },
          dashboard = { glyph = "" },
          list = { glyph = "" },
          table = { glyph = "" },
          search = { glyph = " " },
          error = { glyph = "" },
          warning = { glyph = "" },
          information = { glyph = "" },
          question = { glyph = "" },
          hint = { glyph = "󱧢" },
          status_ok = { glyph = "" },
          status_not_ok = { glyph = "" },
          term = { glyph = " " },
          notification = { glyph = " " },
        },
        file = {
          files = { glyph = "" },
          run = { glyph = "" },
          continue = { glyph = " " },
          reload_continue = { glyph = " " },
          pause = { glyph = "" },
          stop = { glyph = " " },
          breakpoint = { glyph = "" },
          restart = { glyph = " " },
          disconnect = { glyph = " " },
          into = { glyph = "" },
          over = { glyph = " " },
          out = { glyph = "󰆸" },
          repl = { glyph = " " },
          rerun = { glyph = " " },
          eval = { glyph = " " },
          working_sym = { glyph = "⟳" },
          error_sym = { glyph = "✗" },
          done_sym = { glyph = "✓" },
          removed_sym = { glyph = "-" },
          moved_sym = { glyph = "→" },
          header_sym = { glyph = "━" },
        },
        directory = {
          branch = { glyph = " " },
          -- Change Type
          add = { glyph = "" },
          mod = { glyph = "" },
          ignore = { glyph = "" },
          remove = { glyph = "" },
          rename = { glyph = "" },
          diff = { glyph = "" },
          repo = { glyph = "" },
          -- Status Type
          unstaged = { glyph = "*" },
          staged = { glyph = "" },
          unmerged = { glyph = "" },
          untracked = { glyph = "" },
          conflict = { glyph = "" },
          ignored = { glyph = "" },
          deleted = { glyph = "✗" },
        },
        lsp = {
          nvim_lsp = { glyph = "" },
          nvim_lua = { glyph = "" },
          snippet = { glyph = "󰘦" },
          buffer = { glyph = "" },
          path = { glyph = "" },
          treesitter = { glyph = "" },
          latex_symbols = { glyph = "α" },
          emoji = { glyph = "" },
          calc = { glyph = "" },
          otter = { glyph = "⎆" },
        }

      }
      mini_icons.mock_nvim_web_devicons()
    end
  },
}