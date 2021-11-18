" ----------------------------------
" File: ginit.vim
" Description: VimR K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ginit.vim
" Last Modified: 18.11.21 14:27
" -----------------------------------

" Section: VIMR OPTIONS


" Section: PATH SETTINGS {
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/gmain.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
" }


" Section: GUI MANAGEMENT {
	try | colorscheme k_theme | catch "⚠️  Error loading colorscheme" | endtry
	set display="lastline,msgsep"
	set clipboard=unnamedplus
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
	endif
" }


" Section: MOUSE {
	set mouse=a
" }


" Section: GRAPHIC {
 	filetype on " enable recognition of filetype
 	filetype plugin indent on " enable plugin, indentation on filetypes

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
	set autowrite " write files
	set autowriteall " write files on exit or other changes
	set autochdir " auto change directory of explore
	set undofile " enable undo
	set nobackup " disable backups
	set nowritebackup
	set noswapfile " disable swaps
	set undodir=$HOME/.local/share/nvim/tmpr/undo " undo files directory

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
	let g:coc_config_home = "$NVIMDOTDIR"

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

	" SQL
	au BufNewFile, BufRead psql* set filetype sql
" }

	
" Section: FUNCTIONS -----------------  {
	function! CreateInPreview()
		let l:filename = input("> Enter filename: ")
		execute 'pedit ' . b:netrw_curdir.'/'.l:filename
	endf
		
		function! s:VimRTempMaxWin() abort
			VimRMakeSessionTemporary    " The tools, tool buttons and window settings are not persisted
			VimRHideTools
			VimRMaximizeWindow
		endf
		command! -nargs=0 VimRTempMaxWin call s:VimRTempMaxWin()

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


" Section: NETRW Global Options {
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


" Section: DATABASES {
	let g:dbs = {
		\ 'imdb': 'postgres://:@localhost/imdb',
		\ 'lezione': 'postgres://:@localhost/lezione'
		\}
" }


" Section: STATUS LINE {
	set statusline=%1*\[%n]\⟩\ %<%f\%*
	set statusline+=%3*\ ⟩\ \%y
	set statusline+=%=%2*%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %3*⟨\ %{&ff}\ ⟨\ %l\:%c\/%L\ ⟨
" }


" Section: PLUGINS {
	call plug#begin('$NVIMDOTDIR/plugins')
		Plug 'jiangmiao/auto-pairs'
		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-fugitive'
		Plug 'rbong/vim-flog'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-dadbod'
		Plug 'kristijanhusak/vim-dadbod-ui'
		Plug 'tpope/vim-markdown', {'for': 'md'}
		Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
		Plug 'joelbeedle/pseudo-syntax'
		Plug 'junegunn/goyo.vim'
		Plug 'makerj/vim-pdf', { 'for': 'pdf' }
		Plug 'neoclide/coc.nvim', {'branch':'release'}
		Plug 'morhetz/gruvbox'
	call plug#end()
" }


" Section: REMAPPING {
	nmap <Leader>e :e $NVIMDOTDIR/ginit.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/ginit.vim<CR>
	" source $NVIMDOTDIR/keymaps.vim
	finish

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
	cmap gc Git commit -m ''<Left>
	cmap gac Git add . <bar> Git commit -m ""<Left>
	cmap gp Git push<CR>
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
	nmap <Leader>t :sb<bar>term<cr><C-W>J:resize12<cr>
	nmap <A-Left> B
	nmap <A-Right> E
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
	nmap S :%s///g<Left><Left><Left>
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
	vmap <BS> "_d
	vmap <Tab> >
	vmap <S-Tab> <
	vmap ] >
	vmap [ <
	vmap p "_dP
	" }
	
	" VimR Specific keymaps
	nmap <D-Right> $
	nmap <D-Left> 0
	nmap <D-down> G
	nmap <D-up> gg
	nmap <C-Tab> gt
	nmap <C-S-Tab> gT
	imap <A-BS> <C-w>
	imap <A-Del> <C-o>"_dw
	imap <D-BS> <C-u>
	imap <D-Del> <C-o>"_d$
	imap <D-Right> <Esc>A
	imap <D-Left> <Esc>I
	imap <D-Right> <C-o>$
	imap <D-Left> <C-o>0
	imap <D-down> <C-o>G
	imap <D-up> <C-o>gg
	" }

" }
