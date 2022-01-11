-------------------------------------
-- File: whichkey.lua
-- Descriptions:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/whichkey.lua
-- Help-Source: https://github.com/ChristianChiarulli/nvim/lua/user/which_key.lua
-- Last Modified: 29/12/21 - 20:12
-------------------------------------

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 26,
    },
    presets = {
      operators = false,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
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
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 8,
  },
  layout = {
    height = { min = 4, max = 24 },
    width = { min = 20, max = 46 },
    spacing = 3,
    align = "center",
  },
  ignore_missing = false,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,
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

local nosilent_opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = false,
  noremap = true,
  nowait = true,
}

local leader_maps = {
  w = { "<cmd>w!<CR>", "Save" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  c = { "<cmd>bdelete!<CR>", "Close Buffer" },

	f = {
		name = "Find (Telescope)",
		f = {
			"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			"Find files",
		},
		F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text (live grep)" },
		P = { "<cmd>Telescope projects<cr>", "Projects" },
		b = {
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			"Buffers",
		},
	},

  -- Renamer
	R = { '<cmd>lua require("renamer").rename()<cr>', "Renamer" },

  -- Packer
  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    S = { "<cmd>PackerSync<cr>", "Sync" },
    s = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  -- Git
	g =  {
		name = "Git",
		s = { "<cmd>Git status<cr>", "Git status in cmdline" },
		g = { "<cmd>Git<cr>", "Git summary" },
		A = { "<cmd>Git add .<cr>", "Git add folder" },
		d = { "<cmd>Git df %<cr>", "Git diff current file" },
		D = { "<cmd>Git df<cr>", "Git diff" },
		p = { "<cmd>Git push<cr>", "Git push" },
	},

  -- Telescope & Gitsigns
	G = {
    name = "GitSigns & Telescope-git",
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>GitBlameToggle<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff", },
	},

  -- Skeletons
	s = {
    name = "Skeletons",
		h = {
			"<cmd>1-read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a",
			"Create Html skeleton"
		},
		c = {
			":1-read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja",
			"Create C skeleton"
		},
		j = { ":1-read $NVIMDOTDIR/snippets/skeleton.java<CR>2jA<Left><Left><C-r>%<Esc>d2b2jo",
			"Create java skeleton"
		},
		f = {
      name = "Functions",
			j = {
        ":1-read $NVIMDOTDIR/snippets/method.java<CR>6jf(i",
			  "Create java function skeleton"
      },
		},
		i = {
			":1-read $NVIMDOTDIR/snippets/skeleton.info<CR>v}gc<Esc>gg<Esc>jA<C-r>%<Esc>4jA<F2><Esc>3kA",
			"Create info skeleton"
		},
		m = {
			":1-read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go",
			"Create markdown skeleton"
		},
	},

  -- Telescope
  t = {
    name = "Telescope",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Help" },
    i = { "<cmd>Telescope media_files<cr>", "Media" },
    l = { "<cmd>Telescope resume<cr>", "Last Search" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
		p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
  },

  -- LSP
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>TroubleToggle<cr>", "Diagnostics" },
    w = {
      "<cmd>Telescope lsp_workspace_diagnostics<cr>",
      "Workspace Diagnostics",
    },
    f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
    F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    j = {
      "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    o = { "<cmd>SymbolsOutline<cr>", "Outline" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
		},
  },

	-- NVIMTREE
	e = {
		name = "Nvim-Tree",
		r = { "<cmd>NvimTreeRefresh<cr>", "Refresh Nvim-Tree" },
		o = { "<cmd>NvimTreeOpen<cr>", "Open Nvim-Tree window" },
		c = { "<cmd>NvimTreeClose<cr>", "Close Nvim-Tree window" },
		C = { "<cmd>NvimTreeClipboard<cr>", "Show Nvim-Tree clipboard" },
	},

	-- Terminal
	T = {
		name = "Terminal",
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},

  -- Deletion
	d = { "\"*d", "Copy deletion into register \"" },
	D = { "\"*D", "Copy deletion to end into register \"" },
	y = { "\"*y", "Copy yank into register \"" },
	x = { "\"*d", "Copy char deletion into register \"" },
}

local nosilent_maps = {
	g = {
		c = { ":Git commit -m \"\"<Left>", "Git commit" },
		C = {
      ":Git add % <bar> Git commit -m \"\"<Left>",
      "Git add current file and commit"
    },
	},
	[0] = {
    name = "Configuration File",
    s = { ":source $NVIMDOTDIR/init.lua<cr>", "Source Neovim config file" },
    e = { ":edit $NVIMDOTDIR/init.lua<cr>", "Edit Neovim config file" },
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
  ["/"] = { "<ESC><CMD>lua require(\"Comment.api\").toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },
}

which_key.setup(setup)
which_key.register(leader_maps, opts)
which_key.register(nosilent_maps, nosilent_opts)
which_key.register(vmappings, vopts)
