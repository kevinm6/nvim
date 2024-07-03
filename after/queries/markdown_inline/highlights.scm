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

; this must be before the image shortcut_link(link_text) to avoid overriding
; since that is more specific
(shortcut_link
  [
    (link_text)
  ] @conceal
  (#set! conceal " "))

(image
  (image_description
    (shortcut_link
   [(link_text)] @conceal
  (#set! conceal " ")   )
    )
  )

(inline (html_tag) @conceal (#set! conceal ""))

(inline_link
  [
    (link_destination)
  ] @conceal
  (#set! conceal " "))