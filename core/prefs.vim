" ------------------------------------
" File: settings.vim
" Description: VimR & NeoVim settings
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/settings.vim
" Last Modified: 04/12/21 - 11:31
" ------------------------------------


" Section: CURSOR {
	 "Cursor settings:
		"  1 -> blinking block
		"  2 -> solid block 
		"  3 -> blinking underscore
		"  4 -> solid underscore
		"  5 -> blinking vertical bar
		"  6 -> solid vertical bar
		"SI = INSERT mode
		"SR = REPLACE mode
		"EI = NORMAL mode
	if $TERM_PROGRAM =~ "iTerm"
		let &t_EI = "\<Esc>]50;CursorShape=0\x7"
		let &t_SI = "\<Esc>]50;CursorShape=1\x7"
		let &t_SR = "\<Esc>]50;CursorShape=2\x7"
	elseif $TERM_PROGRAM == "Apple_Terminal"
		let &t_SI.="\e[5 q"
		let &t_SR.="\e[4 q"
		let &t_EI.="\e[1 q"
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

	" autocmd CursorHold * silent call CocActionAsync('highlight')
" }


" Section: GRAPHIC {
	try | colorscheme k_theme | catch "⚠️  Error loading colorscheme" | endtry
	set termguicolors
	set number relativenumber " Show line numbers - relativenumber from current
	set showmode " show active mode in status line
	set scrolloff=3 " # of line leave above and below cursor
	set mat=2 " tenths of second to blink during matching brackets
	set novisualbell " disable visual sounds
	set cursorline " highlight cursor line
	set showmatch " Show matching brackets when over
	set signcolumn=yes " always show signcolumns
	set cmdheight=2	" #lines for vim for commands/logs
	set pumheight=16 " popup menu height
	set splitright " set defaults splitting position
	set updatetime=300 " set a low updatetime for better UX even w/ CoC
	set shortmess+=c " do not pass messages to ins-completion-menu
	set timeoutlen=500
	set ttimeoutlen=50
	set completeopt=menu,menuone,noselect
" }


" Section: INDENTATION {
	set smartindent " enable smart indentation
	set tabstop=2 softtabstop=-1 shiftwidth=0 " set tabs
" }


" Section: FOLDING {
	set wrap linebreak " Wrap long lines showing a linebreak
	set foldenable " enable code folding
	set foldmethod=diff
	set diffopt=internal,filler,closeoff,vertical
	set foldcolumn=0	" Add a bit extra margin to the Left
" }


" Section: FILE MANAGEMENT {
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
	set gdefault " use 'g' flag by default w/ :s/<toChange>/<as>/
" }


" Section: STATUS LINE {
	" Left Side
	set statusline=%1*%n⟩
	set statusline+=%2*\ %{get(g:,'coc_git_status','')}
	set statusline+=%{get(b:,'coc_git_status','')}
	set statusline+=%{get(b:,'coc_git_blame','')}
	set statusline+=%1*\ ⟩\ %m\ %<%f\  
	set statusline+=%4*
	" Right Side
	set statusline+=%=%4*
	set statusline+=%3*\ %{&fileencoding?&fileencoding:&encoding}
	set statusline+=%1*\ %y
	set statusline+=%3*\ ⟨\ %{&ff}
	set statusline+=\ ⟨\ %l\:%L\ 
" }


" Section: FUNCTIONS {
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

	" function! s:show_documentation() " Coc Show Documentation
	" 	if (index(['vim','help'], &filetype) >= 0)
	" 		execute 'h '.expand('<cword>')
	" 	elseif (coc#rpc#ready())
	" 		call CocActionAsync('doHover')
	" 	else
	" 		execute '!' . &keywordprg . " " . expand('<cword>')
	" 	endif
	" endfunction
" " }

