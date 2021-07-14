" K Vim Configuration
set guifont=Source\ Code\ Pro:h13

set viminfo+=n~/.viminfo
set rtp+=$HOME/.config/vim/

syntax enable 

set nocompatible

set path+=**
set wildmenu

set noerrorbells
set novisualbell
set tabstop=3 softtabstop=3
set shiftwidth=3
set smartindent
set nu
set smartcase
set lazyredraw
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Set to auto read when a file is changed from the outside 
set autoread

" Show matching brackets when text indicator is over them
set showmatch 


" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif



" Add a bit extra margin to the left
set foldcolumn=1

" Linebreak on 500 characters
set lbr
set tw=500



"set listchars=tab:\|\ 
"set list

set undofile
set nobackup                    " disable backups
set noswapfile                  " disable swaps
set undodir=$HOME/.config/vim/tmp/undo     " undo files
set backupdir=$HOME/.config/vim/tmp/backup " backups files folder
set directory=$HOME/.config/vim/tmp/swap   " swap files folder
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

if &diff
	highlight! link DiffText MatchParen
endif

set hlsearch
set incsearch

set smarttab

set laststatus=2
set statusline=%1*[%n]\ \⟩\ %<%f\%*
set statusline+=%2*\ ⟩\ \%y
set statusline+=%=\⟨\ %{&ff}
set statusline+=%=\ ⟨\ \%l:%c\ ⟨

"set title
if &t_Co > 2 || has("gui_running")                                              
 set hlsearch                                                                  
endif  

if has('syntax') && has('eval')
 packadd! matchit
endif

filetype off                

filetype plugin indent on    

" COLOR Scheme Kevin
colorscheme k_colorScheme

set cursorline
set colorcolumn=80

call plug#begin()
	Plug 'makerj/vim-pdf'
	Plug 'tpope/vim-surround'
	"Plug 'maxboisvert/vim-simple-complete'
call plug#end()

" REMAPPING
noremap x "_x
vnoremap p "_dP

" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O


 function! CleverTab()
           if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
              return "\<Tab>"
           else
              return "\<C-N>"
           endif
        endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
