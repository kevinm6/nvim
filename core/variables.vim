" ------------------------------------
" File: variables.vim
" Description: VimR & NeoVim settings
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/settings.vim
" Last Modified: 01/12/21 - 10:01
" ------------------------------------


" Section: Coc {
	let g:coc_config_home = "$NVIMDOTDIR/core/"

	let g:coc_global_extensions = [ 
	\ 'coc-yank', 
	\ 'coc-webview', 
	\ 'coc-syntax', 
	\ 'coc-snippets', 
	\ 'coc-pairs', 
	\ 'coc-lists', 
	\ 'coc-highlight', 
	\ 'coc-git', 
	\ 'coc-explorer', 
	\ 'coc-dictionary', 
	\ 'coc-xml', 'coc-sql', 
	\ 'coc-sourcekit', 
	\ 'coc-sh', 
	\ 'coc-python', 
	\ 'coc-markdownlint', 
	\ 'coc-markdown-preview-enhanced', 
	\ 'coc-json', 
	\ 'coc-java', 
	\ 'coc-gocode', 
	\ 'coc-go', 
	\ 'coc-css', 
	\ 'coc-clangd', 
	\ 'coc-translator', 
	\ 'coc-html-css-support', 
	\ 'coc-html', 
	\ 'coc-emoji', 
	\ 'coc-calc'
	\]
" }

" Section: Python {
	let g:python3_host_prog = "/usr/local/bin/python3.9"
" }

" Section: Database {
	let g:sql_type_default = 'postgresql'
	let g:omni_sql_no_default_maps = 1

	let g:dbs = {
		\ 'imdb': 'postgres://:@localhost/imdb',
		\ 'lezione': 'postgres://:@localhost/lezione'
		\}
" }

" Section: Markdown {
	let g:markdown_fenced_languages = [
				\ 'html', 
				\ 'python', 
				\ 'zsh', 
				\ 'java', 
				\ 'c', 'C',
				\ 'bash=sh', 
				\ 'json', 
				\ 'xml', 
				\ 'javascript', 'js=javascript', 
				\ 'css', 
				\ 'changelog', 
				\ 'cpp', 
				\ 'php', 
				\ 'pseudo', 
				\ 'sql' 
				\]

	let g:markdown_folding = 1
	let g:rmd_include_html = 1

" }


" Section: SESSION {
	let g:session_autosave = 'yes'
	let g:session_autoload = 'yes'
  let g:session_default_to_last = 1
" }


" Section: NETRW {
	let g:netrw_banner = 0 " disabling banner
	let g:netrw_preview = 1 " preview window in vertical split instead of horizontal
	let g:netrw_liststyle = 3 " set tree as default list appearance
	let g:netrw_browse_split = 1 " open files in vertical split
	let g:netrw_silent = 1 " transfers silently (no statusline changes when obtaining files
	let g:netrw_winsize = 26
	let g:netrw_keepdir = 0 " current dir & browsing dir synced
	let g:netrw_localcopydircmd = 'cp -r' " enable recursive copy command
	let g:netrw_mousemaps = 1
" }

