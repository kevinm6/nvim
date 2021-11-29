" ------------------------------------
" File: init.vim
" Description: Neovim K configuration
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/init.vim
" Last Modified: 29.11.21 09:45
" ------------------------------------


" Section: check VScode/codium 
	if exists('g:vscode')
		finish
	endif

	if !has('nvim')
		source $VIMDOTDIR/vimrc
		finish
	elseif has('gui_vimr')
		source $NVIMDOTDIR/ginit.vim
		finish
	endif
" }

" Section: Path Settings {
	set rtp+=~/.config/nvim/
	set viminfo+=n~/.local/share/nvim/main.shada
	set packpath+=&runtimepath
	set path+=**
	set shada='20,<50,s10
	set undodir=$HOME/.local/share/nvim/tmp/undo " undo dir
" }


" Section: Global Vars {
	" Coc
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

	" Python
	let g:python3_host_prog = "/usr/local/bin/python3.9"

	" Database
	let g:sql_type_default = 'postgresql'
	let g:omni_sql_no_default_maps = 1

	let g:dbs = {
		\ 'imdb': 'postgres://:@localhost/imdb',
		\ 'lezione': 'postgres://:@localhost/lezione'
		\}

	" Markdown
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


" Section: set mapleader & add maps configFile edit/source {
	let mapleader = ","
	nmap <Leader>e :e $NVIMDOTDIR/init.vim<CR>
	nmap <Leader>s :source $NVIMDOTDIR/init.vim<CR>
" }

	runtime! core/*.vim
