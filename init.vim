" --------------------------------------------------- 
" -------------- K NeoVim Configuration ----------------
" --------------------------------------------------- 

" Version 28.10.21 10:02

" ----------------- NVIM OPTIONS ------------------ {
	if has('gui_vimr')
		source $NVIMDOTDIR/ginit.vim
		finish
	endif
	

" ----------------- FONT ----------------- {
	set guifont="Source Code Pro":h13
" }


" ----------------- PATH SETTINGS ----------------- {

	set runtimepath+=~/.config/nvim/
	set packpath+=&runtimepath
	set viminfo+=n~/.config/nvim/main.shada
	set path+=**
" }

" ----------------- GUI MANAGEMENT ----------------- {
   try | colorscheme k_theme | catch "⚠️  Error loading colorscheme" | endtry
	 set termguicolors

	 set display="lastline,msgsep"
	 if exists('g:vscode')
		finish
	 else
		set clipboard=unnamedplus
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
		let &t_EI.="\e[1 q" "EI = NORMAL mode
	 endif
	" }
	endif
" }


" ----------------- MOUSE ----------------- {
	set mouse=a
" }


" ----------------- GRAPHIC ----------------- {
 	filetype on " enable recognition of filetype

	set number " Show line numbers
	set showmode " show active mode in status line
	if !&scrolloff
	  set scrolloff=3       " Show next 3 lines while scrolling.
	endif
	set mat=2 " tenths of second to blink during matching brackets
	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set cursorline! " highlight cursor line
	set showmatch " Show matching brackets when over
	set tw=200	" Linebreak on 400 characters
	set signcolumn=yes " always show signcolumns
	set cmdheight=1	" #lines for vim for commands/logs
	set splitbelow " set defaults splitting position
	set splitright " \
	set timeoutlen=500
	set ttimeoutlen=50

	if &diff " during diff enable highlight of changes
		highlight! link DiffText MatchParen
	endif
" }


" ----------------- INDENTATION ----------------- {
 	filetype plugin indent on " enable plugin, indentation on filetypes

	set smartindent " enable smart indentation
	set tabstop=2 softtabstop=-1 shiftwidth=0 " set tabs behavior
	autocmd FileType markdown setlocal shiftwidth=2 expandtab
" }


 " ----------------- FOLDING ----------------- {
	set wrap " Wrap long lines

	set foldenable	" enable code folding
	set foldmethod=indent " fold with indentation
	set sessionoptions=folds
	set foldcolumn=1	" Add a bit extra margin to the left
 " }


" ----------------- FILE MANAGEMENT ----------------- {
	set autowrite " write files
	set autowriteall " write files on exit or other changes
	set autochdir " auto change directory of explore
	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$NVIMDOTDIR/tmp/undo " undo files directory

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
	let g:coc_config_home = "$NVIMDOTDIR/plugins/coc.nvim"

  " Markdown w/ tpope/vim-markdown files
  "au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md  setf markdown
 let g:markdown_fenced_languages = ['html', 'python', 'zsh', 'java', 'c', 'bash=sh', 'json', 'xml', 'javascript', 'js=javascript', 'css', 'C', 'changelog', 'cpp', 'php', 'pseudo' ]
  let g:markdown_syntax_conceal = 2
	let g:vim_markdown_conceal_code_blocks = 1
" }


" ----------------- SEARCH ----------------- {
	set smartcase " smart case for search
	set inccommand=nosplit
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
	call plug#begin('$NVIMDOTDIR/plugins')
	 	Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-markdown'
		Plug 'tpope/vim-commentary'
		Plug 'rbong/vim-flog'
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'joelbeedle/pseudo-syntax'
		Plug 'airblade/vim-gitgutter'
		Plug 'junegunn/goyo.vim'
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		" Plug 'ryanoasis/vim-devicons'    " need other fonts and plugin
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

	" Insert Mode
  inoremap <silent><expr> <c-space> coc#refresh()
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	inoremap <Esc> <Esc>`^
	inoremap jk <Esc>
	inoremap kj <Esc>
	inoremap <S-Tab> <C-d>

	" Command Mode
	nnoremap µ :MarkdownPreview<CR>
	nnoremap Ú :MarkdownPreviewStop<CR>
	nnoremap <C-j> <C-W><C-j>
	nnoremap <C-k> <C-W><C-k>
	nnoremap <C><h> <C-W><C-h>
	noremap ø o<Esc>k
	noremap! <ESC>^[[1;2D b
	noremap! <ESC>^[[1;2C w
	nnoremap ∂∂ :Sexplore %:p:h<CR>
	nnoremap ∂å :Lexplore<CR>
	nnoremap ˘ "_dd
							
	" Visual Mode
	vnoremap p "_dP

	" Global Mapping																
	map <Tab> <C-W><C-W>
	map <S-Tab> <C-W><C-P>
	map <S-left> b
	map <S-right> w
	map <F2> :echo 'Current time is ' . strftime('%c')<CR>

	" Substitution
	iab <expr> dts strftime("%d.%m.%y %H:%M")
" }
