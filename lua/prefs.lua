 -------------------------------------
 -- File: prefs.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 05.12.21 02:02
 -------------------------------------

 HOME = os.getenv("HOME")

-- Section: CURSOR {
	 -- Cursor settings:
		-- 1 -> blinking block
		-- 2 -> solid block 
		-- 3 -> blinking underscore
		-- 4 -> solid underscore
		-- 5 -> blinking vertical bar
		-- 6 -> solid vertical bar
		-- SI = INSERT mode
		-- SR = REPLACE mode
		-- EI = NORMAL mode
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
-- }


-- Section: MOUSE {
	vim.o.mouse = 'a'
-- }


-- Section: AutoCommands {
	vim.cmd([[
	augroup AutoSaveGroup
			au!
			au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
			au BufWinEnter ?* silent! loadview
			au CursorHold, BufEnter * :checktime
		augroup end

		au filetype netrw call Netrw_mappings()
		function! Netrw_mappings()
			noremap <buffer>% :call CreateInPreview()<cr>
		endfunction

		au BufWritePre * %s/\s+$//e

		-- Markdown
		au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setf markdown
		
		-- SQL
		au BufNewFile, BufRead psql* setf sql

		-- Automation for coc-syntax using omnifunc
		if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
					\	if &omnifunc == "" |
					\		setlocal omnifunc=syntaxcomplete#Complete |
					\	endif
		endif
	]])
	-- autocmd CursorHold * silent call CocActionAsync('highlight')
-- }


-- Section: GRAPHIC {
	vim.cmd('try | colorscheme k_theme | catch \'⚠️  Error loading colorscheme\' | endtry')
	vim.o.termguicolors
	vim.o.relativenumber = true -- Show line numbers - relativenumber from current
	vim.o.showmode = true -- show active mode in status line
	vim.o.scrolloff = 3 -- # of line leave above and below cursor
	vim.o.mat = 2 -- tenths of second to blink during matching brackets
	vim.o.visualbell = false -- disable visual sounds
	vim.o.cursorline = true -- highlight cursor line
	vim.o.showmatch = true -- Show matching brackets when over
	vim.o.signcolumn = true -- always show signcolumns
	vim.o.cmdheight = 2	-- #lines for vim for commands/logs
	vim.o.pumheight = 16 -- popup menu height
	vim.o.splitbelow = true -- split below in horizontal split
	vim.o.splitright = true -- split right in vertical split
	vim.o.updatetime = 300 -- set a low updatetime for better UX even w/ CoC
	vim.o.shortmess += c -- do not pass messages to ins-completion-menu
	vim.o.timeoutlen = 500
	vim.o.ttimeoutlen = 50
	vim.o.completeopt = 'menu,menuone,noselect'
-- }


-- Section: INDENTATION {
	vim.o.smartindent -- enable smart indentation
	vim.o.tabstop = 2 
	vim.o.softtabstop = -1 
	vim.o.shiftwidth = 0 -- set tabs
-- }


-- Section: FOLDING {
	vim.o.wrap = true -- Wrap long lines showing a linebreak
	vim.o.foldenable = true -- enable code folding
	vim.o.foldmethod = 'diff'
	vim.o.diffopt = 'internal,filler,closeoff,vertical'
	vim.o.foldcolumn = 0	-- Add a bit extra margin to the Left
-- }


-- Section: FILE MANAGEMENT {
	vim.o.autowrite = true -- write files
	vim.o.autowriteall = true -- write files on exit or other changes
	vim.o.autochdir = true -- auto change directory of explore
	vim.o.undofile = true -- enable undo
	vim.o.backup = false -- disable backups
	vim.o.swapfile = false -- disable swaps
	vim.o.backupdir = HOME .. '.local/nvim/'
-- }

-- Section: SEARCH {
	vim.o.smartcase = true -- smart case for search
-- }


-- Section: STATUS LINE {
	-- Left Side
	set statusline=%1*%n⟩
	set statusline+=%2*\ %{get(g:,'coc_git_status','')}
	set statusline+=%{get(b:,'coc_git_status','')}
	set statusline+=%{get(b:,'coc_git_blame','')}
	set statusline+=%1*\ ⟩\ %m\ %<%f\  
	set statusline+=%4*
	-- Right Side
	set statusline+=%=%4*
	set statusline+=%3*\ %{&fileencoding?&fileencoding:&encoding}
	set statusline+=%1*\ %y
	set statusline+=%3*\ ⟨\ %{&ff}
	set statusline+=\ ⟨\ %l\:%L\ 
-- }


" Section: FUNCTIONS {
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
	-- function! s:show_documentation() " Coc Show Documentation
	-- 	if (index(['vim','help'], &filetype) >= 0)
	-- 		execute 'h '.expand('<cword>')
	-- 	elseif (coc#rpc#ready())
	-- 		call CocActionAsync('doHover')
	-- 	else
	-- 		execute '!' . &keywordprg . " " . expand('<cword>')
	-- 	endif
	-- endfunction
-- }

