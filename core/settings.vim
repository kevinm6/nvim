" ------------------------------------
" File: settings.vim
" Description: VimR & NeoVim settings
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/settings.vim
" Last Modified: 25.11.21 10:26
" ------------------------------------


" Section: GUI MANAGEMENT {
	try | colorscheme k_theme | catch "⚠️  Error loading colorscheme" | endtry
	set display="lastline,msgsep"
	set termguicolors
" }


" Section: CURSOR {
	 "Cursor settings:
		"  1 -> blinking block
		"  2 -> solid block 
		"  3 -> blinking underscore
		"  4 -> solid underscore
		"  5 -> blinking vertical bar
		"  6 -> solid vertical bar
	if $TERM_PROGRAM =~ "iTerm"
		let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block Bar Normal Mode
		let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical Bar Insert Mode
		let &t_SR = "\<Esc>]50;CursorShape=2\x7" " Underline Replace Mode
	elseif $TERM_PROGRAM == "Apple_Terminal"
		let &t_SI.="\e[5 q" "SI = INSERT mode
		let &t_SR.="\e[4 q" "SR = REPLACE mode
		let &t_EI.="\e[1 q" "EI = NORMAL mode
	elseif $TERM_PROGRAM == "vscode"
	  finish
	endif
" }


" Section: MOUSE {
	set mouse=a
" }


" Section: AutoCommands {
 	augroup AutoSaveGroup
	  au!
	  " view files are about 500 bytes
	  " bufleave but not bufwinleave captures closing 2nd tab
	  " nested is needed by bufwrite* (if triggered via other autocmd)
	  " BufHidden for compatibility with `set hidden`
	  au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
	  au BufWinEnter ?* silent! loadview
	  au CursorHold, BufEnter * :checktime
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

	autocmd CursorHold * silent call CocActionAsync('highlight')
" }


" Section: GRAPHIC {
	set number " Show line numbers
	set showmode " show active mode in status line
	if !&scrolloff
		set scrolloff=3 " # of line leave above and below cursor
	endif
	set mat=2 " tenths of second to blink during matching brackets
	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set cursorline " highlight cursor line
	set showmatch " Show matching brackets when over
	set tw=200	" Linebreak on 400 characters
	set signcolumn=yes " always show signcolumns
	set cmdheight=2	" #lines for vim for commands/logs
	set pumheight=16 " popup menu height
	set splitbelow splitright " set defaults splitting position
	set updatetime=300 " set a low updatetime for better UX even w/ CoC
	set shortmess+=c " do not pass messages to ins-completion-menu
	set timeoutlen=500
	set ttimeoutlen=50
" }


" Section: INDENTATION {
	set smartindent " enable smart indentation
	set tabstop=2 softtabstop=-1 shiftwidth=0 " set tabs
" }


" Section: FOLDING {
	set wrap " Wrap long lines
	set wrapmargin=68
	set foldenable " enable code folding
	set foldmethod=syntax
	set viewoptions=folds,cursor
	set sessionoptions=folds
	set foldcolumn=0	" Add a bit extra margin to the Left
" }


" Section: FILE MANAGEMENT {
	set clipboard=unnamedplus
	set autowrite " write files
	set autowriteall " write files on exit or other changes
	set autochdir " auto change directory of explore
	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	if !isdirectory(expand(&undodir)) " check undo dir
		call mkdir(expand(&undodir), "p")
	endif
" }

" Section: SEARCH {
	set smartcase " smart case for search
	set inccommand=nosplit
	set gdefault " use 'g' flag by default w/ :s/<toChange>/<as>/
" }


" Section: SESSION {
	let g:session_autosave = 'yes'
	let g:session_autoload = 'yes'
  let g:session_default_to_last = 1
" }


" Section: NETRW {
	let g:netrw_banner = 0 " disabling banner
	let g:netrw_preview = 1 " preview window in vertical split instead of horizontal
	let g:netrw_liststyle = 3 " set tree as default list appearance
	let g:netrw_browse_split = 1 " open files in vertical split
	let g:netrw_silent = 1 " transfers silently (no statusline changes when obtaining files
	let g:netrw_winsize = 26
	let g:netrw_keepdir = 0 " current dir & browsing dir synced
	let g:netrw_localcopydircmd = 'cp -r' " enable recursive copy command
	let g:netrw_mousemaps = 1
	"highlight marked files
	hi! link netrwMarkFile Search 
" }


" Section: STATUS LINE {
	set statusline=%1*\|%n\⟩\%2*\ %{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\%1*⟩\ %<%f\%3*\ \%4*▶︎
	set statusline+=%=%4*\◀︎\%1*\ %y\ %3*⟨\ %{&ff}\ ⟨\ %l\:%c\/%L\ \|
" }


" Section: FUNCTIONS {
	function! CreateInPreview()
		let l:filename = input("> Enter filename: ")
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

	function! s:show_documentation() " Coc Show Documentation
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction
" }

