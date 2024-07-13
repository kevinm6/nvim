-------------------------------------
-- File         : terminal.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 08 May 2024, 21:31
-------------------------------------

return {
  "akinsho/toggleterm.nvim",
  cmd = {
    "ToggleTerm",
    "Lazygit",
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
      "<leader>tf",
      function()
        vim.cmd.ToggleTerm "direction=float"
      end,
      desc = "Terminal❭ Float",
    },
    {
      "<leader>th",
      function()
        vim.cmd.ToggleTerm "direction=horizontal"
      end,
      desc = "Terminal❭ Horizontal",
    },
    {
      "<leader>tv",
      function()
        vim.cmd.ToggleTerm "direction=vertical"
      end,
      desc = "Terminal❭ Vertical",
    },
    {
      "<leader>te",
      function()
        local cmd = vim.fn.input { prompt = "Term command => " }
        if cmd ~= "" then
          cmd = string.format("cmd='%s'", cmd)
          vim.cmd.TermExec(cmd)
          return
        end
      end,
      desc = "Terminal❭ TermExec",
    },
  },
  config = function(_, o)
    o.size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.3)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.3)
      end
    end
    o.open_mapping = [[<M-t>]]
    o.shading_factor = 0
    o.start_in_insert = true
    o.insert_mappings = true
    o.persist_size = false
    o.direction = "horizontal"
    o.close_on_exit = true
    o.autochdir = true

    o.shell = function()
      if vim.bo.filetype == "python" then
        return "ipython"
      else
        return vim.o.shell
      end
    end
    o.winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    }
    o.float_opts = {
      border = "curved",
      winblend = 6,
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      highlights = {
        border = "Normal",
        background = "Normal",
      },
      title_pos = "center",
    }

    require("toggleterm").setup(o)
    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      float_opts = {
        title = "LazyGit",
        height = math.floor(vim.o.lines * 0.96),
        width = vim.o.columns,
      },
      count = 3,
      on_open = function(t)
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
          noremap = true,
          silent = true,
          buffer = t.bufnr,
        })
        pcall(vim.keymap.del, "t", "<esc>")
      end,
    }
    vim.api.nvim_create_user_command("Lazygit", function()
      lazygit:toggle()
    end, {
      desc = "LazyGit",
      force = true,
    })

    local lazydocker = Terminal:new {
      cmd = "lazydocker",
      hidden = true,
      count = 3,
      float_opts = {
        title = "LazyDocker",
        height = math.floor(vim.o.lines * 0.96),
        width = vim.o.columns,
      },
      on_open = function(t)
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
          noremap = true,
          silent = true,
          buffer = t.bufnr,
        })
        pcall(vim.keymap.del, "t", "<esc>")
      end,
    }
    vim.api.nvim_create_user_command("Docker", function()
      lazydocker:toggle()
    end, {
      desc = "Docker",
      force = true,
    })

    local gh_dash = Terminal:new {
      cmd = "gh dash",
      hidden = true,
      direction = "float",
    }
    vim.api.nvim_create_user_command("GHDash", function()
      gh_dash:toggle()
    end, {
      desc = "GHDash",
      force = true,
    })

    local htop = Terminal:new {
      cmd = "htop",
      hidden = true,
      float_opts = { title = "HTOP" },
      on_open = function(t)
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
          noremap = true,
          silent = true,
          buffer = t.bufnr,
        })
        pcall(vim.keymap.del, "t", "<esc>")
      end,
    }
    vim.api.nvim_create_user_command("Htop", function()
      htop:toggle()
    end, {
      desc = "HTOP",
      force = true,
    })

    local ncdu = Terminal:new {
      cmd = "ncdu",
      hidden = true,
      float_opts = { title = "HTOP" },
    }
    vim.api.nvim_create_user_command("Ncdu", function()
      ncdu:toggle()
    end, {
      desc = "NCDU",
      force = true,
    })

    local function nmap(tbl)
      vim.keymap.set("n", tbl[1], tbl[2], { desc = "Terminal❭ " .. tbl[3] })
    end

    nmap {
      "<leader>t1",
      function()
        vim.cmd "1ToggleTerm"
      end,
      "Term 1",
    }
    nmap {
      "<leader>t2",
      function()
        vim.cmd "2ToggleTerm"
      end,
      "Term 2",
    }
    nmap {
      "<leader>t3",
      function()
        vim.cmd "3ToggleTerm"
      end,
      "Term 3",
    }
    nmap {
      "<leader>t4",
      function()
        vim.cmd "4ToggleTerm"
      end,
      "Term 4",
    }
    nmap {
      "<leader>tt",
      function()
        htop:toggle()
      end,
      "Htop",
    }
    nmap {
      "<leader>tl",
      function()
        lazygit:toggle()
      end,
      "Lazygit",
    }
    nmap {
      "<leader>tn",
      function()
        ncdu:toggle()
      end,
      "Ncdu",
    }
    vim.keymap.set({ "n", "v" }, "<leader>ts", function()
      require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })
    end, { desc = "send current line" })
  end,
}
