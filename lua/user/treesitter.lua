-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 28/04/2022 - 12:27
-------------------------------------

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

require("nvim-treesitter.install").prefer_git = true

local parser_to_install = function ()
  if vim.fn.has "mac" == 1 then
    return "all"
  else
    return "{}" -- do not install parser for now in Manjaro-Linux
  end
end

configs.setup({
  ensure_installed = parser_to_install(),
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {},
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  autopairs = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
    disable = {
      "css",
      "python",
      "yaml",
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
    disable = { "xml" },
  },
  rainbow = {
    enable = true,
    colors = {
      "Gold",
      "Orchid",
      "DodgerBlue",
      "Cornsilk",
      -- "LawnGreen",
      -- "Salmon",
    },
    disable = { "html" },
  },
  playground = {
    enable = true,
  },
})

require("treesitter-context").setup({
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  throttle = true, -- Throttles plugin updates (may improve performance)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      "class",
      "function",
      "method",
      "for",
      "if",
      "while",
      -- 'switch',
      -- 'case',
    },
  },
  exact_patterns = {},
})
