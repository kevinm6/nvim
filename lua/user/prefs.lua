 -------------------------------------
 -- File: prefs.lua
 -- Description: NeoVim & VimR preferences
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/prefs.lua
 -- Last Modified: 15/01/2022 - 10:07
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
	-- Section: MOUSE
		mouse = 'a',

	-- Section: GRAPHIC
		termguicolors = true,
		guifont = 'Sauce Code Pro Nerd Font Complete Mono:h13', -- font for gui-apps
		clipboard = 'unnamedplus', -- allow neovim access to system clipboard
		relativenumber = true, -- Show line numbers - relativenumber from current
		showmode = true, -- show active mode in status line
		scrolloff = 4, -- # of line leave above and below cursor
		sidescrolloff = 4, -- # of columns on the sides
		mat = 2, -- tenths of second to blink during matching brackets
		visualbell = false, -- disable visual sounds
		cursorline = true, -- highlight cursor line
		showmatch = true, -- Show matching brackets when over
		signcolumn = 'yes', -- always show signcolumns
		cmdheight = 2,	-- #lines for vim for commands/logs
		pumheight = 16, -- popup menu height
		pumblend = 8, -- popup menu transparency {0..100}
		splitbelow = true, -- split below in horizontal split
		splitright = true, -- split right in vertical split
		updatetime = 300, -- set a low updatetime for better UX even w/ CoC
		listchars = { tab = "⇥ ", eol = "↲", trail = "~" },
		timeoutlen = 240,
		ttimeoutlen = 50,
		completeopt = { "menu", "menuone", "noselect"},

	-- Section: INDENTATION
		smartindent = true, -- enable smart indentation
		tabstop = 2,
		softtabstop = -1,
		shiftwidth = 0, -- set tabs

	-- Section: FOLDING
		wrap = true, -- Wrap long lines showing a linebreak
		foldenable = true, -- enable code folding
		foldmethod = 'syntax',
		diffopt = { 'internal', 'filler', 'closeoff', 'vertical' },
		foldcolumn = 'auto',	-- Add a bit extra margin to the Left

	-- Section: FILE MANAGEMENT
		autowrite = true, -- write files
		autowriteall = true, -- write files on exit or other changes
		undofile = true, -- enable undo
		backup = false, -- disable backups
		swapfile = false, -- disable swaps
		undodir = os.getenv("HOME") .. "/.cache/nvim/tmp/undo",

	-- Section: SEARCH
		smartcase = true, -- smart case for search
	}

	-- Sets all options to desired value
	for k, v in pairs(options) do
		vim.opt[k] = v
	end


	vim.opt.shortmess:append("c") -- do not pass messages to ins-completion-menu

