" -----------------------------------
"	File: pseudocode.vim
"	Description: pseudocode syntax for Vim / NeoVim
"	Author: Kevin
"	Last Modified: 26 Aug 2022, 21:53
" -----------------------------------

syntax case ignore

syn keyword pseudoStatement     function procedure class func class error nextgroup=pseudoFunction skipwhite
syn keyword pseudoPrint         print
syn match   pseudoFunction      "[a-zA-z][a-zA-Z0-9_]*" display contained
syn keyword pseudoFunction      add sum length append remove pop size insert indexOf let
syn keyword pseudoConditional   if else endif
syn keyword pseudoRepeat        for to while foreach endfor endwhile endforeach return pass break each continue
syn keyword pseudoOperator      and in is not or do then to
syn keyword pseudoBuiltIn       string float int list double long array arraylist dictionary dict tree graph 
syn keyword pseudoBoolean       true false

syn region  pseudoString        start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend
syn region  pseudoString        start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend

syn match   pseudoComment       '//.*$' display
syn match   pseudoComment       '#.*$' display

syn match   pseudoNumber        '\<\d\>' display
syn match   pseudoNumber        '\<[1-9][_0-9]*\d\>' display
syn match   pseudoNumber        '\<\d[jJ]\>' display
syn match   pseudoNumber        '\<[1-9][_0-9]*\d[jJ]\>' display

syn match   pseudoFloat         '\.\d\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=\>' display
syn match   pseudoFloat         '\<\d\%([_0-9]*\d\)\=[eE][+-]\=\d\%([_0-9]*\d\)\=[jJ]\=\>' display
syn match   pseudoFloat         '\<\d\%([_0-9]*\d\)\=\.\d\=\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=' display

hi def link pseudoNumber        Number
hi def link pseudoFloat         Float
hi def link pseudoString        String
hi def link pseudoStatement     Statement
hi def link pseudoPrint         Special 
hi def link pseudoFunction      Function
hi def link pseudoConditional   Conditional
hi def link pseudoRepeat        Repeat
hi def link pseudoOperator      Operator
hi def link pseudoBuiltIn       Type 
hi def link pseudoString        String
hi def link pseudoBoolean       Boolean
hi def link pseudoComment       Comment
