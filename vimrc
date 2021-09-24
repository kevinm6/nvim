" --------------------------------------------------- 
" -------------- K Vim Configuration ----------------
" --------------------------------------------------- 

" Version 19.09.21

" ----------------- VIM OPTIONS ------------------ {
	set guifont=Source\ Code\ Pro:h13

	set viminfo+=n~/.viminfo
	set rtp+=$HOME/.config/vim/
	set path+=**

	syntax enable 

	filetype on " enable recognition of filetype
	filetype plugin indent on " enable plugin, indentation on filetypes

	set nocompatible " Vi -> ViM (Vi Improved)

	set mouse=a
	set mousemodel=popup_setpos
	set number " Show line numbers
	set wildmenu " tab completion menu
	set showmode " show active mode in status line
	set showcmd " show command in status line

	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set tabstop=3 softtabstop=3 " set tabs width 
	set shiftwidth=3 

	set autoindent " enable indentation
	set smartindent " enable smart indentation

	set smartcase " smart case for search
	set lazyredraw " use less resources to render
	set wrap " Wrap long lines

	set autoread " enable auto read files when changed outside

	set showmatch " Show matching brackets when over

	set undofile " enable undo
	set nobackup " disable backups
	set noswapfile " disable swaps
	set undodir=$HOME/.config/vim/tmp/undo " undo files directory
	if !isdirectory(expand(&undodir)) " Create undo dir if doesn't exist
		 call mkdir(expand(&undodir), "p")
	endif

	set foldcolumn=1	" Add a bit extra margin to the left

	set tw=400	" Linebreak on 400 characters

	"set listchars=tab:\|\ 
	"set list

	if has("gui_macvim")	" Properly disable sound on errors on MacVim
		 autocmd GUIEnter * set vb t_vb=
		 let macvim_hig_shift_movement = 1
	endif

	if &diff " during diff enable highlight of changes
		highlight! link DiffText MatchParen
	endif

	set hlsearch " enable highlight during search
	set incsearch " enable incremental search

	set smarttab " enable smart tabs

	set cursorline " highlight cursor line
"	set colorcolumn=86 " highlight column at number
"	highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"	match OverLength /\%81v.\+/
"	match ErrorMsg '\%>80v\+'  --> disabled highlighting coloumn

	set foldenable " enable code folding
	set foldmethod=indent " fold with indentation
	
	" load automatically code folding
	autocmd BufWinLeave *.* mkview
	autocmd BufWinEnter *.* silent loadview 
	
	if has('syntax') && has('eval')
	 packadd! matchit
	endif

	" NETRW Options
	let g:netrw_liststyle = 3 " set tree as default list appearance
	let g:netrw_banner = 0 " disabling banner
	let g:netrw_preview = 1 " preview window in vertical split instead of horizontal
	let g:netrw_browse_split = 4 " open files in vertical split as default

	let g:netrw_keepdir = 0 " current dir & browsing dir synced
	let g:netrw_localcopydircmd = 'cp -r' " enable recursive copy command
	" highlight marked files
	hi! link netrwMarkFile Search  

	" COLOR SCHEME
	colorscheme k_theme
" }


" ----------------- STATUS LINE ------------------ {
	set laststatus=2
	set statusline=%1*\ [%n]\ \⟩\ %<%f\%* 
	set statusline+=%2*\ ⟩\ \%y
	set statusline+=%=Git[%{gitbranch#name()}]\ ⟨\ %{&ff}
	set statusline+=%=\ ⟨\ \%l:%c\ ⟨\   
" }


" ----------------- PLUGINS ----------------- {
	call plug#begin()
		Plug 'makerj/vim-pdf'
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'rbong/vim-flog'
		Plug 'itchyny/vim-gitbranch'
		"Plug 'maxboisvert/vim-simple-complete'
	call plug#end()
" }


" ----------------- REMAPPING ----------------- {
	noremap x "_x
	nnoremap <C-j> <C-w><C-j>
	nnoremap <C-k> <C-w><C-k>
	nnoremap <C-l> <C-w><C-l>
	nnoremap <C-h> <C-w><C-h>

	vnoremap p "_dP

	inoremap <Leader><left> <ESC>0
	inoremap <Leader><right> <ESC>$
	inoremap <Tab> <C-R>=CleverTab()<CR>

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


" ----------------- FUNCTIONS -----------------  {
	function! CleverTab()
		if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
			return "\<Tab>"
		else
			return "\<C-N>"
		endif
	endfunction
" }
