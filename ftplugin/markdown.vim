" ------------------------------------------------
" File: markdown.vim
" Description: Filetype markdown specific settings in lua (the file is vim for
"								compatibility w/ tpope's syntax markdown.vim file)
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.vim
" Last Modified: 25/02/2022 - 11:54
" ------------------------------------------------


lua <<EOF
	if vim.fn.exists("b:ftplugin_markdown") == 1 then
			return
	end
	vim.b.ftplugin_markdown = 1

	vim.opt.conceallevel = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

	vim.opt.spell = false
  vim.opt.spellfile = '/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add'
EOF
