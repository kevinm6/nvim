 -------------------------------------
 -- File: autocommands.lua
 -- Description:
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 22/12/21 - 14:04
 -------------------------------------

vim.cmd [[
	" AutoCommands
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,spectre_panel nnoremap <silent> <buffer> q :close<CR>
		autocmd FileType qf set nobuflisted
		autocmd TextYankPost * silent! lua require('vim.highlight').on_yank{higroup="Search", timeout=300}
	augroup end

	augroup netrw_mapping
		autocmd!
		autocmd filetype netrw call	NetrwMapping()
	augroup end

	function! NetrwMapping()
		noremap <buffer>% :call CreateInPreview()<cr>
	endfunction

	function! CreateInPreview()
		let l:filename = input("⟩ Enter filename: ")
		execute 'splitbelow ' . b:netrw_curdir.'/'.l:filename
	endf

	" Markdown
	augroup _markdown
		autocmd!
		autocmd BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md set filetype=markdown 
	augroup end

	" SQL
	augroup _sql
		autocmd!
		autocmd BufNewFile, BufRead psql* setlocal filetype sql
	augroup end

	augroup _auto_resize
		autocmd!
		autocmd VimResized * tabdo wincmd =
	augroup end

	command! Scratch lua require'tool'.makeScratch()
]]
