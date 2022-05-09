-------------------------------------
-- File         : whichkey.lua
-- Descriptions : WhichKey plugin config
-- Author       : Kevin
-- Last Modified: 09/05/2022 - 09:27
-------------------------------------

local ok, which_key = pcall(require, "which-key")
if not ok then return end

local setup = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 26,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true
    },
  },
  icons = {
    breadcrumb = ">",
    separator = "➜",
    group = "+ ",
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "shadow",
    position = "bottom",
    margin = { 1, 1, 1, 1 },
    padding = { 2, 2, 2, 2 },
    winblend = 20,
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

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}


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
        "Save, Compile & Run"
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
    [[<cmd>cd %:p:h<CR> <bar> <cmd>lua vim.notify(" Change dir to " .. vim.fn.expand("%:p:h"), "Info", { timeout = 4})<CR>]],
    "Change dir to current buffer's parent"
  },

  b = {
    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
    "Buffers",
  },
  w = { "<cmd>update!<CR>", "Save" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	z = { "<cmd>update<CR> <cmd>Bdelete<cr> <cmd>bnext<cr>", "Save and Close Buffer" },
	q = { "<cmd>quit<CR>", "Quit" },
	a = { ":Alpha<CR>", "Alpha Dashboard"},
	Z = { "<cmd>ZenMode<CR>", "Zen"},

	f = {
		name = "Find",
		f = {
			"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>",
			"Find files",
		},
		F = { "<cmd>Telescope live_grep theme=ivy<CR>", "Find Text (live grep)" },
		P = { "<cmd>Telescope projects<CR>", "Projects" },
    o = { "<cmd>Telescope<CR>", "Open Telescope" },
    b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
    c = { "<cmd>Telescope command_center<CR>", "Commands" },
    H = { "<cmd>Telescope help_tags<CR>", "Help" },
    i = { "<cmd>Telescope media_files<CR>", "Media" },
    l = { "<cmd>Telescope resume<CR>", "Last Search" },
    M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<CR>", "Recent File" },
    R = { "<cmd>Telescope registers<CR>", "Registers" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    C = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
		p = { "<cmd>TSPlaygroundToggle<CR>", "TS Playground" },
		h = { "<cmd>TSHighlightCapturesUnderCursor<CR>", "TS Highlight" },

	},
	m = {
		name = "Markdown",
		o = { "<cmd>MarkdownPreview <CR>", "Start MarkdownPreview" },
		s = { "<cmd>MarkdownPreviewStop <CR>", "Stop MarkdownPreview" },
		t = { "<cmd>MarkdownPreviewToggle <CR>", "Toggle MarkdownPreview" },
		m = { "<cmd>Glow <CR>", "Floating Markdown Preview (Glow)" }
	},

  -- Renamer
	r = { '<cmd>lua require("renamer").rename({empty = false})<CR>', "Renamer" },

  -- Packer
  p = {
    name = "Packer",
    C = { "<cmd>PackerCompile<CR>", "Compile" },
    c = { "<cmd>PackerClean<CR>", "Clean" },
    i = { "<cmd>PackerInstall<CR>", "Install" },
    S = { "<cmd>PackerSync<CR>", "Sync" },
    s = { "<cmd>PackerStatus<CR>", "Status" },
    u = { "<cmd>PackerUpdate<CR>", "Update" },
  },

  -- Git
	g = {
    name = "Git",
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
    l = { "<cmd>GitBlameToggle<CR>", "Blame" },
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
    d = { "<cmd>Gitsigns diffthis HEAD<CR>", "Diff", },
	},

  -- SnipRun
	S = {
    name = "SnipRun",
    c = { "<cmd>SnipClose<cr>", "Close" },
    f = { "<cmd>%SnipRun<cr>", "Run File" },
    i = { "<cmd>SnipInfo<cr>", "Info" },
    m = { "<cmd>SnipReplMemoryClean<cr>", "Mem Clean" },
    r = { "<cmd>SnipReset<cr>", "Reset" },
    t = { "<cmd>SnipRunToggle<cr>", "Toggle" },
    x = { "<cmd>SnipTerminate<cr>", "Terminate" },
	},

  -- LSP
  l = {
    name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
		d = { "<cmd>TroubleToggle<CR>", "Diagnostics" },
    w = {
      "<cmd>Telescope lsp_workspace_diagnostics<CR>",
      "Workspace Diagnostics",
    },
    f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
    F = { "<cmd>LspToggleAutoFormat<CR>", "Toggle Autoformat" },
    i = { "<cmd>LspInfo<CR>", "Info" },
    I = { "<cmd>LspInstallInfo<CR>", "Installer Info" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<CR>", "CodeLens Action" },
    o = { "<cmd>SymbolsOutline<CR>", "Outline" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    R = { "<cmd>TroubleToggle lsp_references<CR>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
      "Workspace Symbols",
    },
	},

  F = {
    name = "Filetypes ops",
    c = {
      name = "[ c ]",
      c = {
        "<cmd>cd %:p:h<CR> <cmd>update<CR> <cmd>r!gcc % -o %< <CR> <cmd>NvimTreeRefresh<CR>",
        "Save & Compile"
      },
      r = { "<cmd>cd %:p:h<CR> :call Scratch() <bar> :r!./#< <CR>", "Run program" },
      C = {
        "<cmd>cd %:p:h<CR> <cmd>update<CR> <cmd>!gcc % -o %< <CR> <cmd>NvimTreeRefresh<CR> :call Scratch() <bar> :r!./#< <CR>",
        "Compile & Run"
      },
    }
  },


	-- SURROUND
	s = {
    name = "Surround",
    ["."] = { "<cmd>lua require('surround').repeat_last()<CR>", "Repeat" },
    a = { "<cmd>lua require('surround').surround_add(true)<CR>", "Add" },
    d = { "<cmd>lua require('surround').surround_delete()<CR>", "Delete" },
    r = { "<cmd>lua require('surround').surround_replace()<CR>", "Replace" },
    q = { "<cmd>lua require('surround').toggle_quotes()<CR>", "Quotes" },
    b = { "<cmd>lua require('surround').toggle_brackets()<CR>", "Brackets" },
  },

	-- NVIMTREE
 	E = { "<cmd>NvimTreeToggle<CR>", "Nvim-Tree" },
 	e = {
 		name = "Nvim-Tree",
 		r = { "<cmd>NvimTreeRefresh<CR>", "Refresh Nvim-Tree" },
 		o = { "<cmd>NvimTreeOpen<CR>", "Open Nvim-Tree window" },
 		t = { "<cmd>NvimTreeToggle<CR>", "Toggle Nvim-Tree" },
 		f = { "<cmd>NvimTreeFocus<CR>", "Focus file in Nvim-Tree" },
 		c = { "<cmd>NvimTreeClose<CR>", "Close Nvim-Tree window" },
 		C = { "<cmd>NvimTreeClipboard<CR>", "Show Nvim-Tree clipboard" },
 	},

	-- Terminal
	t = {
		name = "Terminal",
    ["1"] = { "<cmd>1ToggleTerm<CR>", "1" },
    ["2"] = { "<cmd>2ToggleTerm<CR>", "2" },
    ["3"] = { "<cmd>3ToggleTerm<CR>", "3" },
    ["4"] = { "<cmd>4ToggleTerm<CR>", "4" },
    t = { "<cmd>lua _HTOP_TOGGLE()<CR>", "Htop" },
    l = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    n = { "<cmd>lua _NCDU_TOGGLE()<CR>", "Ncdu" },
    f = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
	},


  -- Debug
   d = {
     name = "Debug",
     b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Breakpoint" },
     c = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
     i = { "<cmd>lua require'dap'.step_into()<CR>", "Into" },
     o = { "<cmd>lua require'dap'.step_over()<CR>", "Over" },
     O = { "<cmd>lua require'dap'.step_out()<CR>", "Out" },
     r = { "<cmd>lua require'dap'.repl.toggle()<CR>", "Repl" },
     l = { "<cmd>lua require'dap'.run_last()<CR>", "Last" },
     u = { "<cmd>lua require'dapui'.toggle()<CR>", "UI" },
     x = { "<cmd>lua require'dap'.terminate()<CR>", "Exit" },
   },

  -- Config file
	[0] = {
    name = "Configuration Files",
    s = {
      [[<cmd>source $NVIMDOTDIR/init.lua<CR> <bar> <cmd>lua require("notify")(" Config file sourced", "Info")<cr> ]],
      "Source Neovim config file"
    },
    e = { "<cmd>edit $NVIMDOTDIR/init.lua<CR>", "Edit Neovim config file" },
    S = {
      [[<cmd>lua require("luasnip.loaders.from_vscode").load { paths = { ("./lua/") } } <CR> <bar> <cmd>lua require("notify")(" Snippets file sourced", "Info")<cr> ]],
      "Reload snippet file"
    },
    ["."] = { "<cmd>source %<CR>", "Source current buffer" },
  }
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
  ["/"] = { [[<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>]], "Comment" },

	-- SURROUND
	s = {
    name = "Surround",
    ["."] = { "<cmd>lua require('surround').repeat_last()<CR>", "Repeat" },
    a = { "<cmd>lua require('surround').surround_add(true)<CR>", "Add" },
    d = { "<cmd>lua require('surround').surround_delete()<CR>", "Delete" },
    r = { "<cmd>lua require('surround').surround_replace()<CR>", "Replace" },
    q = { "<cmd>lua require('surround').toggle_quotes()<CR>", "Quotes" },
    b = { "<cmd>lua require('surround').toggle_brackets()<CR>", "Brackets" },
  },
  d = { [["+d]], "Copy deletion into register \"" },
	D = { [["+D]], "Copy deletion to end into register \"" },
	y = { [["+y]], "Copy yank into register \"" },
  ["<BS>"] = { [["+d]], "Copy deletion into register \"" },
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
  ["<C-l>"] = { "<C-x><C-l>", "Whole lines" },
  ["<C-n>"] = { "<C-x><C-n>", "Keywords in current file" },
  ["<C-k>"] = { "<C-x><C-k>", "Keywords in dictionary" },
  ["<C-t>"] = { "<C-x><C-t>", "Keywords in thesaurus" },
  ["<C-i>"] = { "<C-x><C-i>", "Keywords in current and included files" },
  ["<C-]>"] = { "<C-x><C-]>", "Tags" },
  ["<C-f>"] = { "<C-x><C-f>", "File names" },
  ["<C-d>"] = { "<C-x><C-d>", "Definitions or macros" },
  ["<C-v>"] = { "<C-x><C-v>", "Vim command-line" },
  ["<C-u>"] = { "<C-x><C-u>", "User defined completion" },
  ["<C-o>"] = { "<C-x><C-o>", "Omni completion" },
  s = { "<C-x>s", "Spelling suggestions" }
}


which_key.setup(setup)
which_key.register(leader_maps, opts)
which_key.register(nonLeader_maps, noLeader_opts)
which_key.register(vmappings, vopts)
which_key.register(Zmappings, Zopts)
which_key.register(ins_mappings, i_opts)

