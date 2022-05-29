-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 22/05/2022 - 15:40
-------------------------------------

local ok, which_key = pcall(require, "which-key")
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
    margin = { 1, 1, 1, 1 },
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

-- Local import modules
local tele = require "telescope"
local tele_builtin = require "telescope.builtin"
local packer = require "packer"
local gitsigns = require "gitsigns"
local surround = require "surround"
local dap = require "dap"
local nvim_tree = require "nvim-tree"

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
local noLeader_opts = {
  mode = "n", -- NORMAL mode
  prefix = "",
  buffer = nil,
  silent = false,
  noremap = true,
  nowait = true,
}

local nonLeader_maps = {
  ["<F8>"] = {
    "<cmd>cd %:p:h<CR> <cmd>update<CR> <cmd>!gcc % -o %< <CR> <cmd>NvimTreeRefresh<CR> :call Scratch() <bar> :r!./#< <CR>",
    "Save, Compile & Run",
  },
}

local leader_maps = {
  ["1"] = { "<cmd>BufferLineGoToBuffer 1<CR>", "Go to Buffer 1" },
  ["2"] = { "<cmd>BufferLineGoToBuffer 2<CR>", "Go to Buffer 2" },
  ["3"] = { "<cmd>BufferLineGoToBuffer 3<CR>", "Go to Buffer 3" },
  ["4"] = { "<cmd>BufferLineGoToBuffer 4<CR>", "Go to Buffer 4" },
  ["5"] = { "<cmd>BufferLineGoToBuffer 5<CR>", "Go to Buffer 5" },
  ["6"] = { "<cmd>BufferLineGoToBuffer 6<CR>", "Go to Buffer 6" },
  ["7"] = { "<cmd>BufferLineGoToBuffer 7<CR>", "Go to Buffer 7" },
  ["8"] = { "<cmd>BufferLineGoToBuffer 8<CR>", "Go to Buffer 8" },
  ["9"] = { "<cmd>BufferLineGoToBuffer 9<CR>", "Go to Buffer 9" },
  ["."] = {
    function()
      vim.cmd "cd %:h"
      vim.notify(" Current Working Directory:   `" .. vim.fn.expand "%:p:h" .."`", "Info", {
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

  b = {
    function()
      tele_builtin.buffers(require("telescope.themes").get_dropdown { previewer = false })
    end,
    "Buffers",
  },
  w = { "<cmd>update!<CR>", "Save" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  z = { "<cmd>update<CR> <cmd>Bdelete<cr> <cmd>bnext<cr>", "Save and Close Buffer" },
  q = { "<cmd>quit<CR>", "Quit" },
  a = { ":Alpha<CR>", "Alpha Dashboard" },
  Z = { "<cmd>ZenMode<CR>", "Zen" },
  W = {
    name = "Window",
    s = { '<cmd>split<cr>', "HSplit" },
    v = { '<cmd>vsplit<cr>', "VSplit" },
  },

  f = {
    name = "Find",
    f = {
      function()
        tele_builtin.find_files(require("telescope.themes").get_dropdown { previewer = false })
      end,
      "Find files",
    },
    F = {
      function() tele_builtin.live_grep { theme = "ivy" } end,
        "Find Text (live grep)"
},
--     P = {
--       function() tele_builtin.projects end,
--           "Projects"
-- },
    o = {
      function() tele_builtin.builtin() end,
          "Open Telescope"
    },
    b = {
      function() tele_builtin.git_branches() end,
          "Checkout branch"
    },
    c = {
      function() tele_builtin.command_center() end,
          "Commands"
    },
    H = {
      function() tele_builtin.help_tags() end,
          "Help"
    },
    i = {
      function() tele_builtin.media_files() end,
          "Media"
    },
    l = {
      function() tele_builtin.resume() end,
          "Last Search"
    },
    M = {
      function() tele_builtin.man_pages() end,
          "Man Pages"
    },
    r = {
      function() tele_builtin.oldfiles() end,
          "Recent File"
    },
    R = {
      function() tele_builtin.registers() end,
          "Registers"
    },
    k = {
      function() tele_builtin.keymaps() end,
      "Keymaps"
    },
    C = {
      function() tele_builtin.colorscheme() end,
          "Colorscheme"
    },
    p = {
      function() vim.cmd "TSPlaygroundToggle" end,
            "TS Playground"
    },
    h = {
      function() vim.cmd "TSHighlightCapturesUnderCursor" end,
            "TS Highlight"
    },
  },
  m = {
    name = "Markdown",
    o = {
      function() vim.cmd "MarkdownPreview" end,
      "Start MarkdownPreview"
    },
    s = {
      function() vim.cmd "MarkdownPreviewStop" end,
      "Stop MarkdownPreview"
    },
    t = {
      function() vim.cmd "MarkdownPreviewToggle" end,
      "Toggle MarkdownPreview"
    },
    m = {
      function() vim.cmd "Glow" end,
      "Floating Markdown Preview (Glow)"
    },
  },

  -- Renamer
  r = {
    function() vim.lsp.buf.rename() end,
    "Renamer",
  },

  -- Packer
  p = {
    name = "Packer",
    C = {
      function() packer.compile() end,
      "Compile"
    },
    c = {
      function() packer.clean() end,
      "Clean"
    },
    i = {
      function() packer.install() end,
      "Install"
    },
    S = {
      function() packer.sync() end,
      "Sync"
    },
    s = {
      function() packer.status() end,
      "Status"
    },
    u = {
      function() packer.update() end,
      "Update"
    },
  },

  -- Git
  g = {
    name = "Git",
    j = {
      function() gitsigns.next_hunk() end,
      "Next Hunk",
    },
    k = {
      function() gitsigns.prev_hunk() end,
      "Prev Hunk",
    },
    l = {
      function() gitsigns.blame_line() end,
      "Blame"
    },
    g = {
      function() _LAZYGIT_TOGGLE() end,
      "Lazygit"
    },
    p = {
      function() gitsigns.preview_hunk() end,
      "Preview Hunk",
    },
    r = {
      function() gitsigns.reset_hunk() end,
      "Reset Hunk",
    },
    R = {
      function() gitsigns.reset_buffer() end,
      "Reset Buffer",
    },
    s = {
      function() gitsigns.stage_hunk() end,
      "Stage Hunk",
    },
    u = {
      function() gitsigns.undo_stage_hunk() end,
      "Undo Stage Hunk",
    },
    o = {
      function() tele_builtin.git_status() end,
      "Open changed file"
    },
    b = {
      function() tele_builtin.git_branches() end,
      "Checkout branch"
    },
    c = {
      function() tele_builtin.git_commits() end,
      "Checkout commit"
    },
    d = {
      function() gitsigns.diffthis() end,
      "Diff"
    },
    t = {
      function() gitsigns.toggle_current_line_blame() end,
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
      function() tele_builtin.lsp_workspace_diagnostics() end,
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
      "Info"
    },
    I = {
      function() vim.cmd "LspInstallInfo" end,
      "Installer Info"
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
    o = {
      function() require("symbols-outline").toggle_outline() end,
      "Symbols Outline"
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
      function() tele_builtin.lsp_document_symbols() end,
      "Document Symbols"
    },
    S = {
      function() tele_builtin.lsp_dynamic_workspace_symbols() end,
      "Workspace Symbols",
    },
    t = {
      function() vim.cmd "TodoLocList" end,
      "Todo in LocList",
    },
    T = {
      function() vim.cmd "TodoTroble" end,
      "TodoTrouble"
    }
  },

  -- SURROUND
  s = {
    name = "Surround",
    ["."] = {
      function() surround.repeat_last() end,
      "Repeat",
    },
    a = {
      function() surround.surround_add(true) end,
      "Add",
    },
    d = {
      function() surround.surround_delete() end,
      "Delete",
    },
    r = {
      function() surround.surround_replace() end,
      "Replace",
    },
    q = {
      function() surround.toggle_quotes() end,
      "Quotes",
    },
    b = {
      function() surround.toggle_brackets() end,
      "Brackets",
    },
  },

  -- NVIMTREE
  E = {
    function() nvim_tree.toggle() end,
    "Toggle Nvim-Tree"
  },
  e = {
    name = "Nvim-Tree",
    r = {
      function() vim.cmd "NvimTreeRefresh" end,
      "Refresh Nvim-Tree"
    },
    o = {
      function() nvim_tree.open() end,
      "Open Nvim-Tree window"
    },
    f = {
      function() nvim_tree.focus() end,
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
      function() dap.toggle_breakpoint() end,
      "Breakpoint"
    },
    c = {
      function() dap.continue() end,
      "Continue"
},
    i = {
      function() dap.step_into() end,
      "Into"
    },
    o = {
      function() dap.step_over() end,
      "Over"
},
    O = {
      function() dap.step_out() end,
      "Out"
    },
    r = {
      function() dap.repl.toggle() end,
      "Repl"
},
    l = {
      function() dap.run_last() end,
      "Last"
    },
    u = {
      function() dap.toggle {} end,
      "UI"
},
    x = {
      function() dap.terminate() end,
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
    ["%"] = { "<cmd>source %<CR>", "Source current buffer" },
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
      require("Comment.api").toggle_linewise_op(vim.fn.visualmode())
    end,
    "Comment"
  },

  -- SURROUND
  s = {
    name = "Surround",
    ["."] = {
      function() surround.repeat_last() end,
      "Repeat"
    },
    a = {
      function() surround.surround_add(true) end,
      "Add"
    },
    d = {
      function() surround.surround_delete() end,
      "Delete"
    },
    r = {
      function() surround.surround_replace() end,
      "Replace"
    },
    q = {
      function() surround.toggle_quotes() end,
      "Quotes"
    },
    b = {
      function() surround.toggle_brackets() end,
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
  Z = { "<cmd>update<CR> <cmd>Bdelete<CR> <cmd>bnext<CR>", "Save and Close buffer" },
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

which_key.setup(setup)
which_key.register(leader_maps, opts)
which_key.register(nonLeader_maps, noLeader_opts)
which_key.register(vmappings, vopts)
which_key.register(Zmappings, Zopts)
which_key.register(ins_mappings, i_opts)
