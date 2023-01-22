-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 28 Dec 2022, 19:31
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
    { "<leader>th", function() vim.cmd "ToggleTerm direction=horizontal size=16" end,
      desc = "Horizontal" },
    { "<leader>tv", function() vim.cmd "ToggleTerm direction=vertical size=80" end,
      desc = "Vertical" },
    { "<leader>gg", function() vim.cmd.Git {} end, desc = "LazyGit" },
  }
}

function M.config()
  local ok, toggleterm = pcall(require, "toggleterm")
  if not ok then return end

  toggleterm.setup({
    size = 28,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = false,
    direction = "float",
    close_on_exit = true,
    shell = "/bin/zsh",
    float_opts = {
      border = "curved",
      winblend = 6,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  })

  local function set_terminal_keymaps()
    local opts = {noremap = true}
    -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
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
