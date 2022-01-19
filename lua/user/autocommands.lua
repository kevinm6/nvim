 -------------------------------------
 -- File: autocommands.lua
 -- Description: Autocommands config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 19/01/2022 - 10:50
 -------------------------------------

vim.cmd [[
	augroup general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,Scratch nnoremap <silent> <buffer> q :close<CR>
		autocmd TextYankPost * silent! lua require('vim.highlight').on_yank{higroup="Visual", timeout=320}

	" Markdown
		autocmd BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setlocal filetype=markdown 

	" SQL
		autocmd BufNewFile, BufRead psql* setlocal filetype=sql
	augroup end

	augroup auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end
]]

