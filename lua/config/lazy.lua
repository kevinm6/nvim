--------------------------------------
-- File         : lazy.lua
-- Description  : Plugin Manager (Lazy) config
-- Author       : Kevin
-- Last Modified: 11 May 2024, 11:47
--------------------------------------

require("lazy").setup({
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins" },
  { import = "plugins.utils" },
  { import = "plugins.lsp.dap" },
}, {
  defaults = {
    lazy = true,
    cond = function()
      -- disable on VSC and files of NNN
      return (not vim.g.vscode) and (not vim.startswith(vim.api.nvim_buf_get_name(0), "/private/tmp/.nnn"))
    end,
  },
  dev = {
    path = "~/dev",
  },
  install = {
    missing = false,
    colorscheme = { "knvim", "default" },
  },
  change_detection = { notify = false },
  ui = {
    title = "Plugin Manager",
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
    backdrop = 80,
    icons = {
      cmd = " ",
      config = " ",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "",
      list = {
        "●",
        "→",
        "",
        "‒",
      },
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        -- "tohtml",
        "tutor",
        -- "zipPlugin",
        -- "spellfile",
      },
    },
  },
})