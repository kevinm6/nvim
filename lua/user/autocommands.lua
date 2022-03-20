 -------------------------------------
 -- File: autocommands.lua
 -- Description: Autocommands config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 20/03/2022 - 09:25
 -------------------------------------


vim.cmd [[
	augroup general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,git,fugitive nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup = "TextYankPost" }

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

