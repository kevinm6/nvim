;; inherits: markdown_inline
;; extends
((entity_reference) @conceal (#eq? @conceal "&rarr;") (#set! conceal ""))
((entity_reference) @conceal (#eq? @conceal "&larr;") (#set! conceal ""))
((entity_reference) @conceal (#eq? @conceal "&uarr;") (#set! conceal ""))
((entity_reference) @conceal (#eq? @conceal "&darr;") (#set! conceal ""))

(image
  [
    (link_destination)
  ] @conceal
  (#set! conceal " " ))

(inline_link
  [
    (link_destination)
  ] @conceal
  (#set! conceal " "))