" Vim syntax file
" Language: Markdown
" Mantainer: Kevin Manca
" Latest Revision: 21 October 2021

if exists("b:current_syntax")
  finish
endif

" Custom conceal
syntax match todoCheckbox "\[\ \]" conceal cchar=◻️
syntax match todoCheckbox "\[x\]" conceal cchar=☑️

let b:current_syntax = "todo"

hi def link todoCheckbox Todo
hi Conceal guibg=NONE

setlocal cole=1
