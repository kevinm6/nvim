" --------------------------------------------------- 
" -------------- K NeoVim Configuration ----------------
" --------------------------------------------------- 

" Version 24.10.21 12:40

" ----------------- VIM OPTIONS ------------------ {

" ----------------- FONT ----------------- {
	set guifont="Source Code Pro":h13
" }


" ----------------- PATH SETTINGS ----------------- {
	set viminfo+=n/Users/Kevin/.config/vim/.viminfo
	set rtp+=$HOME/.config/vim/
	set path+=**
" }


" ----------------- GUI MANAGEMENT ----------------- {
	 colorscheme k_theme " COLOR SCHEME

	 set display="lastline,msgsep"
	 if exists('g:vscode')
		break
	 else
		set clipboard=unnamed
" ----------------- CURSOR ----------------- {
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
		let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
	 endif
	" }
	 endif
" }




" ----------------- MOUSE ----------------- {
  	set mouse=a
	set mousemodel=popup_setpos
" }


" ----------------- GRAPHIC ----------------- {
 	filetype on " enable recognition of filetype
	"set omnifunc=syntaxcomplete#Complete

	set conceallevel=2	 " Hide and format elements
  	set number " Show line numbers
	set showmode " show active mode in status line
	if !&scrolloff
	  set scrolloff=3       " Show next 3 lines while scrolling.
	endif
	set scrolloff=3 " # of line leave above and below cursor
	set mat=2 " tenths of second to blink during matching brackets
	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set lazyredraw " use less resources to render
	set cursorline! " highlight cursor line
	set showmatch " Show matching brackets when over
	set tw=200	" Linebreak on 400 characters
	set signcolumn=yes " always show signcolumns
	set cmdheight=1	" #lines for vim for commands/logs
	set splitbelow " set defaults splitting position
	set splitright " \									  /
	set ttimeoutlen=50

	if &diff " during diff enable highlight of changes
		highlight! link DiffText MatchParen
	endif

	"	set colorcolumn=86 " highlight column at number
	"	highlight OverLength ctermbg=red ctermfg=white guibg=#592929
	"	match OverLength /\%81v.\+/
	"	match ErrorMsg '\%>80v\+'  --> disabled highlighting coloumn
" }


" ----------------- INDENTATION ----------------- {
 	filetype plugin indent on " enable plugin, indentation on filetypes

	set smartindent " enable smart indentation
	set tabstop=3 softtabstop=2 " set tabs width 
	set shiftwidth=2 
	autocmd FileType markdown setlocal shiftwidth=2 expandtab
" }


 " ----------------- FOLDING ----------------- {
	set wrap " Wrap long lines

	set foldenable " enable code folding
	set foldmethod=indent " fold with indentation
	set sessionoptions=folds
	set foldcolumn=1	" Add a bit extra margin to the left
 " }


" ----------------- FILE MANAGEMENT ----------------- {
   set autowrite " write files
	set autowriteall " write files on exit or other changes
	set autochdir " auto change directory of explore
   "set autoshelldir " auto change dir of shell
	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$HOME/.config/vim/tmp/undo " undo files directory
	set clipboard+=unnamedplus

	if !isdirectory(expand(&undodir)) " Create undo dir if doesn't exist
		 call mkdir(expand(&undodir), "p")
	endif

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

  " Coc Configuration File
	let g:coc_config_home = "/Users/Kevin/Documents/Devices/Backup_Files/Shell/vim/plugins/coc.nvim"

  " Markdown w/ tpope/vim-markdown files
  "au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md  setf markdown
 let g:markdown_fenced_languages = ['html', 'python', 'zsh', 'java', 'c', 'bash', 'json', 'swift', 'xml', 'javascript', 'js=javascript', 'css', 'C', 'changelog', 'cpp', 'php' ]
  let g:markdown_syntax_conceal = 2
" }


" ----------------- SEARCH ----------------- {
	set smartcase " smart case for search
	set gdefault " use 'g' flag by default w/ :s/<toChange>/<as>/
" }


" ----------------- SESSION ----------------- {

  let g:session_autosave = 'yes'
  let g:session_autoload = 'yes'
  let g:session_default_to_last = 1
" }


" ----------------- NETRW OPTIONS ----------------- {
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


" ----------------- STATUS LINE ------------------ {
	set statusline=%1*\ [%n]\ \⟩\ %<%f\%* 
	set statusline+=%2*\ ⟩\ \%y
	set statusline+=%=%{FugitiveStatusline()}\ ⟨\ %{&ff}\ ⟨\ \%l:%c\ ⟨
" }

" }


" ----------------- PLUGINS ----------------- {
	call plug#begin('$VIMDOTDIR/plugins')
	 	Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-markdown'
		Plug 'rbong/vim-flog'
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'airblade/vim-gitgutter'
		Plug 'junegunn/goyo.vim'
		Plug 'tpope/vim-commentary'
		Plug 'neoclide/coc.nvim', {'branch':'release'}
	call plug#end()
" }


" ----------------- FUNCTIONS -----------------  {

	" Plugin coc.nvim
	" use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
	 let col = col('.') - 1
	 return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

	function! CreateInPreview()
	  let l:filename = input("> Enter filename: ")
	  execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf
" }

" ----------------- REMAPPING ----------------- {
   " use <c-space>for trigger completion
   inoremap <silent><expr> <c-space> coc#refresh()

	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
"	inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
"	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

	nnoremap <C-j> <C-w><C-j>
	nnoremap <C-k> <C-w><C-k>
	nnoremap <C><h> <C-w><C-h>
	
	nnoremap ˘ "_dd
	vnoremap p "_dP

	noremap ø o<Esc>k
	noremap! <ESC>^[[1;2D b
	noremap! <ESC>^[[1;2C w

	nnoremap ∂∂ :Sexplore %:p:h<CR>
	nnoremap ∂å :Lexplore<CR>
" }

