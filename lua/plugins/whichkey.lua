-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 03 Jan 2023, 18:47
-------------------------------------

local M = {
  "folke/which-key.nvim",
  event = "BufEnter",
  keys = {
    { "<leader>" },
  }
}

function M.config()
	local wk = require "which-key"
	local icons = require "user.icons"

	wk.setup {
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
	    border = "none",
	    position = "bottom",
	    margin = { 0, 3, 1, 3 }, -- extra window margin [top, right, bottom, left]
	    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
	    winblend = 10,
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
	  show_keys = false,
	  triggers_blacklist = {
	    i = { "j", "k" },
	    v = { "j", "k" },
	  },
	}

  wk.register(
    {
      ['0'] = { name = "Configuration File" },
      A = { name = "Sessions" },
      d = { name = "Dap" },
      g = { name = "Git" },
      l = { name = "Lsp" },
      n = { name = "Notifications" },
      f = { name = "Find" },
      t = { name = "Terminal" },
      T = { name = "Treesitter" },
      u = { name = "University Folder" },
      s = { name = "Surround" },
      W = { name = "Window" },
    }, {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    }
  )
end

return M

-- Options for leader key mappings
-- local opts = {
--   mode = "n", -- NORMAL mode
--   prefix = "<leader>",
--   buffer = nil,
--   silent = true,
--   noremap = true,
--   nowait = true,
-- }

-- local leader_maps = {
  -- Switch Buffers
--   ["."] = {
--     function()
--       vim.cmd.cd "%:h"
--       vim.notify(" Current Working Directory:   `" .. vim.fn.expand "%:p:h" .. "`", "Info", {
--         title = "File Explorer",
--         timeout = 4,
--         on_open = function(win)
--           local buf = vim.api.nvim_win_get_buf(win)
--           vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
--         end
--       })
--     end,
--     "Change dir to current buffer's parent",
--   },
--  A = {
--    name = "Session",
--    s = {
--      function() require "user.functions".save_session() end,  "Save"
--    },
--    r = {
--      function() require "user.functions".restore_session() end,  "Restore"
--    },
--    d = {
--      function() require "user.functions".delete_session() end,  "Delete"
--    },
--  },
--  b = {
--    function()
--      require "telescope.builtin".buffers {
--        theme = "dropdown",
--        previewer = false,
--        sort_mru = true,
--      }
--    end,
--    "Buffers",
--  },
--  w = { "<cmd>update!<CR>", "Save" },
--  H = { "<cmd>nohlsearch<CR>", "No Highlight" },
--  c = { "<cmd>DeleteCurrentBuffer<CR>", "Close Buffer" },
--  z = { "<cmd>DeleteCurrentBuffer<CR>", "Save and Close Buffer" },
--  q = { "<cmd>bdelete<CR>", "Quit" },
--  a = { ":Alpha<CR>", "Alpha Dashboard" },
--  Z = { "<cmd>ZenMode<CR>", "Zen" },
--  W = {
--    name = "Window",
--    s = { '<cmd>split<cr>', "HSplit" },
--    v = { '<cmd>vsplit<cr>', "VSplit" },
--  },
--  n = {
--    name = "Notifications",
--    n = { "<cmd>Noice<CR>", "Notifications" },
--    m = { "<cmd>Noice history<CR>", "Messages" },
--    L = { "<cmd>Noice log<CR>", "Log" },
--    e = { "<cmd>Noice error<CR>", "Error" },
--    l = { "<cmd>Noice last<CR>", "Last" },
--    t = {
--      function ()
--        require "telescope".extensions.noice.noice {
--          theme = "dropdown"
--        }
--      end,
--      "Noice Telescope"
--    }
--  },
--  u = {
--    u = { "<cmd>cd $CS<CR>", "University Folder" },
--  ['1'] = {
--    name = "1° Anno",
--    ['1'] = {
--        name = "1° Semestre",
--        m = { "<cmd>cd $CS/Anno1/Semestre1/Matematica del Continuo/<CR>", "Matematica Continuo" },
--    },
--    ['2'] = {
--        name = "2° Semestre",
--        a = { "<cmd>cd $CS/Anno1/Semestre2/Architettura degli Elaboratori II/<CR>", "Arch. Elaboratori II" },
--        l = { "<cmd>cd $CS/Anno1/Semestre2/Logica matematica/<CR>", "Logica matematica" },
--        m = { "<cmd>cd $CS/Anno1/Semestre2/Matematica del Discreto/<CR>", "Matematica Discreto" },
--    },
--  },
--  ['2'] = {
--    name = "2° Anno",
--    ['1'] = {
--        name = "1° Semestre",
--        a = { "<cmd>cd $CS/Anno2/Semestre1/Algoritmi e Strutture Dati/<CR>", "Algoritmi & Strutture Dati" },
--        b = { "<cmd>cd $CS/Anno2/Semestre1/Basi di Dati/<CR>", "Basi di Dati" },
--        p = { "<cmd>cd $CS/Anno2/Semestre1/Programmazione II/<CR>", "Programmazione II" },
--    },
--    ['2'] = {
--        name = "2° Semestre",
--        s = { "<cmd>cd $CS/Anno2/Semestre2/Sistemi Operativi/<CR>", "Sistemi Operativi" },
--        S = { "<cmd>cd $CS/Anno2/Semestre2/S&AD/<CR>", "Statistica & Analisi Dati" },
--    },
--  },
--  ['3'] = {
--    name = "3° Anno",
--    ['1'] = {
--        name = "1° Semestre",
--        c = { "<cmd>cd $CS/Anno3/Semestre1/Crittografia I/<CR>", "Crittografia I" },
--        i = { "<cmd>cd $CS/Anno3/Semestre1/Intelligenza Artificiale I/<CR>", "Intelligenza Artificiale I" },
--        I = { "<cmd>cd $CS/Anno3/Semestre1/Ingegneria del Software/<CR>", "Ingegneria Software" },
--        r = { "<cmd>cd $CS/Anno3/Semestre1/Reti di Calcolatori/<CR>", "Reti di Calcolatori" },
--        s = { "<cmd>cd $CS/Anno3/Semestre1/Sicurezza & Privatezza/<CR>", "Sicurezza & Privatezza" },
--        l = { "<cmd>cd $CS/Anno3/Semestre1/Linguaggi di Programmazione/<CR>", "Linguaggi di Programmazione" },
--    },
--    ['2'] = {
--        name = "2° Semestre",
--        t = { "<cmd>cd $CS/Anno3/Semestre2/Tecnologie & Linguaggi per il Web/<CR>", "Tecnologie Web" },
--    },
--  },
--
--  },


--  f = {
--    name = "Find",
--    f = {
--      function()
--       local curr_file_dir = vim.fn.expand "%:p:h"
--       local git_ancestor = require "lspconfig.util".find_git_ancestor(curr_file_dir)
--        require "telescope.builtin".find_files {
--          cwd = git_ancestor ~= nil and git_ancestor or curr_file_dir,
--          theme = "dropdown",
--          previewer = false
--        }
--      end,
--      "Find files",
--    },
--    F = {
--      function() require "telescope.builtin".live_grep { theme = "ivy", hidden = true } end,
--      "Find Text (live grep)"
--    },
--    o = {
--      function() require "telescope.builtin".builtin() end,
--      "Open Telescope"
--    },
--    b = {
--      function() require "telescope".extensions.file_browser.file_browser { previewer = false } end,
--      "File Browser"
--    },
--    H = {
--      function() require "telescope.builtin".help_tags() end,
--      "Help"
--    },
--    g = {
--      function() require "telescope.builtin".git_files {} end,
--      "Git Files"
--    },
--    p = {
--      function() require "telescope".extensions.project.project {} end,
--      "Projects"
--    },
--    P = {
--      function() require "telescope".extensions.packer.packer {} end,
--      "Packer"
--    },
--    l = {
--      function() require "telescope.builtin".resume() end,
--      "Last Search"
--    },
--    M = {
--      function() require "telescope.builtin".man_pages() end,
--      "Man Pages"
--    },
--    r = {
--      function() require "telescope.builtin".oldfiles {
--        theme = "dropdown",
--        previewer = false,
--        cwd_only = false,
--      }
--      end,
--      "Recent File"
--    },
--    R = {
--      function() require "telescope.builtin".registers() end,
--      "Registers"
--    },
--    k = {
--      function() require "telescope.builtin".keymaps() end,
--      "Keymaps"
--    },
--    C = {
--      function() require "telescope.builtin".colorscheme() end,
--      "Colorscheme"
--    },
--    y = {
--      function() require "telescope".extensions.neoclip.default {
--        theme = "dropdown"
--      } end,
--      "Yank History",
--    },
--    e = {
--      function() require "telescope".extensions.env.env() end,
--      "Environment",
--    },
--    E = {
--      function() require "telescope".extensions.emoji.emoji {
--        theme = "cursor",
--      } end,
--      "Emoji",
--    },
--    L = {
--      function() require "telescope".extensions.luasnip.luasnip{} end,
--      "Luasnip",
--    },
--    s = {
--      function ()
--        require "telescope.builtin".grep_string {
--          theme = "dropdown",
--          previewer = false
--        }
--      end,
--      "Grep string under cursor"
--    },
--    t = {
--      function() require "plugins.config.translate"() end,
--      "Translate",
--    },
--    u = {
--      function() require "telescope".extensions.undo.undo() end,
--      "Undo"
--    },
--  },

  -- Renamer
--  r = {
--    function() vim.lsp.buf.rename() end,
--    "Rename",
--  },

  -- Git
--  g = {
--    name = "Git",
--    j = {
--      function() require "gitsigns".next_hunk() end,
--      "Next Hunk",
--    },
--    k = {
--      function() require "gitsigns".prev_hunk() end,
--      "Prev Hunk",
--    },
--    l = {
--      function() require "gitsigns".blame_line() end,
--      "Blame"
--    },
--    g = {
--      function() vim.cmd.Git {} end,
--      "Lazygit"
--    },
--    p = {
--      function() require "gitsigns".preview_hunk() end,
--      "Preview Hunk",
--    },
--    r = {
--      function() require "gitsigns".reset_hunk() end,
--      "Reset Hunk",
--    },
--    R = {
--      function() require "gitsigns".reset_buffer() end,
--      "Reset Buffer",
--    },
--    s = {
--      function() require "gitsigns".stage_hunk() end,
--      "Stage Hunk",
--    },
--    u = {
--      function() require "gitsigns".undo_stage_hunk() end,
--      "Undo Stage Hunk",
--    },
--    o = {
--      function() require "telescope.builtin".git_status() end,
--      "Open changed file"
--    },
--    b = {
--      function() require "telescope.builtin".git_branches() end,
--      "Checkout branch"
--    },
--    c = {
--      function() require "telescope.builtin".git_commits() end,
--      "Checkout commit"
--    },
--  d = {
--    function() require "gitsigns".diffthis() end,
--    "Diff"
--  },
--    t = {
--      function() require "gitsigns".toggle_current_line_blame() end,
--      "Diff"
--    },
-- },

  -- Mason
--  M = {
--    function() vim.cmd.Mason {} end,
--    "Mason"
--  },

  -- LSP
--  l = {
--    name = "LSP",
--    a = {
--      function() vim.lsp.buf.code_action() end,
--      "Code Action",
--    },
--    f = {
--      function() vim.lsp.buf.format { async = true } end,
--      "Format",
--    },
--    F = {
--      function() require("plugins.lsp.handlers").toggle_format_on_save() end,
--      "Toggle Autoformat"
--    },
  --  I = {
  --    function() vim.cmd.LspInfo {} end,
  --    "Lsp Info"
  --  },
  --  L = {
  --    function() vim.cmd.LspLog {} end,
  --    "Lsp Log"
  --  },
  --  l = {
  --    function() vim.lsp.codelens.run() end,
  --    "CodeLens Action",
  --  },
  --  q = {
  --    function() vim.diagnostic.setloclist() end,
  --    "Quickfix",
  --  },
--    d = { -- lsp diagnostics only for current buffer
--      function() require "telescope.builtin".diagnostics { bufnr = 0 } end,
--      "Lsp Diagnostics",
--    },
--    r = {
--      function() require "telescope.builtin".lsp_references {} end,
--      "LspReferences",
--    },
--    D = {
--      function() require "telescope.builtin".lsp_type_definitions {} end,
--      "Lsp Type Definitions",
--    },
--    i = {
--      function() require "telescope.builtin".lsp_incoming_calls {} end,
--      "Lsp InCalls",
--    },
--    o = {
--      function() require "telescope.builtin".lsp_outgoing_calls {} end,
--      "Lsp OutCalls",
--    },
--    s = {
--      function() require "telescope.builtin".lsp_document_symbols {} end,
--      "Document Symbols"
--    },
--    S = {
--      function() require "telescope.builtin".lsp_dynamic_workspace_symbols { theme = "dropdown" } end,
--      "Workspace Symbols",
--    },
--    t = {
--      function() vim.cmd.TodoTrouble {} end,
--      "TodoTrouble"
--    },
--    T = {
--      function() vim.cmd.TodoTelescope {} end,
--      "Todo in Telescope",
--    }
--  },

  -- Surround ("Pairings")
--  s = {
--    name = "Surround",
--    ["."] = {
--      function() require "surround".repeat_last() end,
--      "Repeat",
--    },
--    a = {
--      function() require "surround".surround_add(true) end,
--      "Add",
--    },
--    d = {
--      function() require "surround".surround_delete() end,
--      "Delete",
--    },
--    r = {
--      function() require "surround".surround_replace() end,
--      "Replace",
--    },
--    q = {
--      function() require "surround".toggle_quotes() end,
--      "Quotes",
--    },
--    b = {
--      function() require "surround".toggle_brackets() end,
--      "Brackets",
--    },
--  },

  -- Telescope file-browser & NvimTree
--  e = {
--    function() require "telescope".extensions.file_browser.file_browser { previewer = false, cwd = vim.fn.expand "%:p:h" } end,
--    "File Browser"
--  },
--  E = {
--    function() require "nvim-tree".toggle() end,
--    "Open Nvim-Tree window"
--  },

  -- Terminal
--  t = {
--    name = "Terminal",
--    ["1"] = { "<cmd>1ToggleTerm<CR>", "1" },
--    ["2"] = { "<cmd>2ToggleTerm<CR>", "2" },
--    ["3"] = { "<cmd>3ToggleTerm<CR>", "3" },
--    ["4"] = { "<cmd>4ToggleTerm<CR>", "4" },
--    t = {
--      function() _HTOP_TOGGLE() end,
--      "Htop",
--    },
--    l = {
--      function() _LAZYGIT_TOGGLE() end,
--      "Lazygit",
--    },
--    n = {
--      function() _NCDU_TOGGLE() end,
--      "Ncdu",
--    },
--    f = {
--      function() vim.cmd "ToggleTerm direction=float" end,
--      "Float"
--    },
--    h = {
--      function() vim.cmd "ToggleTerm size=10 direction=horizontal" end,
--      "Horizontal"
--    },
--    v = {
--      function() vim.cmd "ToggleTerm size=80 direction = vertical" end,
--      "Vertical"
--    },
--  },

  -- Debug
--  d = {
--    name = "Debug",
    -- D = {
    --   function() require("trouble").toggle() end,
    --   "Diagnostic (Trouble)"
    -- },
--    j = {
--      function() vim.diagnostic.goto_next { buffer = 0 } end,
--      "Next Diagnostic",
--    },
--    k = {
--      function() vim.diagnostic.goto_prev { buffer = 0 } end,
--      "Prev Diagnostic",
--    },
--    b = {
--      function() require "dap".toggle_breakpoint() end,
--      "Breakpoint"
--    },
--    c = {
--      function() require "dap".continue() end,
--      "Continue"
--    },
--    i = {
--      function() require "dap".step_into() end,
--      "Into"
--    },
--    o = {
--      function() require "dap".step_over() end,
--      "Over"
--    },
--    O = {
--      function() require "dap".step_out() end,
--      "Out"
--    },
--    r = {
--      function() require "dap".repl.toggle() end,
--      "Repl"
--    },
--    l = {
--      function() require "dap".run_last() end,
--      "Last"
--    },
--    u = {
--      function() require "dapui".toggle {} end,
--      "UI"
--    },
--    x = {
--      function() require "dap".terminate() end,
--      "Exit"
--    },
--  },

--  T = {
--    name = "Treesitter",
--    p = {
--      function() vim.cmd.TSPlaygroundToggle {} end,
--      "Playground"
--    },
--    h = {
--      function() vim.cmd.TSHighlightCapturesUnderCursor {} end,
--      "Highlight"
--    },
--  },

  -- Config file
--  ['0'] = {
--    name = "Configuration Files",
--    s = {
--      function()
--        vim.cmd.source "$MYVIMRC"
--        vim.notify(" Config file sourced", "Info")
--      end,
--      "Source Neovim config file",
--    },
--    e = { function() vim.cmd.edit "$NVIMDOTDIR/init.lua" end, "Edit Neovim config file" },
--    r = { function() vim.cmd.luafile "%" end, "Reload current buffer" },
--    S = {
--      "<cmd>source ~/.config/nvim/lua/user/luasnip.lua<CR>",
--      "Reload custom snippets"
--    }
--  },
--}

-- local vopts = {
--   mode = "v", -- VISUAL mode
--   prefix = "<leader>",
--   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true, -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--   nowait = true, -- use `nowait` when creating keymaps
-- }

-- local vmappings = {
--   ["/"] = {
--     function()
--       require("Comment.api").toggle.linewise.current(vim.fn.visualmode())
--     end,
--     "Comment"
--   },

  -- require("surround")
--  s = {
--    name = "Surround",
--    ["."] = {
--      function() require "surround".repeat_last() end,
--      "Repeat"
--    },
--    a = {
--      function() require "surround".surround_add(true) end,
--      "Add"
--    },
--    d = {
--      function() require "surround".surround_delete() end,
--      "Delete"
--    },
--    r = {
--      function() require "surround".surround_replace() end,
--      "Replace"
--    },
--    q = {
--      function() require "surround".toggle_quotes() end,
--      "Quotes"
--    },
--    b = {
--      function() require "surround".toggle_brackets() end,
--      "Brackets"
--    },
--  },
--  d = { [["+d]], 'Copy deletion into register "' },
--  D = { [["+D]], 'Copy deletion to end into register "' },
--  y = { [["+y]], 'Copy yank into register "' },
--  ["<BS>"] = { [["+d]], 'Copy deletion into register "' },
--  g = {
--    A = {
--      function()
--        vim.cmd.normal "!"
--        vim.ui.input({
--          prompt = "Align regex pattern: ",
--          default = nil,
--         },
--         function(input)
--           if input then
--             require "user.functions".align(input)
--           end
--         end)
--      end,
--      "Align from regex"
--    }
--  }
-- }

-- local Zopts = {
--   mode = "n", -- NORMAL mode
--   prefix = "Z",
--   buffer = nil,
--   silent = true,
--   noremap = true,
--   nowait = true,
-- }
--
-- local Zmappings = {
--   Z = { "<cmd>update<CR> <cmd>DeleteCurrentBuffer<CR>", "Save and Close buffer" },
--   Q = { "<cmd>quit!<CR>", "Close buffer and go to next" },
--   A = { ":%bdelete | :Alpha<CR>", "Close all Buffers" },
-- }

-- local i_opts = {
--   mode = "i",
--   prefix = "<C-x>",
--   buffer = nil,
--   silent = true,
--   noremap = true,
--   nowait = true,
-- }
--
-- local ins_mappings = {
--   ["<C-l>"] = "Whole lines",
--   ["<C-n>"] = "Keywords in current file",
--   ["<C-k>"] = "Keywords in dictionary",
--   ["<C-t>"] = "Keywords in thesaurus",
--   ["<C-i>"] = "Keywords in current and included files",
--   ["<C-]>"] = "Tags",
--   ["<C-f>"] = "File names",
--   ["<C-d>"] = "Definitions or macros",
--   ["<C-v>"] = "Vim command-line",
--   ["<C-u>"] = "User defined completion",
--   ["<C-o>"] = "Omni completion",
--   s = "Spelling suggestions",
-- }

-- local slime_opts = {
--   mode = "n",
--   prefix = "<leader>C",
--   buffer = nil,
--   silent = true,
--   noremap = false,
--   nowait = true,
-- }
--
-- local slime_mappings = {
--   name = "Slime (REPL)",
--   c = { function() vim.cmd.SlimeSendCurrentLine {} end, "Send Cell" },
--   v = { "<Plug>SlimeParagraphSend<CR>", "Send Paragraph" }
-- }

-- wk.register(leader_maps, opts)
-- wk.register(vmappings, vopts)
-- wk.register(Zmappings, Zopts)
-- wk.register(ins_mappings, i_opts)
-- wk.register(slime_mappings, slime_opts)
