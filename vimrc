" --------------------------------------------------- 
" -------------- K Vim Configuration ----------------
" --------------------------------------------------- 

" Version 18.10.21 09:00

" ----------------- VIM OPTIONS ------------------ {

	set nocompatible " Vi -> ViM (Vi Improved)


" ----------------- FONT ----------------- {
	set guifont="Source Code Pro":h13
" }


" ----------------- PATH SETTINGS ----------------- {
	set viminfo+=n/Users/Kevin/.config/vim/.viminfo
	set rtp+=$HOME/.config/vim/
	set path+=**
" }


" ----------------- GUI MANAGEMENT ----------------- {
	 syntax reset
	 syntax enable
	 colorscheme k_theme " COLOR SCHEME

	 if has("gui_macvim")	" MacVim ad hoc config
		set guifont="Source Code Pro":h13.5
		autocmd GUIEnter * set vb t_vb=
		set clipboard=unnamed
		let macvim_hig_shift_movement = 1
		let macvim_skip_colorscheme=1
		set antialias

	 endif
	
	if has('syntax') && has('eval')
		packadd! matchit
		autocmd FileType markdown set conceallevel=2	 " Hide and format markdown elements
	endif
" }


" ----------------- CURSOR ----------------- {
	 "Cursor settings:
		"  1 -> blinking block
		"  2 -> solid block 
		"  3 -> blinking underscore
		"  4 -> solid underscore
		"  5 -> blinking vertical bar
		"  6 -> solid vertical bar
	if $TERM_PROGRAM =~ "iTerm"
		" Block Bar in normal mode
		let &t_EI = "\<Esc>]50;CursorShape=0\x7"
		" Vertical Bar in Insert Mode
		let &t_SI = "\<Esc>]50;CursorShape=1\x7"
		" Underline in Replace Mode
		let &t_SR = "\<Esc>]50;CursorShape=2\x7"
	elseif $TERM_PROGRAM == "Apple_Terminal"
		let &t_SI.="\e[5 q" "SI = INSERT mode
		let &t_SR.="\e[4 q" "SR = REPLACE mode
		let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
	elseif $TERM_PROGRAM == "vscode"
	  break
	endif
" }


" ----------------- MOUSE ----------------- {
  	set mouse=a
	set mousemodel=popup_setpos
" }


" ----------------- GRAPHIC ----------------- {
 	filetype on " enable recognition of filetype
	"set omnifunc=syntaxcomplete#Complete

  	set number " Show line numbers
	set wildmenu " tab completion menu
	set showmode " show active mode in status line
	set showcmd " show command in status line
	set scrolloff=2 " # of line leave above and below cursor
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

	set autoindent " enable indentation
	set smartindent " enable smart indentation
	set smarttab " enable smart tabs
	set tabstop=3 softtabstop=2 " set tabs width 
	set shiftwidth=2 
	"set listchars=tab:\|\ 
	"set list
" }


 " ----------------- FOLDING ----------------- {
	set wrap " Wrap long lines

	set foldenable " enable code folding
	set foldmethod=indent " fold with indentation
	set viewoptions=folds,cursor
	set sessionoptions=folds
	set foldcolumn=1	" Add a bit extra margin to the left
 " }


" ----------------- FILE MANAGEMENT ----------------- {
 	set autoread " enable auto read files when changed outside

	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$HOME/.config/vim/tmp/undo " undo files directory

	if !isdirectory(expand(&undodir)) " Create undo dir if doesn't exist
		 call mkdir(expand(&undodir), "p")
	endif

 	augroup AutoSaveGroup
	  autocmd!
	  " view files are about 500 bytes
	  " bufleave but not bufwinleave captures closing 2nd tab
	  " nested is needed by bufwrite* (if triggered via other autocmd)
	  " BufHidden for compatibility with `set hidden`
	  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
	  autocmd BufWinEnter ?* silent! loadview
	augroup end

	autocmd filetype netrw call Netrw_mappings()
	function! Netrw_mappings()
	  noremap <buffer>% :call CreateInPreview()<cr>
	endfunction

  " Coc Configuration File
	let g:coc_config_home = "/Users/Kevin/Documents/Devices/Backup_Files/Shell/vim/plugins/coc.nvim"

  " Markdown
  au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,README.md  setf markdown
  " vim-markdown
  let g:markdown_fenced_languages = ['html', 'python', 'zsh', 'java', 'c', 'bash', 'json', 'swift']
  let g:markdown_syntax_conceal = 2
" }


" ----------------- SEARCH ----------------- {
   set hlsearch
	set incsearch " enable incremental search
	set smartcase " smart case for search
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
	set laststatus=2
	set statusline=%1*\ [%n]\ \⟩\ %<%f\%* 
	set statusline+=%2*\ ⟩\ \%y
	set statusline+=%=%{FugitiveStatusline()}\ ⟨\ %{&ff}
	set statusline+=%=\ ⟨\ \%l:%c\ ⟨\   
" }

" }


" ----------------- PLUGINS ----------------- {
	call plug#begin('$VIMDOTDIR/plugins')
	 	Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-markdown'
		Plug 'masukomi/vim-markdown-folding', { 'for': 'markdown' }
		Plug 'rbong/vim-flog'
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'airblade/vim-gitgutter'
		Plug 'junegunn/goyo.vim'
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

"	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

