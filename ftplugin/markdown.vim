" ------------------------------------------------
" File: markdown.vim
" Description: Filetype markdown specific settings in lua (the file is vim for
"								compatibility w/ tpope's plugin)
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.vim
" Last Modified: 11/12/21 - 11:35
" ------------------------------------------------


lua << EOF
	if vim.fn.exists("b:ftplugin_markdown") == 1 then
			return
	end
	vim.b.ftplugin_markdown = 1

	vim.opt.conceallevel = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

	vim.opt.cindent = true
	vim.opt.spell = false
	vim.opt.spelllang = { 'en_US', 'it_IT' }
EOF
