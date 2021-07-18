" --------------------------------------------------- 
" -------------- K Color Scheme Vim -----------------
" --------------------------------------------------- 

highlight clear 
if exists("syntax_on") 
 syntax reset 
endif

set background=dark
set t_co=256

"highlight dark
 
let colors_name ='K' 
hi Normal guifg=#DCDCDC guibg=#101010 ctermfg=253 ctermbg=232

hi NonText guibg=#262626 guifg=RoyalBlue ctermbg=235 ctermfg=63
hi EndOfBuffer guifg=#202020 guibg=#101010 ctermbg=232 ctermfg=234

hi colorColumn guibg=#606060 ctermbg=237

hi Cursor guibg=#36FF5A guifg=#36FF5A ctermbg=42 ctermfg=42
hi LineNr guibg=#101010 guifg=#808080 ctermbg=232 ctermfg=240
hi cursorline guibg=NONE cterm=NONE gui=NONE
hi cursorLineNr guibg=NONE guifg=#36FF5A gui=bold term=bold ctermbg=NONE ctermfg=42

hi VertSplit guibg=#c2bfa5 guifg=Grey40 gui=none cterm=reverse
hi Folded guibg=black guifg=Grey40 ctermfg=Grey ctermbg=darkGrey
hi FoldColumn guibg=black guifg=Grey20 ctermfg=4 ctermbg=7
hi IncSearch guibg=black guifg=green ctermbg=black ctermfg=green cterm=none ctermfg=yellow ctermbg=green

hi ModeMsg guifg=DeepSkyBlue3 ctermfg=32
hi MoreMsg guifg=DeepSkyBlue3 ctermfg=32
" now set it up to change the status line based on mode

hi Question guifg=springgreen ctermfg=green
hi Search guibg=#244E7A ctermbg=25 
hi SpecialKey guifg=#303030 ctermfg=236
hi Special guifg=#FFF000 ctermfg=228

hi SpecialChar guifg=Red
hi Tag guifg=#ff00ff ctermfg=201
hi Delimiter guifg=#FFD479 ctermfg=186 "parenthesis
hi SpecialComment guifg=#ff00ff ctermfg=201
hi Debug guifg=#ff0000 ctermfg=Red

hi StatusLine guifg=#A9A9A9 guibg=#303030 ctermbg=236 ctermfg=248
hi StatusLineNC guifg=#B0B0B0 guibg=#303030 ctermfg=7 ctermbg=242

hi User1 guifg=#00D392 guibg=#303030 ctermfg=48 ctermbg=236
hi User2 guifg=#A9A9A9 guibg=#303030 ctermfg=248 ctermbg=236
hi User3 guifg=#86868B guibg=#303030 ctermfg=102 ctermbg=236

hi Title guifg=gold gui=bold cterm=bold ctermfg=yellow
hi Statement guifg=#08adeb ctermfg=39

hi Visual guibg=#244E7A ctermbg=25 cterm=reverse

hi VisualNOS cterm=bold,underline

hi WarningMsg guifg=salmon ctermfg=1
hi Macro guifg=Red ctermfg=Red
hi PreProc guifg=Red ctermfg=Red
hi PreCondit guifg=Red ctermfg=Red

hi String guifg=#FF7E80 ctermfg=210
hi Number guifg=#00fff2 ctermfg=50
hi Comment gui=italic guifg=#6C7986 ctermfg=102 font=Source_Code_Pro:h12
hi Constant guifg=#D4FB79 ctermfg=192
hi Boolean guifg=#FF5573 ctermfg=204
hi Label guifg=#FF8AD8 ctermfg=212
hi Conditional guifg=#00D392 ctermfg=48
hi Special guifg=#585480 ctermfg=60
hi Identifier guifg=salmon ctermfg=Red
hi Include guifg=Red ctermfg=Red
hi Operator guifg=#00D392 ctermfg=48
hi Define guifg=gold gui=bold ctermfg=yellow
hi Type guifg=#009193 ctermfg=2
hi Function guifg=#0bafed ctermfg=38
hi Structure guifg=#65ba08 ctermfg=70
hi Keyword guifg=#00D392 ctermfg=48
hi Exception guifg=Red ctermfg=Red
hi Repeat guifg=#00D392 ctermfg=48

hi Ignore guifg=Grey40 cterm=bold ctermfg=7
hi Todo guibg=yellow2 guifg=orangeRed ctermbg=190 ctermfg=2
hi Directory guifg=#00af88 ctermfg=36
hi ErrorMsg cterm=bold guibg=Red guifg=White ctermbg=Red ctermfg=White cterm=bold ctermfg=7 ctermbg=1

hi WildMenu ctermfg=0 ctermbg=3
hi DiffAdd ctermbg=4
hi DiffChange ctermbg=5
hi DiffDelete cterm=bold ctermfg=4 ctermbg=6
hi DiffText cterm=bold ctermbg=1
hi Underlined gui=underline ctermfg=5
hi Error guibg=Red guifg=White ctermbg=Red ctermfg=White cterm=bold ctermfg=7 ctermbg=1
hi SpellErrors guibg=Red guifg=White ctermbg=Red ctermfg=White gui=bold ctermfg=7 ctermbg=1

hi Pmenu ctermfg=253 ctermbg=236 cterm=None guifg=#DCDCDC guibg=#303030
hi PmenuSel ctermfg=42 ctermbg=238 cterm=Bold guifg=#36FF5A guibg=#444444 gui=Bold
hi PmenuSbar ctermbg=Red guibg=Red
hi PmenuThumb ctermfg=5 guifg=Purple
