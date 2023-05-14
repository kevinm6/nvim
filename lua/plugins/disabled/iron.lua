---------------------------------------
--  File         : iron.lua
--  Description  : Interactive Repl for neovim (IRON) plugin config
--  Author       : Kevin
--  Last Modified: 13 May 2023, 11:16
---------------------------------------

local M = {
   "hkupty/iron.nvim",
   enabled = false,
   cmd = { "IronRepl", "IronFocus", "IronSend" },
   keys = {
      {
         "<leader>Rs",
         function()
            vim.cmd.IronRepl()
         end,
         desc = "Repl",
      },
      {
         "<leader>RR",
         function()
            vim.cmd.IronRestart()
         end,
         desc = "Repl restart",
      },
      {
         "<leader>RF",
         function()
            vim.cmd.IronFocus()
         end,
         desc = "Repl focus",
      },
      {
         "<leader>Rh",
         function()
            vim.cmd.IronHide()
         end,
         desc = "Repl hide",
      },
   },
}

function M.config()
   require("iron.core").setup {
      config = {
         -- Whether a repl should be discarded or not
         scratch_repl = true,
         -- Your repl definitions come here
         repl_definition = {
            sh = {
               -- Can be a table or a function that
               -- returns a table (see below)
               command = { "zsh" },
            },
         },
         -- How the repl window will be displayed
         -- See below for more information
         repl_open_cmd = require("iron.view").split.vertical.botright(50),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
         send_motion = "<space>sc",
         visual_send = "<space>sc",
         send_file = "<space>sf",
         send_line = "<space>sl",
         send_mark = "<space>sm",
         mark_motion = "<space>mc",
         mark_visual = "<space>mc",
         remove_mark = "<space>md",
         cr = "<space>s<cr>",
         interrupt = "<space>s<space>",
         exit = "<space>sq",
         clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
         italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
   }
end

return M
