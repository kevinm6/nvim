" -------------------------------------------------
" File: init.vim
" Description: Neovim K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/init.vim
" Last Modified: 17.11.21 14:30
" -------------------------------------------------


" ----------------- NVIM OPTIONS ------------------ {
	if !has('nvim')
		source $VIMDOTDIR/vimrc
		finish
	elseif has('gui_vimr')
		source $NVIMDOTDIR/ginit.vim
		finish
	endif

" ----------------- PATH SETTINGS ----------------- {
	set rtp+=n~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/main.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
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
		set scrolloff=3 " # of line leave above and below cursor
	endif
	set mat=2 " tenths of second to blink during matching brackets
	set noerrorbells " disable errors sounds
	set novisualbell " disable visual sounds
	set cursorline " highlight cursor line
	set showmatch " Show matching brackets when over
	set tw=200	" Linebreak on 400 characters
	set signcolumn=yes " always show signcolumns
	set cmdheight=1	" #lines for vim for commands/logs
	set pumheight=16 " popup menu height
	set splitbelow " set defaults splitting position
	set splitright " \
	set timeoutlen=500
	set ttimeoutlen=50
" }


" ----------------- INDENTATION ----------------- {
 	filetype plugin indent on " enable plugin, indentation on filetypes

	set smartindent " enable smart indentation
	set cindent	" enable indentation as C lang
	set tabstop=2 softtabstop=-1 shiftwidth=0 " set tabs
" }


" ----------------- FOLDING ----------------- {
	set wrap " Wrap long lines
	set wrapmargin=68
	set foldenable " enable code folding
	set foldmethod=syntax
	set viewoptions=folds,cursor
	set sessionoptions=folds
	set foldcolumn=1	" Add a bit extra margin to the Left
" }


" ----------------- FILE MANAGEMENT ----------------- {
	set autowrite " write files
	set autowriteall " write files on exit or other changes
	set autochdir " auto change directory of explore
	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$HOME/.local/share/nvim/tmp/undo " undo files directory

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

	" Automation for coc-syntax using omnifunc
	if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
		    \	if &omnifunc == "" |
		    \		setlocal omnifunc=syntaxcomplete#Complete |
		    \	endif
  endif

" Python
	let g:python3_host_prog = "/usr/local/bin/python3.9"

	" Markdown
	au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setf markdown
	let g:markdown_fenced_languages = ['html', 'python', 'zsh', 'java', 'c', 'bash=sh', 'json', 'xml', 'javascript', 'js=javascript', 'css', 'C', 'changelog', 'cpp', 'php', 'pseudo', 'sql' ]
	au filetype markdown
            \ setlocal conceallevel=2  |
            \ setlocal shiftwidth=2
						\ expandtab
	let g:markdown_folding = 1
	let g:rmd_include_html = 1
	
	" SQL
	au BufNewFile, BufRead psql* set filetype sql
" }

	
" ----------------- FUNCTIONS -----------------  {
	function! CreateInPreview()
		let l:filename = input("> Enter filename: ")
		execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf
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


" ----------------- DATABASES ----------------- {
	let g:dbs = {
		\ 'imdb': 'postgres://:@localhost/imdb',
		\ 'lezione': 'postgres://:@localhost/lezione'
		\}
" }


" ----------------- STATUS LINE ------------------ {
	set statusline=%1*\[%n]\⟩\ %<%f\%*
	set statusline+=%3*\ ⟩\ \%y
	set statusline+=%=%2*%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %3*⟨\ %{&ff}\ ⟨\ %l\:%c\/%L\ ⟨
" }


" ----------------- PLUGINS ----------------- {
	call plug#begin('$NVIMDOTDIR/plugins')
		Plug 'jiangmiao/auto-pairs'
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'rbong/vim-flog'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-dadbod'
		Plug 'kristijanhusak/vim-dadbod-ui'
		Plug 'tpope/vim-markdown'
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'joelbeedle/pseudo-syntax'
		Plug 'junegunn/goyo.vim'
	 	Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		Plug 'morhetz/gruvbox'
	call plug#end()
" }


" ----------------- REMAPPING ----------------- {

	" Terminal Mode
	tnoremap <Esc> <C-\><C-n>
	" }
	
	" Command Mode {
	set wildcharm=<C-Z>
	cmap <expr> <up> wildmenumode() ? "\<Left>" : "\<up>"
	cmap <expr> <down> wildmenumode() ? "\<Right>" : "\<down>"
	cmap <expr> <Left> wildmenumode() ? "\<up>" : "\<left>"
	cmap <expr> <Right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
	cmap gs Git status<CR>
	cmap ga Git add
	cmap gaa Git add .<CR>
	cmap gc Git commit -m ""<Left>
	cmap gac Git add . | Git commit -m ""<Left>
	" }

	" Normal-Visual-Operator-pending Mode {
	map <A-Left> B
	map <A-Right> E
	map <Leader>t :sb<bar>term<cr><C-W>J:resize12<cr>
	" }
	
	" Insert Mode {
	imap <silent><expr> <c-space> coc#refresh()
	imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	imap <silent><expr><cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	imap <Esc> <Esc>`^
	imap <A-Left> <Esc>Bi
	imap <A-Right> <Esc>Ei
	imap jk <Esc>
	imap kj <Esc>
	imap <S-Right> <C-o>vl
	imap <S-Left> <C-o>vh
	imap <S-down> <C-o>vj
	imap <S-up> <C-o>vk
	imap <S-Tab> <C-d>
	imap <F2> <C-R>=strftime("%d.%m.%y %H:%M")<CR>
	" }
	
	" Normal Mode {
	nmap <Leader>e :e $NVIMDOTDIR/init.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/init.vim<CR>
	nmap <Leader>html :-1read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a
	nmap <Leader>c :-1read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja
	nmap <Leader>java :-1read $NVIMDOTDIR/snippets/skeleton.java<CR>2j$o
	nmap <Leader>fjava :-1read $NVIMDOTDIR/snippets/method.java<CR>7ggt(a
	nmap <Leader>vim :-1read $NVIMDOTDIR/snippets/skeleton.vim<CR>jA<C-r>%<C-o>j<Space>
	nmap <Leader>md :-1read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go
	nmap <Leader>imd :-1read $NVIMDOTDIR/snippets/info.md<CR>i<C-r>%<Esc>6ggA<C-o>i<F2><Esc>Go
	nmap <silent> <Leader>y  :<C-u>CocList -A --normal yank<cr>
	nmap <Leader>f :CocCommand explorer<CR>
	nmap <Space> <PageDown>
	nmap <Tab> <C-W><C-W>
	nmap <S-Tab> <C-W><C-P>
	nmap <S-Left> vh
	nmap <S-Right> vl
	nmap <S-up> vk
	nmap <S-down> vj
	nmap S :%s//g<Left><Left>
	nmap µ :MarkdownPreviewToggle<CR>
	nmap ˝ <C-W>J
	nmap ˛ <C-W>K
	nmap ¸ <C-W>H
	nmap ˇ <C-W>L
	nmap Ø O<Esc>j
	nmap ø o<Esc>k
	nmap ˘˘ :Hexplore %:p:h<CR><C-W>K:resize12<cr>
	nmap ˘Å :Lexplore<CR>
	nmap † "_x
	nmap ∂ "_d
	" }
	
	" Visual Mode {
	vmap <BS> "_x
	vmap <Tab> >
	vmap <S-Tab> <
	vmap ] >
	vmap [ <
	vmap p "_dP
	" }
" }
