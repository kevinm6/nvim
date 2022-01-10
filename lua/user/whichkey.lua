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
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 26, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  icons = {
    breadcrumb = ">", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+ ", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "shadow", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 8,
  },
  layout = {
    height = { min = 4, max = 24 }, -- min and max height of the columns
    width = { min = 20, max = 46 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  -- triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
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

	["<C-n>"] = {
		name = "Nvim-Tree",
		r = { "<cmd>NvimTreeRefresh<cr>", "Refresh Nvim-Tree" },
		o = { "<cmd>NvimTreeOpen<cr>", "Open Nvim-Tree window" },
		c = { "<cmd>NvimTreeClose<cr>", "Close Nvim-Tree window" },
		C = { "<cmd>NvimTreeClipboard<cr>", "Show Nvim-Tree clipboard" },
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


which_key.setup(setup)
which_key.register(leader_maps, opts)
which_key.register(nosilent_maps, nosilent_opts)
