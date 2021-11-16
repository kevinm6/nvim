" -----------------------------------------------------------------------------
" File: k_theme.vim
" Description: Kevin personal colorscheme for vim/neovim/vimr
" Author: Kevin
" Source: https://github.com/kevinm6/
" Last Modified: 13.11.21 20:30
" -----------------------------------------------------------------------------

" Set main options
	let colors_name ='k_theme' 
	set background=dark
	set t_co=256
	
" ----------------- FONT ----------------- {
	if !has('gui_vimr')
		set guifont="Source Code Pro":h13
	endif
" }

	" Modes
	hi Normal guifg=#DCDCDC guibg=#101010 ctermfg=253 ctermbg=232
	hi Visual gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE
	" Selection Not Owned by vim
	hi VisualNOS gui=NONE guifg=#244E7A guibg=NONE cterm=NONE ctermfg=25 ctermbg=NONE

	hi ModeMsg guifg=DeepSkyBlue3 guibg=NONE ctermfg=31 ctermbg=NONE
	hi MoreMsg guifg=DeepSkyBlue3 ctermfg=32

	hi Title guifg=gold gui=bold cterm=bold ctermfg=yellow
	hi Statement guifg=#08adeb ctermfg=39

	hi colorColumn guibg=#606060 ctermbg=237

" Cursor
	" set guicursor=n-v-i:blinkwait700-blinkon400-blinkoff250
	hi Cursor gui=NONE guibg=fg guifg=bg cterm=NONE ctermbg=fg ctermfg=bg
	hi LineNr guibg=#101010 guifg=#808080 ctermbg=232 ctermfg=240
	hi Cursorline gui=NONE guifg=NONE guibg=grey15 cterm=NONE ctermfg=NONE ctermbg=235
	hi CursorLineNr guibg=NONE guifg=#36FF5A  gui=bold cterm=bold ctermbg=NONE ctermfg=42

	hi HighlightedyankRegion gui=reverse guibg=NONE cterm=reverse ctermbg=NONE

" Split
	hi VertSplit guibg=bg guifg=fg ctermbg=fg ctermfg=bg

" Folding
	hi Folded guibg=black guifg=Grey40 ctermfg=230 ctermbg=240
	hi FoldColumn guibg=black guifg=NONE ctermfg=4 ctermbg=NONE

" Search
	hi Search guibg=#244E7A ctermbg=25 
	hi IncSearch guibg=black guifg=green ctermbg=black ctermfg=green cterm=NONE ctermfg=yellow ctermbg=green

" Debugging
	hi Debug guifg=#ff0000 ctermfg=Red

" Status Line
	hi StatusLine guifg=#A9A9A9 guibg=#303030 ctermbg=236 ctermfg=248
	hi StatusLineNC guifg=#A9A9A9 guibg=#787878 ctermfg=7 ctermbg=242
	hi StatusLineTerm guifg=#A9A9A9 guibg=#303030 ctermbg=234 ctermfg=246
	hi StatusLineTermNC guifg=#A9A9A9 guibg=#787878 ctermfg=7 ctermbg=244

" Users
	hi User1 guifg=#00D392 guibg=#303030 ctermfg=48 ctermbg=236
	hi User2 guifg=#af8700 guibg=#303030 ctermfg=136 ctermbg=236
	hi User3 guifg=#86868B guibg=#303030 ctermfg=102 ctermbg=236

" Syntax
	hi String guifg=#FF7E80 ctermfg=210
	hi Number guifg=#00fff2 ctermfg=50
	hi Comment gui=italic guifg=#6c6c6c ctermfg=242 font=Source_Code_Pro:h12
	hi Constant guifg=#D4FB79 ctermfg=192
	hi Boolean guifg=#FF5573 ctermfg=204
	hi Label guifg=#FF8AD8 ctermfg=212
	hi Conditional guifg=#00D392 ctermfg=48
	hi Special guifg=#585480 ctermfg=60
	hi Identifier guifg=salmon ctermfg=Red
	hi Include guifg=Red ctermfg=Red
	hi Operator guifg=#00D392 ctermfg=48
	hi Define guifg=gold gui=bold ctermfg=yellow cterm=bold
	hi Type guifg=#009193 ctermfg=2
	hi Function guifg=#00afd7 ctermfg=38
	hi Structure guifg=#65ba08 ctermfg=70
	hi Keyword guifg=#00D392 ctermfg=48
	hi Exception guifg=Red ctermfg=Red
	hi Repeat guifg=#00D392 ctermfg=48
	hi Underlined gui=underline ctermfg=5
	hi Question guifg=springgreen ctermfg=green
	hi SpecialKey guifg=#303030 ctermfg=236
	hi Special guifg=#FFF000 ctermfg=228
	hi SpecialChar guifg=Red ctermfg=Red
	hi Macro guifg=Red ctermfg=Red
	hi PreProc guifg=Red ctermfg=Red
	hi PreCondit guifg=Red ctermfg=Red
	hi Tag guifg=#ff00ff ctermfg=201
	hi Delimiter guifg=#FFD479 ctermfg=186 "parenthesis
	hi SpecialComment guifg=#6C7986 ctermfg=102

" Add highlight for the rest of the screen without text
	hi NonText guibg=#262626 guifg=RoyalBlue ctermbg=235 ctermfg=63
	hi EndOfBuffer guifg=grey10 guibg=#101010 ctermbg=232 ctermfg=253

	hi Ignore guifg=Grey40 cterm=bold ctermfg=7
	hi Todo guibg=yellow2 guifg=orangeRed ctermbg=190 ctermfg=2
	hi Directory guifg=#00af88 ctermfg=36

" Menu
	hi WildMenu guifg=#000000 guibg=#808000 ctermfg=0 ctermbg=3 

" Diff 
	hi MatchParen gui=bold guibg=NONE guifg=magenta cterm=bold ctermbg=NONE ctermfg=magenta
	if &diff 
		hi! link DiffText MatchParen
	endif
	hi DiffAdd guifg=#005fff guibg=NONE ctermfg=27 ctermbg=NONE
	hi DiffChange guifg=olive guibg=NONE ctermfg=3 ctermbg=NONE
	hi DiffDelete guifg=Red3 guibg=NONE ctermfg=160 ctermbg=NONE
	hi DiffText guifg=magenta guibg=NONE ctermfg=magenta ctermbg=NONE
	hi! link SignColumn LineNr

" GitGutter
	hi GitGutterAdd    guifg=#005fff ctermfg=27
	hi GitGutterChange guifg=olive ctermfg=3
	hi GitGutterDelete guifg=Red3 ctermfg=160

" Errors
	hi Error guibg=Red guifg=White ctermbg=Red ctermfg=White cterm=bold ctermfg=7 ctermbg=1
	hi ErrorMsg cterm=bold guibg=Red guifg=White ctermbg=Red ctermfg=White cterm=bold ctermfg=7 ctermbg=1
	hi SpellErrors guibg=Red guifg=White ctermbg=Red ctermfg=White gui=bold ctermfg=7 ctermbg=1
	hi WarningMsg guifg=salmon ctermfg=209

" Popup Menu
	hi Pmenu ctermfg=253 ctermbg=236 cterm=None guifg=#DCDCDC guibg=#303030
	hi PmenuSel ctermfg=42 ctermbg=238 cterm=Bold guifg=#36FF5A guibg=#444444 gui=Bold
	hi PmenuSbar ctermbg=Red guibg=Red
	hi PmenuThumb ctermfg=5 guifg=Purple
