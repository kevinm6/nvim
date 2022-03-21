 -------------------------------------
 -- File: autocommands.lua
 -- Description: Autocommands config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 21/03/2022 - 09:02
 -------------------------------------


vim.cmd [[
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,git,fugitive nnoremap <silent> <buffer> q :close<CR>
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

  augroup _alpha
 autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
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

