-------------------------------------
--  File         : init.lua
--  Description  : plugin init scheme
--  Author       : Kevin
--  Last Modified: 05 Feb 2023, 15:43
-------------------------------------

local M =  {
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  { "tweekmonster/startuptime.vim", cmd = "StartupTime", enabled = false },
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true }
  },

  {
    "kevinm6/knvim-theme.nvim",
    dev = true,
    lazy = false,
    priority = 100,
    config = function()
      local has_theme, knvim = pcall(require, "knvim")
      if not has_theme then
        vim.notify(("%s:\n%s"):format("Error loading theme < knvim >", knvim), "Info")
      end
      require "knvim".setup()
    end
  },


  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
     { mode = "n", "<leader>Z", function() vim.cmd.ZenMode() end, desc = "Zen" },
    },
    opts = {
      window = {
        backdrop = 1,
        height = 0.8, -- height of the Zen window
        width = 0.85,
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = true, -- disable cursorline
        },
      },
      plugins = {
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false },
        twilight = { enabled = true },
      },
    }
  },

  {
    "kevinm6/hologram.nvim",
    dev = true,
    ft = { "md", "markdown" },
    opts = { auto_display = true }
  },

  {
    "simrat39/inlay-hints.nvim",
    -- ft = { "java", "go", "lua" },
    opts = {
        only_current_line = true,
        eol = { right_align = true }
    }
  },

  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    opts = {
      ["icons"] = { "ﱢ", "" },
      -- ["icons"] = { "ﱢ", "" },
      -- ["icons"] = { "ﮊ", "" },
      -- ["icons"] = { "", "ﰕ" },
      -- ["icons"] = { "", "" },
      -- ["icons"] = { "", "" },
    },
    --  keys = {
    --     { mode = "n", "<leader>Cc", function() vim.cmd.PickColor end, desc = "PickColor" },
    --     { mode = "n", "<leader>Ci", function() vim.cmd.PickColorInsert end, desc = "PickColorInsert" },
    --  },
  },

  {
    "ellisonleao/glow.nvim",
    ft = { "md", "markdown" },
    cmd = "Glow",
    opts = {
      glow_install_path = "~/.local/bin/glow/", -- default path for installing glow binary
      border = "rounded", -- floating window border config
      style = "dark", -- filled automatically with your current editor background, you can override using glow json style
      pager = false,
      -- width = 120,
    },
  },

  {
    "br1anchen/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = {{ "*" }, {
      RGB = true,          -- #RGB hex codes
      RRGGBB = true,       -- #RRGGBB hex codes
      names = true,        -- "Name" codes like Blue oe blue
      RRGGBBAA = false,    -- #RRGGBBAA hex codes
      rgb_fn = false,      -- CSS rgb() and rgba() functions
      hsl_fn = false,      -- CSS hsl() and hsla() functions
      css = false,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
                           -- Available modes: foreground, background, virtualtext
      mode = "background", -- Set the display mode.)
    }}
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    cmd = "IndentBlanklineToggle",
    init = function()
      vim.opt.list = false
      vim.opt.listchars = {}
    end,
    opts = {
      show_current_context = true,
      show_current_context_start = true,
      show_end_of_line = false,
      show_trailing_blankline_indent = false
    }
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "java"
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    }
  },

  -- Json
  {
    "b0o/SchemaStore.nvim",
    ft = "json",
  },

  {
    "sunaku/vim-dasht",
    cmd = "Dasht"
  },

  {
    "fladson/vim-kitty",
    ft = "kitty"
  },

  {
    "makerj/vim-pdf",
    ft = "pdf",
  },

  {
    "jpalardy/vim-slime",
    -- event = "BufAdd",
    keys = {
      { "<leader>Cc", function() vim.cmd.SlimeSendCurrentLine {} end, remap = true, silent = true, desc = "Send Cell" },
      { "<leader>Cv", function() vim.cmd.SlimeParagraphSend {} end, remap = true, silent = true, desc = "Send Paragraph" },
    },
  },

  -- Coding Helper
  {
    "folke/trouble.nvim",
    enabled = false,
    cmd = "TroubleToggle",
    --  keys = {
    --  	{ mode = "n", "<leader>lt", function() vim.cmd.TodoTrouble {} end, desc = "TodoTrouble" },
    --  	{ mode = "n", "<leader>lT", function() vim.cmd.TodoTelescope {} end, desc = "Todo in Telescope" }
    --  }
  },
}

return M
