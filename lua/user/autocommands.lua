 -------------------------------------
 -- File: autocommands.lua
 -- Description: Autocommands config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 17/01/2022 - 10:44
 -------------------------------------

vim.cmd [[
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,Scratch nnoremap <silent> <buffer> q :close<CR>
		autocmd TextYankPost * silent! lua require('vim.highlight').on_yank{higroup="Search", timeout=320}
	augroup end

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
]]

