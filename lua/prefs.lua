 -------------------------------------
 -- File: prefs.lua
 -- Description: VimR & NeoVim settings in lua
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 05.12.21 04:50
 -------------------------------------

HOME = os.getenv("HOME")
local set = vim.opt

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
			au BufWritePost lua/plug.lua PackerCompile
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

		" Automation for coc-syntax using omnifunc
		if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
					\	if &omnifunc == "" |
					\		setlocal omnifunc=syntaxcomplete#Complete |
					\	endif
		endif
	]])
-- }


-- Section: GRAPHIC {
	vim.cmd 'colorscheme k_theme'
	set.termguicolors = true
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
	set.splitbelow = true -- split below in horizontal split
	set.splitright = true -- split right in vertical split
	set.updatetime = 300 -- set a low updatetime for better UX even w/ CoC
	set.shortmess:append("c") -- do not pass messages to ins-completion-menu
	set.listchars = { tab = ":▸ ", eol = "↲", trail = "~" }
	set.timeoutlen = 500
	set.ttimeoutlen = 50
	set.completeopt = 'menu,menuone,noselect'
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
	set.foldmethod = 'diff'
	set.diffopt = 'internal,filler,closeoff,vertical'
	set.foldcolumn = 'auto'	-- Add a bit extra margin to the Left
-- }


-- Section: FILE MANAGEMENT {
	set.autowrite = true -- write files
	set.autowriteall = true -- write files on exit or other changes
	set.autochdir = true -- auto change directory of explore
	set.undofile = true -- enable undo
	set.backup = false -- disable backups
	set.swapfile = false -- disable swaps
	set.backupdir = HOME .. "/.local/nvim/"
-- }


-- Section: SEARCH {
	set.smartcase = true -- smart case for search
-- }


-- Section: STATUS LINE {
	local stl = {
	-- Left Side
		"%1*%n⟩",
		'%2*  %{FugitiveStatusline()}',
		'%1* ⟩ %m %<%f  ',
		'%4*',
	-- Right Side
		'%=%4*',
		'%3* %{&fileencoding?&fileencoding:&encoding}',
		'%1* %y',
		'%3* ⟨ %{&ff}',
		"= ⟨ %l:%L "
	}
	set.statusline = table.concat(stl)
-- }


-- Section: FUNCTIONS {
	vim.cmd([[
	function! CreateInPreview()
		let l:filename = input("⟩ Enter filename: ")
		execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf

	function! Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted
    "lcd ~
    file scratch
	endf
	]])
-- }
