 -------------------------------------
 -- File: prefs.lua
 -- Description: VimR & NeoVim settings in lua
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 20/12/21 - 09:41
 -------------------------------------

vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Section: CURSOR {
	-- 1 -> blinking block
	-- 2 -> solid block
	-- 3 -> blinking underscore
	-- 4 -> solid underscore
	-- 5 -> blinking vertical bar
	-- 6 -> solid vertical bar
	-- SI = INSERT mode
	-- SR = REPLACE mode
	-- EI = NORMAL mode
	vim.api.nvim_exec([[
		if $TERM_PROGRAM =~ "iTerm"
			let &t_EI = "\<Esc>]50;CursorShape=0\x7"
			let &t_SI = "\<Esc>]50;CursorShape=1\x7"
			let &t_SR = "\<Esc>]50;CursorShape=2\x7"
		if $TERM_PROGRAM == "Apple_Terminal"
			let &t_SI.="\e[5 q"
			let &t_SR.="\e[4 q"
			let &t_EI.="\e[1 q"
		if $TERM_PROGRAM == "vscode"
			finish
		end

		" AutoCommands
		augroup AutoSaveGroup
			au!
			au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
			au BufWinEnter ?* silent! loadview
			au CursorHold, BufEnter * :checktime
			au TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", timeout=400}
		augroup end

		au filetype netrw call Netrw_mappings()
		function! Netrw_mappings()
			noremap <buffer>% :call CreateInPreview()<cr>
		endfunction

		function! CreateInPreview()
			let l:filename = input("⟩ Enter filename: ")
			execute 'splitbelow ' . b:netrw_curdir.'/'.l:filename
		endf

		" Remove trailing spaces on writing file
		au BufWritePre * %s/\s+$//e

		" Markdown
		au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setlocal filetype markdown
		
		" SQL
		au BufNewFile, BufRead psql* setlocal filetype sql

		" Pseudo
		au BufRead,BufNewFile *.pseudo setlocal filetype pseudo

		command! Scratch lua require'tool'.makeScratch()
		]], true)
 -- }

-- Section: Colorscheme
	vim.api.nvim_exec('colorscheme k_theme', true)
-- }

	local options = {
	-- Section: MOUSE {
		mouse = 'a',
	-- }

	-- Section: GRAPHIC
		termguicolors = true,
		guifont = 'Source Code Pro:h13', -- { "Hack Nerd Font Mono:h14" }
		relativenumber = true, -- Show line numbers - relativenumber from current
		showmode = true, -- show active mode in status line
		scrolloff = 3, -- # of line leave above and below cursor
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
	-- }

	-- Section: INDENTATION {
		smartindent = true, -- enable smart indentation
		tabstop = 2,
		softtabstop = -1,
		shiftwidth = 0, -- set tabs
	-- }

	-- Section: FOLDING {
		wrap = true, -- Wrap long lines showing a linebreak
		foldenable = true, -- enable code folding
		foldmethod = 'syntax',
		diffopt = { 'internal', 'filler', 'closeoff', 'vertical' },
		foldcolumn = 'auto',	-- Add a bit extra margin to the Left
	-- }

	-- Section: FILE MANAGEMENT {
		autowrite = true, -- write files
		autowriteall = true, -- write files on exit or other changes
		autochdir = true, -- auto change directory of explore
		undofile = true, -- enable undo
		backup = false, -- disable backups
		swapfile = false, -- disable swaps
		undodir = os.getenv("HOME") .. "/.cache/nvim/tmp/undo",
	-- }

	-- Section: SEARCH {
		smartcase = true, -- smart case for search
	-- }
	}

	-- Setting value
	for k, v in pairs(options) do
		vim.opt[k] = v
	end

	vim.opt.shortmess:append("c") -- do not pass messages to ins-completion-menu

