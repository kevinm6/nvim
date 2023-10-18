-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 25 Oct 2023, 12:01
-------------------------------------

local M = {
   "akinsho/toggleterm.nvim",
   cmd = {
      "ToggleTerm",
      "Git",
      "TermExec",
      "TermSelect",
      "ToggleTermToggleAll",
      "Ncdu",
      "Htop",
      "GHDash",
   },
   keys = {
      { "<leader>t", desc = "Terminal" },
      {
         "<leader>tt",
         function()
            vim.cmd.Htop()
         end,
         desc = "Htop",
      },
      {
         "<leader>tl",
         function()
            vim.cmd.Git()
         end,
         desc = "LazyGit",
      },
      {
         "<leader>tn",
         function()
            vim.cmd.Ncdu()
         end,
         desc = "Ncdu",
      },
      {
         "<leader>tf",
         function()
            vim.cmd.ToggleTerm "direction=float"
         end,
         desc = "Float",
      },
      {
         "<leader>th",
         function()
            vim.cmd.ToggleTerm "direction=horizontal"
         end,
         desc = "Horizontal",
      },
      {
         "<leader>tv",
         function()
            vim.cmd.ToggleTerm "direction=vertical"
         end,
         desc = "Vertical",
      },
      {
         "<leader>ts",
         function()
            vim.cmd.ToggleTermSendCurrentLine()
         end,
         desc = "Send current line",
         noremap = true,
      },
   },
   opts = function(_, o)
      o.size = function(term)
         if term.direction == 'horizontal' then
            return math.floor(vim.o.lines * 0.3)
         elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
         end
      end
      o.open_mapping = [[<c-\>]]
      o.hide_numbers = true
      o.shade_filetypes = {}
      o.shade_terminals = true
      o.shading_factor = 2
      o.start_in_insert = true
      o.insert_mappings = true
      o.persist_size = false
      o.direction = 'horizontal'
      o.close_on_exit = true
      o.shell = vim.o.shell
      o.auto_scroll = true
      o.float_opts = {
         border = 'curved',
         winblend = 6,
         highlights = {
            border = 'Normal',
            background = 'Normal',
         },
      }
      o.winbar = {
         enabled = false,
         name_formatter = function(term)
            return term.name
         end,
      }
   end,
}


function M.config(_, o)
   require("toggleterm").setup(o)

   local Terminal = require("toggleterm.terminal").Terminal

   local lazygit = Terminal:new { cmd = "lazygit", hidden = true, direction = 'float', count = 3 }
   vim.api.nvim_create_user_command("Git", function() lazygit:toggle() end, {
      desc = "LazyGit",
      force = true,
   })

   local lazydocker = Terminal:new { cmd = 'lazygit', hidden = true, count = 3 }
   vim.api.nvim_create_user_command('Docker', function() lazydocker:toggle() end, {
      desc = 'Docker',
      force = true,
   })

   local gh_dash = Terminal:new { cmd = "gh dash", hidden = true, direction = 'float' }
   vim.api.nvim_create_user_command('GHDash', function() gh_dash:toggle() end, {
      desc = "GHDash",
      force = true
   })

   local htop = Terminal:new { cmd = 'htop', hidden = true }
   vim.api.nvim_create_user_command('Htop', function() htop:toggle() end, {
      desc = 'HTOP',
      force = true,
   })

   local ncdu = Terminal:new { cmd = 'ncdu', hidden = true }
   vim.api.nvim_create_user_command('Ncdu', function() ncdu:toggle() end, {
      desc = 'NCDU',
      force = true,
   })

   vim.keymap.set("n",
      "<leader>t1",
      function()
         vim.cmd "1ToggleTerm"
      end,
      { desc = "Term 1" }
   )
   vim.keymap.set("n",
      "<leader>t2",
      function()
         vim.cmd "2ToggleTerm"
      end,
      { desc = "Term 2" }
   )
   vim.keymap.set("n",
      "<leader>t3",
      function()
         vim.cmd "3ToggleTerm"
      end,
      { desc = "Term 3" }
   )
   vim.keymap.set("n",
      "<leader>t4",
      function()
         vim.cmd "4ToggleTerm"
      end,
      { desc = "Term 4" }
   )
end

return M
