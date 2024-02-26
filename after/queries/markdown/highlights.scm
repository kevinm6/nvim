;; inherits: markdown
;; extends

([
  (atx_h1_marker)
] @conceal (#set! conceal "󰉫"))
([
  (atx_h2_marker)
] @conceal (#set! conceal "󰉬"))
([
  (atx_h3_marker)
] @conceal (#set! conceal "󰉭"))
([
  (atx_h4_marker)
] @conceal (#set! conceal "󰉮"))
([
  (atx_h5_marker)
] @conceal (#set! conceal "󰉯"))
([
  (atx_h6_marker)
] @conceal (#set! conceal "󰉰"))

(list
  (list_item
    (list_marker_minus) @conceal (#set! conceal "")
    (task_list_marker_checked)
    ))

(list
  (list_item
    (list_marker_minus) @conceal (#set! conceal "")
    (task_list_marker_unchecked)
    ))

([
  (task_list_marker_checked)
  ] @conceal (#set! conceal ""))

([
  (task_list_marker_unchecked)
  ] @conceal (#set! conceal ""))


;; (fenced_code_block
;;   (info_string) @devicon
;;   (#as_devicon! @devicon))

([
  (block_quote_marker)
  (block_continuation)
] @conceal (#set! conceal "|"))

(fenced_code_block
  (info_string (language) @_language)
  (#any-of? @_language "sh" "bash")
  (code_fence_content) @bash)