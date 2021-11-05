" --------------------------------------------------- 
" -------------- K VimR Configuration ---------------
" --------------------------------------------------- 

" Version 05.11.21 20:36

" ----------------- VIMR OPTIONS ------------------ {

" ----------------- PATH SETTINGS ----------------- {
	set runtimepath+=n~/.config/nvim/
	set viminfo+=n~/.config/nvim/gmain.shada
	set path+=**
	set shada='20,<50,s10
" }

	set encoding=utf8


" ----------------- GUI MANAGEMENT ----------------- {
 try | colorscheme k_theme | catch "⚠️  Error loading colorscheme" | endtry

	set display="lastline,msgsep"
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
	set cursorline! " highlight cursor line
	set showmatch " Show matching brackets when over
	set tw=200	" Linebreak on 400 characters
	set signcolumn=yes " always show signcolumns
	set cmdheight=1	" #lines for vim for commands/logs
	set splitbelow " set defaults splitting position
	set splitright " \
	set timeoutlen=500
	set ttimeoutlen=50
" }


" ----------------- INDENTATION ----------------- {
 	filetype plugin indent on " enable plugin, indentation on filetypes

	set smartindent " enable smart indentation
	set tabstop=2 softtabstop=-1 shiftwidth=0 " set tabs
	autocmd FileType markdown setlocal shiftwidth=2 expandtab
" }


 " ----------------- FOLDING ----------------- {
	set wrap " Wrap long lines
	set wrapmargin=68
	set foldenable " enable code folding
	set foldmethod=indent " fold with indentation
	set viewoptions=folds,cursor
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
	set undodir=$NVIMDOTDIR/tmpr/undo " undo files directory

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

 function! GitStatus()
		let [a,m,r] = GitGutterGetHunkSummary()
		return printf('+%d ~%d -%d', a, m, r)
	endfunction

 " Coc Configuration File
	let g:coc_config_home = "$NVIMDOTDIR/plugins/coc.nvim"

	" Python
	let g:python3_host_prog = "/usr/local/bin/python3.9"

	" Markdown
	au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setf markdown
	let g:markdown_fenced_languages = ['html', 'python', 'zsh','java', 'c', 'bash=sh', 'json', 'xml', 'javascript', 'js=javascript', 'css', 'C', 'changelog', 'cpp', 'php', 'pseudo' ]
	au filetype markdown
            \ setlocal conceallevel=2  |
            \ setlocal shiftwidth=2
						\ expandtab
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
	set statusline=%1*\[%n]\⟩\ %<%f\%*
	set statusline+=%3*\ ⟩\ \%y
	set statusline+=%=%2*%{GitStatus()}\ %{FugitiveStatusline()}\ %3*⟨\ %{&ff}\ ⟨\ R%l\/%L\:\C%c\ ⟨
	" }

" }


" ----------------- PLUGINS ----------------- {
	call plug#begin('$NVIMDOTDIR/plugins')
	 	Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'jiangmiao/auto-pairs'
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
	call plug#end()
" }


" ----------------- FUNCTIONS -----------------  {

	function! CreateInPreview()
	  let l:filename = input("> Enter filename: ")
	  execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf
	
	function! s:VimRTempMaxWin() abort
	  VimRMakeSessionTemporary    " The tools, tool buttons and window settings are not persisted
	  VimRHideTools
	  VimRMaximizeWindow
	endfunction
	command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()

" }


" ----------------- REMAPPING ----------------- {

	" Command Mode {
	set wildcharm=<C-Z>
	cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
	cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
	cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
	cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
	" }
	
	" Normal-Visual-Operator-pending Mode {
	map <A-F2> :echo 'Current time is ' . strftime('%c')<CR>	
	map <A-left> b
	map <A-right> w
	" Command-key map
	map <D-right> $
	map <D-left> 0
	map <D-down> G
	map <D-up> gg
	" }
	
	" Insert Mode {
	imap <silent><expr> <c-space> coc#refresh()
	imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	imap <silent><expr><cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	imap <Esc> <Esc>`^
	imap <A-left> <Esc>bi
	imap <A-right> <Esc>wi
	imap jk <Esc>
	imap kj <Esc>
	imap <S-right> <C-o>vl
	imap <S-left> <C-o>vh
	imap <S-Tab> <C-d>
	imap <F2> <C-R>=strftime("%d.%m.%y %H:%M")<CR>
	" Command-key imap
	imap <D-right> <Esc>A
	imap <D-left> <Esc>I
	imap <D-right> <C-o>$
	imap <D-left> <C-o>0
	imap <D-down> <C-o>G
	imap <D-up> <C-o>gg
	" }
	
	" Normal Mode {
	nmap <Space> <PageDown>
	nmap <Tab> <C-W><C-W>
	nmap <S-Tab> <C-W><C-P>
	nmap <S-left> vh
	nmap <S-right> vl
	nmap <S-up> vk
	nmap <S-down> vj
	nmap µ :MarkdownPreview<CR>
	nmap Ú :MarkdownPreviewStop<CR>
	nmap ˝ <C-W>J
	nmap ˛ <C-W>K
	nmap ¸ <C-W>H
	nmap ˇ <C-W>L
	nmap ø o<Esc>k
	nmap ˘˘ :Sexplore %:p:h<CR>
	nmap ˘Å :Lexplore<CR>
	nmap † "_x
	nmap ∂ "_d
	nmap <C-Tab> gt
	nmap <C-S-Tab> gT
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
