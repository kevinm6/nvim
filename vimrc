" --------------------------------------------------- 
" -------------- K Vim Configuration ----------------
" --------------------------------------------------- 

" Version 11.10.21

" ----------------- VIM OPTIONS ------------------ {
	set guifont="Source Code Pro":h13
		
	set viminfo+=n$HOME/.config/vim/.viminfo
	set rtp+=$HOME/.config/vim/
	set path+=**

	if &t_Co > 2 || has("gui_running")
		set guifont="Source Code Pro":h13.5
		if ! $TERM_PROGRAM == "vscode"
			set clipboard=unnamed
		endif
		syntax enable
		set hlsearch
		syntax reset " Initializing syntax
	" COLOR SCHEME {
		colorscheme k_theme
	" }
	endif

	if has("gui_macvim")	" Properly disable sound on errors on MacVim
		autocmd GUIEnter * set vb t_vb=
		let macvim_hig_shift_movement = 1
		let macvim_skip_colorscheme=1
	endif
	
	if has('syntax') && has('eval')
	 packadd! matchit
	endif
	
	filetype on " enable recognition of filetype
	filetype plugin indent on " enable plugin, indentation on filetypes

	"set omnifunc=syntaxcomplete#Complete

	set nocompatible " Vi -> ViM (Vi Improved)

	set mouse=a
	set mousemodel=popup_setpos
	set number " Show line numbers
	set wildmenu " tab completion menu
	set showmode " show active mode in status line
	set showcmd " show command in status line
	set scrolloff=2 " # of line leave above and below cursor

	set mat=10 " tenths of second to blink during matching brackets
	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set tabstop=3 softtabstop=3 " set tabs width 
	set shiftwidth=3 

	set autoindent " enable indentation
	set smartindent " enable smart indentation

	set smartcase " smart case for search
"	set lazyredraw " use less resources to render
	set wrap " Wrap long lines

	set autoread " enable auto read files when changed outside

	set showmatch " Show matching brackets when over

	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$HOME/.config/vim/tmp/undo " undo files directory
	if !isdirectory(expand(&undodir)) " Create undo dir if doesn't exist
		 call mkdir(expand(&undodir), "p")
	endif

	set foldcolumn=1	" Add a bit extra margin to the left

	set tw=200	" Linebreak on 400 characters

	"set listchars=tab:\|\ 
	"set list


	if &diff " during diff enable highlight of changes
		highlight! link DiffText MatchParen
	endif

	set incsearch " enable incremental search

	set smarttab " enable smart tabs

	set cursorline " highlight cursor line

	" CURSOR {
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
	endif
	" }
	
	"	set colorcolumn=86 " highlight column at number
	"	highlight OverLength ctermbg=red ctermfg=white guibg=#592929
	"	match OverLength /\%81v.\+/
	"	match ErrorMsg '\%>80v\+'  --> disabled highlighting coloumn

	set foldenable " enable code folding
	set foldmethod=indent " fold with indentation
	set viewoptions=folds,cursor
	set sessionoptions=folds

	set signcolumn=yes " always show signcolumns
	set cmdheight=1	" bigger display for commands/logs

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


" ----------------- NETRW Options ------------------ {
	let g:netrw_liststyle = 3 " set tree as default list appearance
	let g:netrw_banner = 0 " disabling banner
	let g:netrw_preview = 1 " preview window in vertical split instead of horizontal
	let g:netrw_browse_split = 4 " open files in vertical split as default
	let g:netrw_silent = 1 " transfers done silently (no statusline changes when obtaining files
	let g:netrw_keepdir = 0 " current dir & browsing dir synced
	let g:netrw_localcopydircmd = 'cp -r' " enable recursive copy command
	" highlight marked files
	hi! link netrwMarkFile Search  
" }


" ----------------- STATUS LINE ------------------ {
	set laststatus=2
	set statusline=%1*\ [%n]\ \⟩\ %<%f\%* 
	set statusline+=%2*\ ⟩\ \%y
	set statusline+=%=%{FugitiveStatusline()}\ ⟨\ %{&ff}
	set statusline+=%=\ ⟨\ \%l:%c\ ⟨\   
" }


" ----------------- PLUGINS ----------------- {
	call plug#begin('$VIMDOTDIR/plugins')
		Plug 'makerj/vim-pdf'
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'rbong/vim-flog'
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'airblade/vim-gitgutter'
		Plug 'w0rp/ale'
		Plug 'neoclide/coc.nvim', {'branch':'release'}
	call plug#end()
" }

	" Coc Configuration File
	let g:coc_config_home = "/Users/Kevin/Documents/Devices/Backup_Files/Shell/vim/plugins/coc.nvim"

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
	  let l:filename = input("please enter filename: ")
	  execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf

" }

" ----------------- REMAPPING ----------------- {

	" inoremap <Tab> <C-R>=CleverTab()<CR>            --DISABLED--
	" inoremap <tab> <c-r>=Smart_TabComplete()<CR>
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	" noremap x "_x
	nnoremap <C-j> <C-w><C-j>
	nnoremap <C-k> <C-w><C-k>
	nnoremap <C-w><l> <C-w><C-l>
	nnoremap <C><h> <C-w><C-h>
	
	vnoremap p "_dP

	noremap ø o<Esc>k
	"noremap <D><left> <Esc>0
	"noremap <D><right> <Esc>$
	noremap! <ESC>^[[1;2D b
	noremap! <ESC>^[[1;2C w
	
	nnoremap ∂∂ :Lexplore %:p:h<CR>
	nnoremap ∂å :Lexplore<CR>

	" remapping for autoclose brackets
	" inoremap \"" "<left>
	" inoremap ' ''<left>
	" inoremap ( ()<left>
	" inoremap [ []<left>
	" inoremap { {}<left>
	" inoremap {<CR> {<CR>}<ESC>O
	" inoremap {;<CR> {<CR>};<ESC>O
" }

