" -------------------------------
" File         : k_theme.vim
" Description  : Kevin personal colorscheme for Vim/NeoVim/VimR
" Author       : Kevin
" Source       : https://github.com/kevinm6/nvim/blob/nvim/colors/k_theme.vim
" Last Modified: 26/03/2022 - 10:18
" -------------------------------


" Section: Set Main Options
let colors_name ='k_theme' 
set t_co=256


" Section: Modes
hi Normal guifg=#d0d0d0 guibg=grey11 ctermfg=252 ctermbg=234
hi Visual gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE
" Selection Not-Owned by Vim
hi VisualNOS gui=NONE guifg=#244E7A guibg=NONE cterm=NONE ctermfg=25 ctermbg=NONE

if v:version >= 700
  hi WinSeparator guibg=NONE ctermbg=NONE
endif

hi ModeMsg guifg=DeepSkyBlue3 guibg=NONE ctermfg=31 ctermbg=NONE
hi MoreMsg guifg=DeepSkyBlue3 ctermfg=32


hi colorColumn guibg=bg ctermbg=bg

" Section: Cursor
" set guicursor=n-v-i:blinkwait700-blinkon400-blinkoff250
hi Cursor gui=reverse guibg=NONE guifg=NONE cterm=reverse ctermbg=NONE ctermfg=NONE
hi LineNr guifg=#626262 guibg=bg ctermfg=241 ctermbg=bg 
hi Cursorline gui=NONE guifg=NONE guibg=grey15 cterm=NONE ctermfg=NONE ctermbg=235
hi CursorLineNr guibg=NONE guifg=#36FF5A  gui=bold cterm=bold ctermbg=NONE ctermfg=42

hi TextYankPost gui=reverse guibg=NONE guifg=NONE cterm=reverse ctermbg=NONE ctermfg=NONE

" Section: Split
hi VertSplit guibg=bg guifg=fg ctermbg=fg ctermfg=bg

" Section: Folding
hi Folded guibg=black guifg=Grey40 ctermfg=230 ctermbg=240
hi FoldColumn guibg=NONE guifg=fg ctermbg=NONE ctermfg=fg

" Section: Search
hi IncSearch gui=bold guifg=#3a3a3a guibg=#36FF5A cterm=bold ctermfg=237 ctermbg=42
hi Search gui=reverse guifg=NONE guibg=NONE cterm=reverse ctermfg=NONE ctermbg=NONE
hi QuickFixLine term=reverse ctermbg=52

" Section: Debugging
hi Debug guifg=#ff0000 ctermfg=9

" Section: Status Line
hi StatusLine guifg=#606060 guibg=#303030 ctermfg=236 ctermbg=236
hi StatusLineNC guifg=#A9A9A9 guibg=#606060 ctermfg=7 ctermbg=244
if !has('nvim')
  hi StatusLineTerm guifg=#606060 guibg=#303030 ctermbg=234 ctermfg=236 hi StatusLineTermNC guifg=#A9A9A9 guibg=#606060 ctermfg=7 ctermbg=244
endif

" Section: TabLine
hi TabLineSel guifg=#606060 guibg=#303030 ctermfg=236 ctermbg=236
hi TabLine guifg=#A9A9A9 guibg=#606060 ctermfg=7 ctermbg=244


" Section: Users (StatusLine)
hi User1 guifg=#158C8A guibg=grey15 ctermfg=30 ctermbg=235
hi User2 guifg=#af8700 guibg=grey15 ctermfg=136 ctermbg=235
hi User3 guifg=#86868B guibg=grey15 ctermfg=102 ctermbg=235
hi User4 guifg=grey15 guibg=grey11 ctermfg=235 ctermbg=234
hi User5 guifg=grey23 guibg=grey11 ctermfg=237 ctermbg=234
hi User6 guifg=#36FF5A guibg=grey15 ctermfg=42 ctermbg=235

" Section: Syntax
hi Title gui=bold,italic guifg=Gold1 cterm=bold,italic ctermfg=220
hi Statement guifg=#00afff ctermfg=39
hi Directory gui=bold guifg=#00af87 cterm=bold ctermfg=36

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
hi Special gui=italic guifg=#ffff87 cterm=italic ctermfg=228
hi SpecialChar guifg=#FFF000 ctermfg=11
hi Macro guifg=#870000 ctermfg=88
hi PreProc guifg=#d75f00 ctermfg=166
hi PreCondit guifg=#875f5f ctermfg=95
hi Tag guifg=#ff00ff ctermfg=13
hi Delimiter guifg=#d7d787 ctermfg=186
hi SpecialComment guifg=#6C7986 ctermfg=102
hi Todo gui=italic guibg=#d7ff00 guifg=#ff5f00 cterm=italic ctermbg=190 ctermfg=202

" Section: End of buffer and non text
hi NonText  guifg=#626262 guibg=bg ctermfg=241 ctermbg=bg
hi EndOfBuffer guifg=bg guibg=bg ctermfg=bg ctermbg=bg

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
hi Pmenu ctermfg=253 ctermbg=236 guifg=#DCDCDC guibg=#303030
hi PmenuSel gui=Bold guifg=#36FF5A guibg=#444444 cterm=bold ctermfg=42 ctermbg=238
hi PmenuSbar guibg=#262626 ctermbg=235
hi PmenuThumb guibg=#585858 ctermbg=240

" Section: Nvim-Tree
hi! link NvimTreeSymlink Function
hi! link NvimTreeFolderName Normal
hi! link NvimTreeRootFolder Type
hi NvimTreeFolderIcon guifg=#00afd7 ctermfg=38
" hi NvimTreeFileIcon
" NvimTreeEmptyFolderName
hi! link NvimTreeOpenedFolderName Directory
hi! link NvimTreeExecFile Underlined
hi NvimTreeOpenedFile gui=bold,underline cterm=bold,underline
hi NvimTreeSpecialFile gui=bold,italic guifg=#afaf00 cterm=bold,italic ctermfg=142
hi! link NvimTreeImageFile Label
hi! link NvimTreeIndentMarker Comment


" Section: Cmp
hi CmpItemAbbr guifg=#DCDCDC guibg=NONE ctermfg=253 ctermbg=NONE
hi! link CmpItemKind Function
hi CmpItemAbbrMatch guifg=#00af87 guibg=NONE ctermfg=36 ctermbg=NONE

" Section: Lsp
hi FloatBorder guibg=grey15 ctermbg=235
hi LspReferenceText gui=NONE guifg=NONE guibg=grey27 cterm=NONE ctermfg=NONE ctermbg=238
hi LspReferenceWrite gui=NONE guibg=grey42 cterm=NONE ctermbg=242
hi LspReferenceRead gui=NONE guibg=grey23 cterm=NONE ctermbg=237

" Section: Lsp Diagnostic
hi DiagnosticError guifg=#f44747 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsWarning guifg=#ff8800 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsInformation guifg=#ffcc66 ctermfg=221 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsHint guifg=#4fc1ff ctermfg=75 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsSignError guifg=#f44747 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsSignWarning guifg=#ff8800 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsSignInformation guifg=#ffcc66 ctermfg=221 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsSignHint guifg=#4fc1ff ctermfg=75 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsVirtualTextError guifg=#f44747 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsVirtualTextWarning guifg=#ff8800 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsVirtualTextInformation guifg=#ffcc66 ctermfg=221 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticsVirtualTextHint guifg=#4fc1ff ctermfg=75 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Section: Alpha
hi AlphaHeader guifg=#74D15C ctermfg=113
hi! link AlphaButtons Keyword
hi! link AlphaFooter Comment
