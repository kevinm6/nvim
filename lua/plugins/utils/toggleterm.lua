-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 28 May 2023, 20:44
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
   },
   keys = {
      { "<leader>t", desc = "Terminal" },
      {
         "<leader>t1",
         function()
            vim.cmd "1ToggleTerm"
         end,
         desc = "Term 1",
      },
      {
         "<leader>t2",
         function()
            vim.cmd "2ToggleTerm"
         end,
         desc = "Term 2",
      },
      {
         "<leader>t3",
         function()
            vim.cmd "3ToggleTerm"
         end,
         desc = "Term 3",
      },
      {
         "<leader>t4",
         function()
            vim.cmd "4ToggleTerm"
         end,
         desc = "Term 4",
      },
      {
         "<leader>tt",
         function()
            _HTOP_TOGGLE()
         end,
         desc = "Htop",
      },
      {
         "<leader>tl",
         function()
            _LAZYGIT_TOGGLE()
         end,
         desc = "LazyGit",
      },
      {
         "<leader>tn",
         function()
            _NCDU_TOGGLE()
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
         "<leader>gg",
         function()
            vim.cmd.Git {}
         end,
         desc = "LazyGit",
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
      size = function(term)
         if term.direction == "horizontal" then
            return vim.o.lines * 0.3
         elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
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
      o.direction = "vertical"
      o.close_on_exit = true
      o.shell = vim.o.shell
      o.auto_scroll = true
      o.float_opts = {
         border = "curved",
         winblend = 6,
         highlights = {
            border = "Normal",
            background = "Normal",
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

local function set_terminal_keymaps(buf)
   local opts = { buffer = buf, noremap = true }
   -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
   vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
   vim.keymap.set("t", "<C-e>", [[<C-\><C-n>]], opts)
   vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<CR>]], opts)
   vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<CR>]], opts)
   vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<CR>]], opts)
   vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<CR>]], opts)
   vim.keymap.set("t", "<C-w>", [[<C-\><C-n>C-w>]], opts)
end

function M.config(_, o)
   require("toggleterm").setup(o)

   vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function(ev)
         set_terminal_keymaps(ev.buf)
      end,
   })

   local Terminal = require("toggleterm.terminal").Terminal

   local lazygit = Terminal:new { cmd = "lazygit", hidden = true, count = 3 }
   function _LAZYGIT_TOGGLE()
      lazygit:toggle()
   end

   vim.api.nvim_create_user_command("Git", _LAZYGIT_TOGGLE, {
      desc = "Open lazygit inside NeoVim",
      force = true,
   })

   local htop = Terminal:new { cmd = "htop", hidden = true }
   function _HTOP_TOGGLE()
      htop:toggle()
   end
   vim.api.nvim_create_user_command("Htop", _HTOP_TOGGLE, {
      desc = "Open HTOP inside NeoVim",
      force = true,
   })

   local ncdu = Terminal:new { cmd = "ncdu", hidden = true }
   function _NCDU_TOGGLE()
      ncdu:toggle()
   end
   vim.api.nvim_create_user_command("Ncdu", _NCDU_TOGGLE, {
      desc = "Open NCDU inside NeoVim",
      force = true,
   })
end

return M
