---------------------------------------
--  File         : code_runner.lua
--  Description  : code_runner plugin config
--  Author       : Kevin
--  Last Modified: 20 Mar 2023, 13:18
---------------------------------------

local M = {
  "CRAG666/code_runner.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  keys = {
    { '<leader>Rr', function() vim.cmd.RunCode() end, silent = false, desc = "RunCode" },
    { '<leader>Rf', function() vim.cmd.RunFile() end, silent = false, desc = "RunFile" },
    { '<leader>Rt', function() vim.cmd.RunFile { args = "tab" } end, silent = false , desc = "RunFile in Tab"},
    { '<leader>Rb', function() vim.cmd.RunFile { args = "buf" } end, silent = false , desc = "RunFile in Buffer"},
    { '<leader>RT', function() vim.cmd.RunFile { args = "toggle" } end, silent = false , desc = "RunFile Toggle"},
    { '<leader>Rp', function() vim.cmd.RunProject() end, silent = false, desc = "RunProject" },
    { '<leader>Rc', function() vim.cmd.RunClose() end, silent = false, desc = "RunClose" },
  },
  opts = {
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
      border = "rounded",

      -- Num from `0 - 1` for measurements
      height = 0.6,
      width = 0.8,
      x = 0.6,
      y = 0.9,

      -- Highlight group for floating window/border (see ':h winhl')
      border_hl = "WinSeparator",
      float_hl = "Normal",

      -- Transparency (see ':h winblend')
      blend = 8,
    },
    filetype = {
      java = "cd '$dir' && javac $fileName && java $fileNameWithoutExt",
      python = "python3 -u '$file'",
      typescript = "deno run",
      rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
      cpp = "g++ % -o $fileBase && ./$fileBase",
      c = "gcc % -o $fileBase && ./$fileBase",
      go = "go run '$file'",
      sh = "sh '$file'",
      markdown = "glow '$file'",
      javascript = "node '$file'",
      ocaml = "ocaml '$file'",
      scala = "cd '$dir' && scalac $fileName && scala $fileName",
      -- typescript = "deno run %",

      -- file               -- file path to currend file opened
      -- fileName           -- file name to curren file opened
      -- fileNameWithoutExt -- file without extension file opened
      -- dir                -- path of directory to file opened
      -- end                -- finish the command (it is useful for commands that do not require final autocompletion)

      -- Below is an example of an absolute path and how it behaves depending on the variable:
      -- absolute path: /home/anyuser/current/file.py
      -- file               = /home/anyuser/current/file.py
      -- fileName           = file.py
      -- fileNameWithoutExt = file
      -- dir                = /home/anyuser/current
    }
  }
}

return M
