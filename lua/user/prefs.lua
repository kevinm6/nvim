 -------------------------------------
 -- File: prefs.lua
 -- Description: VimR & NeoVim settings in lua
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 17/12/21 - 09:48
 -------------------------------------

HOME = os.getenv("HOME")
local set = vim.opt
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
	vim.cmd([[
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
	]])
-- }


-- Section: MOUSE {
	set.mouse = 'a'
-- }


-- Section: AutoCommands {
	vim.cmd([[
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

		au BufWritePre * %s/\s+$//e

		" Markdown
		au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setf markdown
		
		" SQL
		au BufNewFile, BufRead psql* setf sql

		" Pseudo
		au BufRead,BufNewFile *.pseudo setf pseudo

		command! Scratch lua require'tool'.makeScratch()
	]])
-- }


-- Section: GRAPHIC
	vim.cmd 'colorscheme k_theme'
	set.termguicolors = true
	set.guifont = 'Source Code Pro:h13' -- { "Hack Nerd Font Mono:h14" }
	set.relativenumber = true -- Show line numbers - relativenumber from current
	set.showmode = true -- show active mode in status line
	set.scrolloff = 3 -- # of line leave above and below cursor
	set.mat = 2 -- tenths of second to blink during matching brackets
	set.visualbell = false -- disable visual sounds
	set.cursorline = true -- highlight cursor line
	set.showmatch = true -- Show matching brackets when over
	set.signcolumn = 'yes' -- always show signcolumns
	set.cmdheight = 2	-- #lines for vim for commands/logs
	set.pumheight = 16 -- popup menu height
	set.pumblend = 8 -- popup menu transparency {0..100}
	set.splitbelow = true -- split below in horizontal split
	set.splitright = true -- split right in vertical split
	set.updatetime = 300 -- set a low updatetime for better UX even w/ CoC
	set.shortmess:append("c") -- do not pass messages to ins-completion-menu
	set.listchars = { tab = ":▸ ", eol = "↲", trail = "~" }
	set.timeoutlen = 200
	set.ttimeoutlen = 50
	set.completeopt = { "menu", "menuone", "noselect"}
-- }


-- Section: INDENTATION {
	set.smartindent = true -- enable smart indentation
	set.tabstop = 2
	set.softtabstop = -1
	set.shiftwidth = 0 -- set tabs
-- }


-- Section: FOLDING {
	set.wrap = true -- Wrap long lines showing a linebreak
	set.foldenable = true -- enable code folding
	set.foldmethod = 'syntax'
	set.diffopt = { 'internal', 'filler', 'closeoff', 'vertical' }
	set.foldcolumn = 'auto'	-- Add a bit extra margin to the Left
-- }


-- Section: FILE MANAGEMENT {
	set.autowrite = true -- write files
	set.autowriteall = true -- write files on exit or other changes
	set.autochdir = true -- auto change directory of explore
	set.undofile = true -- enable undo
	set.backup = false -- disable backups
	set.swapfile = false -- disable swaps
	set.undodir = HOME .. "/.cache/nvim/tmp/undo"
-- }


-- Section: SEARCH {
	set.smartcase = true -- smart case for search
-- }


-- Section: FUNCTIONS {
	vim.cmd([[
	function! CreateInPreview()
		let l:filename = input("⟩ Enter filename: ")
		execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf
	]])

-- }
