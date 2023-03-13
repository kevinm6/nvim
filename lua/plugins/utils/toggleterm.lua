-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 15 Mar 2023, 13:25
-------------------------------------

local M = {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "Git" },
  keys = {
    { "<leader>t", desc = "Terminal" },
    { "<leader>t1", function() vim.cmd "1ToggleTerm" end, desc = "Term 1"  },
    { "<leader>t2", function() vim.cmd "2ToggleTerm" end, desc = "Term 2"  },
    { "<leader>t3", function() vim.cmd "3ToggleTerm" end, desc = "Term 3"  },
    { "<leader>t4", function() vim.cmd "4ToggleTerm" end, desc = "Term 4"  },
    { "<leader>tt", function() _HTOP_TOGGLE() end, desc = "Htop" },
    { "<leader>tl", function() _LAZYGIT_TOGGLE() end, desc = "LazyGit" },
    { "<leader>tn", function() _NCDU_TOGGLE() end, desc = "Ncdu" },
    { "<leader>tf", function() vim.cmd "ToggleTerm direction=float" end, desc = "Float" },
    { "<leader>th", function() vim.cmd "ToggleTerm direction=horizontal" end,
      desc = "Horizontal" },
    { "<leader>tv", function() vim.cmd "ToggleTerm direction=vertical" end,
      desc = "Vertical" },
    { "<leader>gg", function() vim.cmd.Git {} end, desc = "LazyGit" },
  },
}

function M.config()
  local ok, tt = pcall(require, "toggleterm")
  if not ok then return end

  tt.setup {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.3
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = false,
    direction = "vertical",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = "curved",
      winblend = 6,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end
    }
  }

  local function set_terminal_keymaps()
    local opts = { buffer = 0, noremap = true }
    -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

    vim.keymap.set('n', '<leader>ts', [[<cmd>ToggleTermSendCurrentLine<CR>]], { desc = "Send current line", noremap = true })
  end

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      set_terminal_keymaps()
    end,
  })

  local Terminal = require("toggleterm.terminal").Terminal

  local lazygit = Terminal:new { cmd = "lazygit", hidden = true, count = 3 }
  function _LAZYGIT_TOGGLE()
    lazygit:toggle()
  end
  vim.api.nvim_create_user_command("Git", _LAZYGIT_TOGGLE, {
    desc = "Open lazygit inside NeoVim",
    force = true
  })

  local htop = Terminal:new { cmd = "htop", hidden = true }
  function _HTOP_TOGGLE()
    htop:toggle()
  end
  vim.api.nvim_create_user_command("Htop", _HTOP_TOGGLE, {
    desc = "Open HTOP inside NeoVim",
    force = true
  })

  local ncdu = Terminal:new { cmd = "ncdu", hidden = true }
  function _NCDU_TOGGLE()
    ncdu:toggle()
  end
  vim.api.nvim_create_user_command("Ncdu", _NCDU_TOGGLE, {
    desc = "Open NCDU inside NeoVim",
    force = true
  })

end

return M
