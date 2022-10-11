-------------------------------------
--  File         : jaq.lua
--  Description  : jaq plugin conf
--  Author       : Kevin
--  Last Modified: 11 Oct 2022, 10:44
-------------------------------------

local has_jaq, jaq = pcall(require, "jaq-nvim")
if not has_jaq then return end

jaq.setup {
  -- Commands used with 'Jaq'
  cmds = { -- Default UI used (see `Usage` for options)
    behavior = {
      -- Default type
      default = "float",

      -- Start in insert mode
      startinsert = false,

      -- Use `wincmd p` on startup
      wincmd = false,

      -- Auto-save files
      autosave = false
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
      -- typescript = "deno run %",
      javascript = "node %",
      rust = "rustc % && ./$fileBase && rm $fileBase",
      java = "javac % && java %",
      ml = "ocaml %",
    },
  },

  -- UI settings
  ui = {
    float = {
      -- See ':h nvim_open_win'
      border = "rounded",

      -- See ':h winhl'
      winhl = "Normal",
      borderhl = "FloatBorder",

      -- See ':h winblend'
      winblend = 6,

      -- Num from `0-1` for measurements
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },

    terminal = {
      -- Window position
      position = "bot",

      -- Window size
      size = 10,

      -- Disable line numbers
      line_no = false
    },

    quickfix = {
      -- Window position
      position = "bot",

      -- Window size
      size = 10
    }
  }
}

local has_wk, wk = pcall(require, "which-key")
if not has_wk then return end

local wk_mappings = {
  j = {
    name = "Run Code (Jaq)",
    j = {
      function()
        vim.cmd [[Jaq bang]]
      end,
      "Run"
    },
    f = {
      function() vim.cmd [[Jaq float]] end,
      "Run in Float",
    },
    q = {
      function() vim.cmd [[Jaq quickfix]] end,
      "Run in Qf",
    },
    t = {
      function()
        require "toggleterm"
        vim.cmd [[Jaq toggleterm]]
      end,
      "Run in ToggleTerm",
    },
    b = {
      function() vim.cmd [[Jaq bang]] end,
      "Run with shell window",
    },
    v = {
      function()
        vim.cmd [[Jaq internal]]
      end,
      "Run Vim command",
    }
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = 0,
  silent = false,
  noremap = true,
  nowait = true,
}

local ft_patterns = {
  "*.lua",
  "*.vim",
  "*.cpp",
  "*.c",
  "*.go",
  "*.sh",
  "*.md",
  "*.py",
  "*.java",
  "*.rs",
  "*.js", "*.ts",
  "*.ml"
}

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("_jaq_wk_maps", { clear = true }),
	pattern = ft_patterns,
	callback = function() wk.register(wk_mappings, opts) end,
})
