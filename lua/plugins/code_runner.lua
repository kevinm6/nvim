---------------------------------------
--  File         : code_runner.lua
--  Description  : code_runner plugin config
--  Author       : Kevin
--  Last Modified: 03 Jan 2023, 09:37
---------------------------------------

local M = {
  "CRAG666/code_runner.nvim",
  -- event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  keys = {
    { '<leader>Rr', function() vim.cmd.RunCode() end, silent = false, desc = "RunCode" },
    { '<leader>Rf', function() vim.cmd.RunFile() end, silent = false, desc = "RunFile" },
    { '<leader>Rft', ":RunFile tab<CR>", silent = false , desc = "RunFile"},
    { '<leader>Rp', function() vim.cmd.RunProject() end, silent = false, desc = "RunProject" },
    { '<leader>Rc', function() vim.cmd.RunClose() end, silent = false, desc = "RunClose" },
  }
}

function M.config()
  local cr = require "code_runner"
  cr.setup {
    mode = "float", -- {"toggle", "float", "tab", "toggleterm", "buf"}
    focus = false,
    term = {
      --  Position to open the terminal, this option is ignored if mode is tab
      position = "bot",
      -- window size, this option is ignored if tab is true
      size = 8,
    },
    float = {
      -- Key that close the code_runner floating window
      close_key = '<ESC>',
      -- Window border (see ':h nvim_open_win')
      border = "none",

      -- Num from `0 - 1` for measurements
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,

      -- Highlight group for floating window/border (see ':h winhl')
      border_hl = "FloatBorder",
      float_hl = "Normal",

      -- Transparency (see ':h winblend')
      blend = 8,
    },
    filetype = {
      java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
      python = "python3 -u",
      typescript = "deno run",
      rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
      cpp = "g++ % -o $fileBase && ./$fileBase",
      c = "gcc % -o $fileBase && ./$fileBase",
      go = "go run %",
      sh = "sh %",
      markdown = "glow %",
      javascript = "node %",
      ocaml = "ocaml %",
      -- typescript = "deno run %",
    }
  }
end

return M
