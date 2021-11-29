" ------------------------------
" File: k_theme.vim
" Description: Kevin personal colorscheme for Vim/NeoVim/VimR
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/colors/k_theme.vim
" Last Modified: 27.11.21 14:54
" ------------------------------


" Section: Set Main Options
	let colors_name ='k_theme' 
	set background=dark
	set t_co=256
	
" Section: Font {
	set guifont=Source_Code_Pro:h13
" }

" Section: Modes
	hi Normal guifg=#d0d0d0 guibg=#141414 ctermfg=252 ctermbg=233
	hi Visual gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE
	" Selection Not Owned by vim
	hi VisualNOS gui=NONE guifg=#244E7A guibg=NONE cterm=NONE ctermfg=25 ctermbg=NONE

	hi ModeMsg guifg=DeepSkyBlue3 guibg=NONE ctermfg=31 ctermbg=NONE
	hi MoreMsg guifg=DeepSkyBlue3 ctermfg=32

	hi Title guifg=gold gui=bold cterm=bold ctermfg=yellow
	hi Statement guifg=#00afff ctermfg=39

	hi colorColumn guibg=#3a3a3a ctermbg=237

" Section: Cursor
	" set guicursor=n-v-i:blinkwait700-blinkon400-blinkoff250
	hi Cursor gui=NONE guibg=fg guifg=bg cterm=NONE ctermbg=fg ctermfg=bg
	hi LineNr guifg=#626262 guibg=#141414 ctermfg=241 ctermbg=232 
	hi Cursorline gui=NONE guifg=NONE guibg=grey15 cterm=NONE ctermfg=NONE ctermbg=235
	hi CursorLineNr guibg=NONE guifg=#36FF5A  gui=bold cterm=bold ctermbg=NONE ctermfg=42

	hi HighlightedyankRegion gui=reverse guibg=NONE cterm=reverse ctermbg=NONE

" Section: Split
	hi VertSplit guibg=bg guifg=fg ctermbg=fg ctermfg=bg

" Section: Folding
	hi Folded guibg=black guifg=Grey40 ctermfg=230 ctermbg=240
	hi FoldColumn guibg=black guifg=NONE ctermfg=4 ctermbg=NONE

" Section: Search
	hi IncSearch gui=bold guifg=#3a3a3a guibg=#36FF5A cterm=bold ctermfg=237 ctermbg=42
	hi Search gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE
	hi! link netrwMarkFile Search 
	hi QuickFixLine term=reverse ctermbg=52

" Section: Debugging
	hi Debug guifg=#ff0000 ctermfg=9

" Section: Status Line
	hi StatusLine guifg=#606060 guibg=#303030 ctermfg=236 ctermbg=236
	hi StatusLineNC guifg=#A9A9A9 guibg=#606060 ctermfg=7 ctermbg=244
	if !has('nvim')
		hi StatusLineTerm guifg=#606060 guibg=#303030 ctermbg=234 ctermfg=236
		hi StatusLineTermNC guifg=#A9A9A9 guibg=#606060 ctermfg=7 ctermbg=244
	endif

" Section: Users
	hi User1 guifg=#00ff87 guibg=#303030 ctermfg=48 ctermbg=236
	hi User2 guifg=#af8700 guibg=#303030 ctermfg=136 ctermbg=236
	hi User3 guifg=#86868B guibg=#303030 ctermfg=102 ctermbg=236
	hi User4 guifg=#303030 guibg=#101010 ctermfg=232 ctermbg=232

" Section: Syntax
	hi String guifg=#FF7E80 ctermfg=210
	hi Number guifg=#00fff2 ctermfg=50
	hi Comment gui=italic guifg=#626262 cterm=italic ctermfg=241
	hi Constant guifg=#D4FB79 ctermfg=192
	hi Boolean gui=bold guifg=#FF5573 cterm=bold ctermfg=204
	hi Label guifg=#FF8AD8 ctermfg=212
	hi Conditional guifg=#00ff87 ctermfg=48
	hi Special guifg=#585480 ctermfg=60
	hi Identifier guifg=#af5f5f ctermfg=131
	hi Include guifg=#ff0000 ctermfg=9
	hi Operator guifg=#00ff87 ctermfg=48
	hi Define gui=bold guifg=#afaf00 cterm=bold ctermfg=142
	hi Type guifg=#008080 ctermfg=6
	hi Function guifg=#00afd7 ctermfg=38
	hi Structure guifg=#5faf00 ctermfg=70
	hi Keyword guifg=#00ff87 ctermfg=48
	hi Exception guifg=#af0000 ctermfg=124
	hi Repeat guifg=#00ff87 ctermfg=48
	hi Underlined gui=underline guifg=#800080 cterm=underline ctermfg=5
	hi Question guifg=#00875f ctermfg=29
	hi SpecialKey guifg=#ffafd7 ctermfg=218
	hi Special guifg=#FFF000 ctermfg=228
	hi SpecialChar guifg=#FFF000 ctermfg=11
	hi Macro guifg=#870000 ctermfg=88
	hi PreProc guifg=#d75f00 ctermfg=166
	hi PreCondit guifg=#875f5f ctermfg=95
	hi Tag guifg=#ff00ff ctermfg=13
	hi Delimiter guifg=#d7d787 ctermfg=186
	hi SpecialComment guifg=#6C7986 ctermfg=102
	hi Todo gui=italic guibg=#d7ff00 guifg=#ff5f00 cterm=italic ctermbg=190 ctermfg=202
	hi Directory guifg=#00af87 ctermfg=36

" Section: End of buffer and non text
	hi NonText  guifg=#626262 guibg=#161616 ctermfg=241 ctermbg=63
	hi EndOfBuffer guifg=bg guibg=#161616 ctermfg=bg ctermbg=233

	hi Ignore gui=bold guifg=#5f5faf cterm=bold ctermfg=61

" Section: Menu
	hi WildMenu guifg=#161616 guibg=#808000 ctermfg=233 ctermbg=3

" Section: Diff
	hi MatchParen gui=bold guibg=NONE guifg=#ff00ff cterm=bold ctermbg=NONE ctermfg=13
	if &diff 
		hi! link DiffText MatchParen
	endif
	hi DiffAdd guifg=#005fff guibg=NONE ctermfg=27 ctermbg=NONE
	hi DiffChange guifg=#808000 guibg=NONE ctermfg=3 ctermbg=NONE
	hi DiffDelete guifg=#d70000 guibg=NONE ctermfg=160 ctermbg=NONE
	hi DiffText guifg=#ff00ff guibg=NONE ctermfg=201 ctermbg=NONE
	hi! link SignColumn LineNr

" Section: Errors
	hi Error guibg=#ffffff guifg=#ff0000 cterm=bold ctermfg=9 ctermbg=15
	hi ErrorMsg guibg=#ff0000 guifg=#ffffff cterm=bold ctermbg=9 ctermfg=15
	hi SpellErrors guifg=#ff005f ctermfg=197
	hi WarningMsg guifg=#ff5f00 ctermfg=202
	
" Section: Popup Menu
	hi Pmenu ctermfg=253 ctermbg=236 cterm=None guifg=#DCDCDC guibg=#303030
	hi PmenuSel gui=Bold guifg=#36FF5A guibg=#444444 cterm=bold ctermfg=42 ctermbg=238
	hi PmenuSbar guibg=#ff0000 ctermbg=9
	hi PmenuThumb guifg=#800080 ctermfg=5

" Section: CoC
	hi CocHighlightText gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE

