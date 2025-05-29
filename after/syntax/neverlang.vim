if exists("b:current_syntax")
    finish
endif

syntax keyword neverlangKeyword module slice slices role roles reference concrete syntax from with language endemic imports provides requires tags 
syntax keyword neverlangRoleKeyword eval

syntax match neverlangComment "\v//.*$"
syntax match neverlangNumber "\v\$[0-9]+"
syntax region neverlangMultilineComment start="/\*" end="\*/"
syntax region neverlangMultilineComment start="/\*" end="\*/"
syntax region neverlangQuotedString start=+"+  skip=+\\\\\|\\"+  end=+"\|$+ oneline
syntax region neverlangRegex start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/+ oneline

highlight link neverlangKeyword Keyword
highlight link neverlangRoleKeyword Function
highlight link neverlangComment Comment
highlight link neverlangQuotedString String
highlight link neverlangRegex Special

highlight link neverlangMultilineComment Comment
highlight link neverlangNumber Number 

let b:current_syntax = "neverlang"

