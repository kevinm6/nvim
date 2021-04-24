"FONT
set viminfo+=n~/.config/vim/viminfo
set rtp+=$HOME/.config/vim/

set guifont=Source\ Code\ Pro:h13

syntax enable 

set nocompatible

set path+=**
set wildmenu

set noerrorbells
set tabstop=3 softtabstop=3
set shiftwidth=3
set smartindent
set nu
set wrap
set smartcase

set listchars=tab:\|\ 
set list

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
	"Plug 'maxboisvert/vim-simple-complete'
call plug#end()

"REMAPPING
 inoremap " ""<left>
 inoremap ' ''<left>
 inoremap ( ()<left>
 inoremap [ []<left>
 inoremap { {}<left>
 inoremap {<CR> {<CR>}<ESC>O
 inoremap {;<CR> {<CR>};<ESC>O


 function! CleverTab()
           if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
              return "\<Tab>"
           else
              return "\<C-N>"
           endif
        endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

