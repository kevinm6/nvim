-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 11 Oct 2022, 20:31
-------------------------------------

local ok, wk = pcall(require, "which-key")
if not ok then return end

local icons = require "user.icons"

local setup = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = icons.ui.ChevronRight,
    separator = icons.git.Rename,
    group = icons.ui.List .. " ",
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 2, 10, 2, 10 },
    padding = { 2, 2, 2, 2 },
    winblend = 6,
  },
  layout = {
    height = { min = 4, max = 24 },
    width = { min = 20, max = 46 },
    spacing = 3,
    align = "center",
  },
  ignore_missing = false,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = false,
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

-- Options for leader key mappings
local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

-- Options for other mappings
-- local noLeader_opts = {
--   mode = "n", -- NORMAL mode
--   prefix = "",
--   buffer = nil,
--   silent = false,
--   noremap = true,
--   nowait = true,
-- }

local leader_maps = {
  -- Switch Buffers
  ["."] = {
    function()
      vim.cmd "cd %:h"
      vim.notify(" Current Working Directory:   `" .. vim.fn.expand "%:p:h" .. "`", "Info", {
        title = "File Explorer",
        timeout = 4,
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        end
      })
    end,
    "Change dir to current buffer's parent",
  },
  A = {
    name = "Session",
    s = {
      function() vim.cmd "SaveSession" end,  "Save"
    },
    r = {
      function() vim.cmd "Autosession restore" end,  "Restore"
    },
    d = {
      function() vim.cmd "Autosession delete" end,  "Delete"
    },
    a = {
      function() vim.cmd "Autosession search" end, "Autosession {search|delete}"
    }
  },
  h = {
    function()
      local word = vim.fn.expand "<cword>"
      vim.cmd (":h " .. word )
    end,
    "Help <cword>"
  },

  b = {
    function()
      require("telescope.builtin").buffers(require("telescope.themes").get_dropdown { previewer = false })
    end,
    "Buffers",
  },
  w = { "<cmd>update!<CR>", "Save" },
  H = { "<cmd>nohlsearch<CR>", "No Highlight" },
  c = { "<cmd>DeleteCurrentBuffer<CR>", "Close Buffer" },
  z = { "<cmd>DeleteCurrentBuffer<CR>", "Save and Close Buffer" },
  q = { "<cmd>bdelete<CR>", "Quit" },
  a = { ":Alpha<CR>", "Alpha Dashboard" },
  Z = { "<cmd>ZenMode<CR>", "Zen" },
  W = {
    name = "Window",
    s = { '<cmd>split<cr>', "HSplit" },
    v = { '<cmd>vsplit<cr>', "VSplit" },
  },
  n = {
    name = "Notifications",
    n = { "<cmd>Notifications<CR>", "Notifications" },
    m = { "<cmd>messages<CR>", "Messages" },
    -- t = { "<cmd>Noice telescope<CR>", "Show on Telescope" }
  },
  u = {
    u = { "<cmd>cd $CS<CR>", "University Folder" },
  ['1'] = {
    name = "1° Anno",
    ['1'] = {
        name = "1° Semestre",
        m = { "<cmd>cd $CS/1°Anno/1°Semestre/Matematica del Continuo/<CR>", "Matematica Continuo" },
    },
    ['2'] = {
        name = "2° Semestre",
        a = { "<cmd>cd $CS/1°Anno/2°Semestre/Architettura degli Elaboratori II/<CR>", "Arch. Elaboratori II" },
        l = { "<cmd>cd $CS/1°Anno/2°Semestre/Logica matematica/<CR>", "Logica matematica" },
        m = { "<cmd>cd $CS/1°Anno/2°Semestre/Matematica del Discreto/<CR>", "Matematica Discreta" },
    },
  },
  ['2'] = {
    name = "2° Anno",
    ['1'] = {
        name = "1° Semestre",
        a = { "<cmd>cd $CS/2°Anno/1°Semestre/Algoritmi e Strutture Dati/<CR>", "Algoritmi & Strutture Dati" },
        b = { "<cmd>cd $CS/2°Anno/1°Semestre/Basi di Dati/<CR>", "Basi di Dati" },
        p = { "<cmd>cd $CS/2°Anno/1°Semestre/Programmazione II/<CR>", "Programmazione II" },
    },
    ['2'] = {
        name = "2° Semestre",
        s = { "<cmd>cd $CS/2°Anno/2°Semestre/Sistemi Operativi/<CR>", "Sistemi Operativi" },
        S = { "<cmd>cd $CS/2°Anno/2°Semestre/S&AD/<CR>", "Statistica & Analisi Dati" },
    },
  },
  ['3'] = {
    name = "3° Anno",
    ['1'] = {
        name = "1° Semestre",
        c = { "<cmd>cd $CS/3°Anno/1°Semestre/Crittografia I/<CR>", "Crittografia I" },
        i = { "<cmd>cd $CS/3°Anno/1°Semestre/Intelligenza Artificiale I/<CR>", "Intelligenza Artificiale I" },
        I = { "<cmd>cd $CS/3°Anno/1°Semestre/Ingegneria del Software/<CR>", "Ingegneria Software" },
        r = { "<cmd>cd $CS/3°Anno/1°Semestre/Reti di Calcolatori/<CR>", "Reti di Calcolatori" },
        s = { "<cmd>cd $CS/3°Anno/1°Semestre/Sicurezza & Privatezza/<CR>", "Sicurezza & Privatezza" },
        l = { "<cmd>cd $CS/3°Anno/1°Semestre/Linguaggi di Programmazione/<CR>", "Linguaggi di Programmazione" },
    },
    ['2'] = {
        name = "2° Semestre",
        t = { "<cmd>cd $CS/3°Anno/2°Semestre/Tecnologie & Linguaggi per il Web/<CR>", "Tecnologie Web" },
    },
  },

  },


  f = {
    name = "Find",
    f = {
      function()
        require("telescope.builtin").find_files(require("telescope.themes").get_dropdown { previewer = false })
      end,
      "Find files",
    },
    F = {
      function() require("telescope.builtin").live_grep { theme = "ivy" } end,
      "Find Text (live grep)"
    },
    o = {
      function() require("telescope.builtin").builtin() end,
      "Open Telescope"
    },
    b = {
      function() require("telescope").extensions.file_browser.file_browser({ theme = "get_dropdown" }) end,
      "File Browser"
    },
    H = {
      function() require("telescope.builtin").help_tags() end,
      "Help"
    },
    p = {
      function() require("telescope").extensions.project.project {} end,
      "Projects"
    },
    P = {
      function() require("telescope").extensions.packer.packer {} end,
      "Packer"
    },
    l = {
      function() require("telescope.builtin").resume() end,
      "Last Search"
    },
    M = {
      function() require("telescope.builtin").man_pages() end,
      "Man Pages"
    },
    r = {
      function() require("telescope.builtin").oldfiles() end,
      "Recent File"
    },
    R = {
      function() require("telescope.builtin").registers() end,
      "Registers"
    },
    k = {
      function() require("telescope.builtin").keymaps() end,
      "Keymaps"
    },
    C = {
      function() require("telescope.builtin").colorscheme() end,
      "Colorscheme"
    },
    y = {
      function() require("telescope").extensions.neoclip.default() end,
      "Yank History",
    },
    e = {
      function() require("telescope").extensions.env.env() end,
      "Environment",
    },
    E = {
      function() require("telescope").extensions.emoji.emoji() end,
      "Emoji",
    },
    L = {
      function() require("telescope").extensions.luasnip.luasnip{} end,
      "Luasnip",
    },
    d = {
      name = "Dap",
      c = {
        function() require 'telescope'.extensions.dap.commands {} end,
        "Commands"
      },
      C = {
        function() require 'telescope'.extensions.dap.configurations {} end,
        "Configuration"
      },
      b = {
        function() require 'telescope'.extensions.dap.list_breakpoints {} end,
        "Commands"
      },
      v = {
        function() require 'telescope'.extensions.dap.variables {} end,
        "Variables"
      },
      f = {
        function() require 'telescope'.extensions.dap.frames {} end,
        "Frames"
      },
    }
  },

  -- Renamer
  r = {
    function() vim.lsp.buf.rename() end,
    "Renamer",
  },

  -- Git
  g = {
    name = "Git",
    j = {
      function() require("gitsigns").next_hunk() end,
      "Next Hunk",
    },
    k = {
      function() require("gitsigns").prev_hunk() end,
      "Prev Hunk",
    },
    l = {
      function() require("gitsigns").blame_line() end,
      "Blame"
    },
    g = {
      function() vim.cmd "Git" end,
      "Lazygit"
    },
    p = {
      function() require("gitsigns").preview_hunk() end,
      "Preview Hunk",
    },
    r = {
      function() require("gitsigns").reset_hunk() end,
      "Reset Hunk",
    },
    R = {
      function() require("gitsigns").reset_buffer() end,
      "Reset Buffer",
    },
    s = {
      function() require("gitsigns").stage_hunk() end,
      "Stage Hunk",
    },
    u = {
      function() require("gitsigns").undo_stage_hunk() end,
      "Undo Stage Hunk",
    },
    o = {
      function() require("telescope.builtin").git_status() end,
      "Open changed file"
    },
    b = {
      function() require("telescope.builtin").git_branches() end,
      "Checkout branch"
    },
    c = {
      function() require("telescope.builtin").git_commits() end,
      "Checkout commit"
    },
    d = {
      function() require("gitsigns").diffthis() end,
      "Diff"
    },
    t = {
      function() require("gitsigns").toggle_current_line_blame() end,
      "Diff"
    },
  },

  -- SnipRun
  S = {
    name = "SnipRun",
    c = {
      function() vim.cmd "SnipClose" end,
      "Close"
    },
    f = {
      function() vim.cmd "%SnipRun" end,
      "Run File"
    },
    i = {
      function() vim.cmd "SnipInfo" end,
      "Info"
    },
    m = {
      function() vim.cmd "SnipReplMemoryClean" end,
      "Mem Clean"
    },
    r = {
      function() vim.cmd "SnipReset" end,
      "Reset"
    },
    t = {
      function() vim.cmd "SnipRunToggle" end,
      "Toggle"
    },
    x = {
      function() vim.cmd "SnipTerminate" end,
      "Terminate"
    },
  },

  -- LSP
  l = {
    name = "LSP",
    a = {
      function() vim.lsp.buf.code_action() end,
      "Code Action",
    },
    d = {
      function() require("trouble").toggle() end,
      "Diagnostics"
    },
    w = {
      function() require("telescope.builtin").lsp_workspace_diagnostics() end,
      "Workspace Diagnostics",
    },
    f = {
      function() vim.lsp.buf.format { async = true } end,
      "Format",
    },
    F = {
      function() require("user.lsp.handlers").toggle_format_on_save() end,
      "Toggle Autoformat"
    },
    i = {
      function() vim.cmd "LspInfo" end,
      "Lsp Info"
    },
    m = {
      function() vim.cmd "Mason" end,
      "Mason"
    },
    L = {
      function() vim.cmd "LspLog" end,
      "Lsp Log"
    },
    j = {
      function() vim.diagnostic.goto_next { buffer = 0 } end,
      "Next Diagnostic",
    },
    k = {
      function() vim.diagnostic.goto_prev { buffer = 0 } end,
      "Prev Diagnostic",
    },
    l = {
      function() vim.lsp.codelens.run() end,
      "CodeLens Action",
    },
    q = {
      function() vim.diagnostic.setloclist() end,
      "Quickfix",
    },
    r = {
      function() vim.lsp.buf.rename() end,
      "Rename",
    },
    R = {
      function() require("trouble").toggle("lsp_references") end,
      "References"
    },
    s = {
      function() require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_dropdown()) end,
      "Document Symbols"
    },
    S = {
      function() require("telescope.builtin").lsp_dynamic_workspace_symbols(require("telescope.themes").get_dropdown()) end,
      "Workspace Symbols",
    },
    t = {
      function() vim.cmd "TodoTrouble" end,
      "TodoTrouble"
    },
    T = {
      function() vim.cmd "TodoLocList" end,
      "Todo in LocList",
    }
  },

  -- Surround ("Pairings")
  s = {
    name = "Surround",
    ["."] = {
      function() require("surround").repeat_last() end,
      "Repeat",
    },
    a = {
      function() require("surround").surround_add(true) end,
      "Add",
    },
    d = {
      function() require("surround").surround_delete() end,
      "Delete",
    },
    r = {
      function() require("surround").surround_replace() end,
      "Replace",
    },
    q = {
      function() require("surround").toggle_quotes() end,
      "Quotes",
    },
    b = {
      function() require("surround").toggle_brackets() end,
      "Brackets",
    },
  },

  -- NVIMTREE
  E = {
    function() require("nvim-tree").toggle() end,
    "Toggle Nvim-Tree"
  },
  e = {
    name = "Nvim-Tree",
    r = {
      function() vim.cmd "NvimTreeRefresh" end,
      "Refresh Nvim-Tree"
    },
    o = {
      function() require("nvim-tree").open() end,
      "Open Nvim-Tree window"
    },
    f = {
      function() require("nvim-tree").focus() end,
      "Focus file in Nvim-Tree"
    },
    c = {
      function() vim.cmd "NvimTreeClose" end,
      "Close Nvim-Tree window"
    },
    C = {
      function() vim.cmd "NvimTreeClipboard" end,
      "Show Nvim-Tree clipboard"
    },
  },

  -- Terminal
  t = {
    name = "Terminal",
    ["1"] = { "<cmd>1ToggleTerm<CR>", "1" },
    ["2"] = { "<cmd>2ToggleTerm<CR>", "2" },
    ["3"] = { "<cmd>3ToggleTerm<CR>", "3" },
    ["4"] = { "<cmd>4ToggleTerm<CR>", "4" },
    t = {
      function() _HTOP_TOGGLE() end,
      "Htop",
    },
    l = {
      function() _LAZYGIT_TOGGLE() end,
      "Lazygit",
    },
    n = {
      function() _NCDU_TOGGLE() end,
      "Ncdu",
    },
    f = {
      function() vim.cmd "ToggleTerm direction=float" end,
      "Float"
    },
    h = {
      function() vim.cmd "ToggleTerm size=10 direction=horizontal" end,
      "Horizontal"
    },
    v = {
      function() vim.cmd "ToggleTerm size=80 direction=vertical" end,
      "Vertical"
    },
  },

  -- Debug
  d = {
    name = "Debug",
    b = {
      function() require("dap").toggle_breakpoint() end,
      "Breakpoint"
    },
    c = {
      function() require("dap").continue() end,
      "Continue"
    },
    i = {
      function() require("dap").step_into() end,
      "Into"
    },
    o = {
      function() require("dap").step_over() end,
      "Over"
    },
    O = {
      function() require("dap").step_out() end,
      "Out"
    },
    r = {
      function() require("dap").repl.toggle() end,
      "Repl"
    },
    l = {
      function() require("dap").run_last() end,
      "Last"
    },
    u = {
      function() require("dapui").toggle {} end,
      "UI"
    },
    x = {
      function() require("dap").terminate() end,
      "Exit"
    },
  },

  T = {
    name = "Treesitter",
    p = {
      function() vim.cmd "TSPlaygroundToggle" end,
      "Playground"
    },
    h = {
      function() vim.cmd "TSHighlightCapturesUnderCursor" end,
      "Highlight"
    },
  },

  -- Config file
  [0] = {
    name = "Configuration Files",
    s = {
      function()
        vim.cmd "source $NVIMDOTDIR/init.lua"
        vim.notify(" Config file sourced", "Info")
      end,
      "Source Neovim config file",
    },
    e = { "<cmd>edit $NVIMDOTDIR/init.lua<CR>", "Edit Neovim config file" },
    r = { "<cmd>luafile %<CR>", "Reload current buffer" },
    S = {
      "<cmd>source ~/.config/nvim/lua/user/luasnip.lua<CR>",
      "Reload custom snippets"
    }
  },
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
  ["/"] = {
    function()
      require("Comment.api").toggle.linewise.current(vim.fn.visualmode())
    end,
    "Comment"
  },

  -- require("surround")
  s = {
    name = "Surround",
    ["."] = {
      function() require("surround").repeat_last() end,
      "Repeat"
    },
    a = {
      function() require("surround").surround_add(true) end,
      "Add"
    },
    d = {
      function() require("surround").surround_delete() end,
      "Delete"
    },
    r = {
      function() require("surround").surround_replace() end,
      "Replace"
    },
    q = {
      function() require("surround").toggle_quotes() end,
      "Quotes"
    },
    b = {
      function() require("surround").toggle_brackets() end,
      "Brackets"
    },
  },
  d = { [["+d]], 'Copy deletion into register "' },
  D = { [["+D]], 'Copy deletion to end into register "' },
  y = { [["+y]], 'Copy yank into register "' },
  ["<BS>"] = { [["+d]], 'Copy deletion into register "' },
}

local Zopts = {
  mode = "n", -- NORMAL mode
  prefix = "Z",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local Zmappings = {
  Z = { "<cmd>update<CR> <cmd>DeleteCurrentBuffer<CR>", "Save and Close buffer" },
  Q = { "<cmd>quit!<CR>", "Close buffer and go to next" },
  A = { ":%bdelete | :Alpha<CR>", "Close all Buffers" },
}

local i_opts = {
  mode = "i",
  prefix = "<C-x>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local ins_mappings = {
  ["<C-l>"] = "Whole lines",
  ["<C-n>"] = "Keywords in current file",
  ["<C-k>"] = "Keywords in dictionary",
  ["<C-t>"] = "Keywords in thesaurus",
  ["<C-i>"] = "Keywords in current and included files",
  ["<C-]>"] = "Tags",
  ["<C-f>"] = "File names",
  ["<C-d>"] = "Definitions or macros",
  ["<C-v>"] = "Vim command-line",
  ["<C-u>"] = "User defined completion",
  ["<C-o>"] = "Omni completion",
  s = "Spelling suggestions",
}


wk.setup(setup)
wk.register(leader_maps, opts)
wk.register(vmappings, vopts)
wk.register(Zmappings, Zopts)
wk.register(ins_mappings, i_opts)
