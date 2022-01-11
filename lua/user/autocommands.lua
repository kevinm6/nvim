 -------------------------------------
 -- File: autocommands.lua
 -- Description:
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
 -- Last Modified: 11/01/22 - 09:55
 -------------------------------------

vim.cmd [[
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,spectre_panel,Scratch nnoremap <silent> <buffer> q :close<CR>
		autocmd TextYankPost * silent! lua require('vim.highlight').on_yank{higroup="Search", timeout=300}
	augroup end

	" Markdown
	augroup _markdown
		autocmd!
		autocmd BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md set filetype=markdown 
		autocmd FileType markdown setlocal wrap
		autocmd FileType markdown setlocal spell
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

	augroup _packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]]

