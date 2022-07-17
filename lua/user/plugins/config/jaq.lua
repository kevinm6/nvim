-------------------------------------
--  File         : jaq.lua
--  Description  : jaq plugin conf
--  Author       : Kevin
--  Last Modified: 16 Jul 2022, 11:51
-------------------------------------

local ok, jaq = pcall(require, "jaq-nvim")
if not ok then return end

jaq.setup {
	-- Commands used with 'Jaq'
	cmds = {
      -- Default UI used (see `Usage` for options)
     behavior = {
      -- Default type
      default     = "float",

      -- Start in insert mode
      startinsert = false,

      -- Use `wincmd p` on startup
      wincmd      = false,

      -- Auto-save files
      autosave    = false
    },
    -- Uses internal commands such as 'source' and 'luafile'
    internal = {
      lua = "luafile %",
      vim = "source %"
    },

    -- Uses external commands such as 'g++' and 'cargo'
    external = {
      cpp = "g++ % -o $fileBase && ./$fileBase",
      c = "gcc % -o $fileBase && ./$fileBase",
      go = "go run %",
      sh = "sh %",
      markdown = "glow %",
      python = "python3 %",
      typescript = "deno run %",
      javascript = "node %",
      rust = "rustc % && ./$fileBase && rm $fileBase",
    },
	},

	-- UI settings
  ui = {
    float = {
      -- See ':h nvim_open_win'
      border    = "rounded",

      -- See ':h winhl'
      winhl     = "Normal",
      borderhl  = "FloatBorder",

      -- See ':h winblend'
      winblend  = 6,

      -- Num from `0-1` for measurements
      height    = 0.8,
      width     = 0.8,
      x         = 0.5,
      y         = 0.5
    },

    terminal = {
      -- Window position
      position = "bot",

      -- Window size
      size     = 10,

      -- Disable line numbers
      line_no  = false
    },

    quickfix = {
      -- Window position
      position = "bot",

      -- Window size
      size     = 10
    }
  }
}

