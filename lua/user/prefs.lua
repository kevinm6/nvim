 -------------------------------------
 -- File: prefs.lua
 -- Description: NeoVim & VimR preferences
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/prefs.lua
 -- Last Modified: 15/03/2022 - 16:17
 -------------------------------------


-- Section: CURSOR {
	vim.opt.guicursor = { -- cursor shape mode-based
		"n-v-c:block",
		"i-ci-ve:ver25",
		"r-cr:hor20,o:hor50"
	}
-- }


-- Section: Colorscheme
	vim.api.nvim_exec('colorscheme k_theme', true)
-- }


	local options = {
		shell="/bin/bash",
	-- Section: MOUSE
		mouse = 'a',
    fileencoding = "utf-8",

	-- Section: GRAPHIC
		termguicolors = true,
		guifont = "Sauce Code Pro Nerd Font Complete Mono:h13", -- font for gui-apps
		clipboard = "unnamedplus", -- allow neovim access to system clipboard
		relativenumber = true, -- Show line numbers - relativenumber from current
		showmode = true, -- show active mode in status line
		scrolloff = 6, -- # of line leave above and below cursor
		sidescrolloff = 6, -- # of columns on the sides
		mat = 2, -- tenths of second to blink during matching brackets
		visualbell = false, -- disable visual sounds
		cursorline = true, -- highlight cursor line
		showmatch = true, -- Show matching brackets when over
		signcolumn = "yes", -- always show signcolumns
		cmdheight = 2,	-- #lines for vim for commands/logs
		pumheight = 16, -- popup menu height
		pumblend = 8, -- popup menu transparency {0..100}
		splitbelow = true, -- split below in horizontal split
		splitright = true, -- split right in vertical split
		updatetime = 300, -- lower than default for faster completion
		listchars = { tab = "⇥ ", eol = "↲", trail = "~", space = "_" },
		timeoutlen = 100,
		ttimeoutlen = 50,
		lazyredraw = true,
		completeopt = { "menu", "menuone", "noselect"},
		matchpairs = vim.opt.matchpairs:append("<:>"),
		wildignore = {
			"*.DS_Store",
			"*.bak",
			"*.gif",
			"*.jpeg",
			"*.jpg",
			"*.png",
			"*.swp",
			"*.zip",
			"*/.git/*",
		},
		shortmess = vim.opt.shortmess:append("c"), -- do not pass messages to ins-completion-menu

	-- Section: INDENTATION
		smartindent = true, -- enable smart indentation
		tabstop = 2,
		softtabstop = -1,
		expandtab = true, -- convert tabs to spaces
		shiftwidth = 2, -- number of spaces for indentation

	-- Section: FOLDING
		wrap = false, -- Wrap long lines showing a linebreak
		foldenable = true, -- enable code folding
		foldmethod = "syntax",
		diffopt = { "internal", "filler", "closeoff", "vertical" },
		foldcolumn = "auto",	-- Add a bit extra margin to the Left
    colorcolumn = "120",

	-- Section: FILE MANAGEMENT
		autowrite = true, -- write files
		autowriteall = true, -- write files on exit or other changes
		undofile = true, -- enable undo
		backup = false, -- disable backups
		swapfile = false, -- disable swaps
		undodir = vim.fn.expand("~/.cache/nvim/tmp/undo"),

	-- Section: SEARCH
		smartcase = true, -- smart case for search
    ignorecase = true,

    whichwrap = vim.opt.whichwrap:append { "<",">","[","]","h","l" },
    formatoptions = vim.opt.formatoptions:remove { "c","r","o" }
	}

	-- Sets all options to desired value
	for k, v in pairs(options) do
		vim.opt[k] = v
	end

