-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 08 May 2024, 21:31
-------------------------------------

return {
  "akinsho/toggleterm.nvim",
  cmd = {
    'ToggleTerm',
    'Git',
    'TermExec',
    'TermSelect',
    'ToggleTermToggleAll',
    'Ncdu',
    'Htop',
    'GHDash',
  },
  keys = {
    { "<leader>t", desc = require 'lib.icons'.ui.term .. 'Terminal' },
    {
      "<leader>tf",
      function()
        vim.cmd.ToggleTerm 'direction=float'
      end,
      desc = '[f]loat',
    },
    {
      "<leader>th",
      function()
        vim.cmd.ToggleTerm 'direction=horizontal'
      end,
      desc = '[h]orizontal',
    },
    {
      "<leader>tv",
      function()
        vim.cmd.ToggleTerm 'direction=vertical'
      end,
      desc = '[v]ertical',
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
    o.open_mapping = [[<M-t>]]
    o.hide_numbers = true
    o.shade_filetypes = {}
    o.shade_terminals = true
    o.shading_factor = 2
    o.start_in_insert = true
    o.insert_mappings = true
    o.persist_size = false
    o.direction = 'horizontal'
    o.close_on_exit = true

    local shell = nil
    o.shell = function()
      local ft = vim.bo.filetype
      if ft == 'python' then
        shell = 'ipython'
      elseif ft == 'toggleterm' then
        return shell
      else
        shell = vim.o.shell
      end
      return shell
    end

    o.auto_scroll = true
    o.float_opts = {
      border = 'curved',
      winblend = 6,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
      title_pos = 'center'
    }
    o.winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    }
  end,
  config = function(_, o)
    local toggle_term = require 'toggleterm'
    toggle_term.setup(o)

    local Terminal = require 'toggleterm.terminal'.Terminal

    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = 'float',
      float_opts = {
        title = 'LazyGit',
        height = math.floor(vim.o.lines * 0.96),
        width = vim.o.columns
      },
      count = 3,
      on_open = function(t)
        vim.keymap.set('n', 'q', "<cmd>close<CR>", {
          noremap = true, silent = true, buffer = t.bufnr
        })
        pcall(vim.keymap.del, 't', '<esc>')
      end
    }
    vim.api.nvim_create_user_command("Git", function() lazygit:toggle() end, {
      desc = "LazyGit",
      force = true,
    })

    local lazydocker = Terminal:new {
      cmd = 'lazydocker', hidden = true, count = 3,
      float_opts = {
        title = 'LazyDocker',
        height = math.floor(vim.o.lines * 0.96),
        width = vim.o.columns
      },
      on_open = function(t)
        vim.keymap.set('n', 'q', "<cmd>close<CR>", {
          noremap = true, silent = true, buffer = t.bufnr
        })
        pcall(vim.keymap.del, 't', '<esc>')
      end,
    }
    vim.api.nvim_create_user_command('Docker', function() lazydocker:toggle() end, {
      desc = 'Docker',
      force = true,
    })

    local gh_dash = Terminal:new {
      cmd = "gh dash", hidden = true, direction = 'float',
    }
    vim.api.nvim_create_user_command('GHDash', function() gh_dash:toggle() end, {
      desc = "GHDash",
      force = true,
    })

    local htop = Terminal:new {
      cmd = 'htop', hidden = true,
      float_opts = { title = 'HTOP' },
      on_open = function(t)
        vim.keymap.set('n', 'q', "<cmd>close<CR>", {
          noremap = true, silent = true, buffer = t.bufnr
        })
        pcall(vim.keymap.del, 't', '<esc>')
      end,
    }
    vim.api.nvim_create_user_command('Htop', function() htop:toggle() end, {
      desc = 'HTOP',
      force = true,
    })

    local ncdu = Terminal:new {
      cmd = 'ncdu', hidden = true,
      float_opts = { title = 'HTOP' }
    }
    vim.api.nvim_create_user_command('Ncdu', function() ncdu:toggle() end, {
      desc = 'NCDU',
      force = true,
    })

    local function nmap(tbl)
      vim.keymap.set("n", tbl[1], tbl[2], { desc = tbl[3] })
    end

    local icons = require "lib.icons"
    nmap { "<leader>t1", function() vim.cmd "1ToggleTerm" end, icons.ui.term.. ' Term 1' }
    nmap { "<leader>t2", function() vim.cmd "2ToggleTerm" end, icons.ui.term.. ' Term 2' }
    nmap { "<leader>t3", function() vim.cmd "3ToggleTerm" end, icons.ui.term.. ' Term 3' }
    nmap { "<leader>t4", function() vim.cmd "4ToggleTerm" end, icons.ui.term.. ' Term 4' }
    nmap { "<leader>tt", function() htop:toggle() end, icons.ui.proc .. 'H[t]op' }
    nmap { "<leader>tl", function() lazygit:toggle() end, icons.git.Branch .. '[l]azygit' }
    nmap { "<leader>tn", function() ncdu:toggle() end, icons.ui.disc .. ' [n]cdu' }
    vim.keymap.set({ "n", "v" }, "<leader>ts", function()
        toggle_term.send_lines_to_terminal("single_line", false, { args = vim.v.count })
    end, { desc = " [s]end current line" } )
  end
}