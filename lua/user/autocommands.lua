 -------------------------------------
 -- File: autocommands.lua
 -- Description: Autocommands config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 24/03/2022 - 15:20
 -------------------------------------


-- TODO: change to lua autocmd when it will be available

vim.cmd [[
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,git,fugitive nnoremap <silent> <buffer> q :close<CR>
		autocmd FileType qf,help,man,lspinfo,git,fugitive nnoremap <silent> <buffer> <Esc> :close<CR>
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 200 })
  augroup end

  augroup _markdown
	" Markdown
		autocmd BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md setlocal filetype=markdown 
  augroup end

  augroup _sql
	" SQL
		autocmd BufNewFile, BufRead psql* setlocal filetype=sql
	augroup end

  augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi link illuminatedWord LspReferenceText
  augroup END

	augroup auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end
]]

