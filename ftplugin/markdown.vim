" ------------------------------------------------
" File: markdown.vim
" Description: Filetype markdown specific settings in lua (the file is vim for
"								compatibility w/ tpope's syntax markdown.vim file)
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/ftplugin/markdown.vim
" Last Modified: 22/03/2022 - 10:23
" ------------------------------------------------


lua <<EOF
	if vim.fn.exists("b:ftplugin_markdown") == 1 then
			return
	end
	vim.b.ftplugin_markdown = 1

	vim.opt_local.conceallevel = 2
	vim.opt_local.shiftwidth = 2
	vim.opt_local.expandtab = true
  vim.opt_local.wrap = true
  vim.opt_local.cindent = true

	vim.opt.spell = false
  vim.opt.spellfile = '/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add'
EOF
