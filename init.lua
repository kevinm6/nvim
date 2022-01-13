--------------------------------------
-- File: init.lua
-- Description: NeoVim K configuration (Lua)
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/init.lua
-- Last Modified: 13/01/22 - 14:20
--------------------------------------


-- Section: check VScodium | Vim (standard)
	if vim.fn.exists('g:vscode') == 1 then
		return
	elseif not(vim.fn.has('nvim')) == 1 then
		vim.cmd	'source ~/.config/vim/vimrc'
		return
	end
-- }

-- Section: Config Files to source {
	require "user.prefs"
	require "user.maps"
	require "user.plugins"
	require "user.vars"
	require "user.cmp"
	require "user.lsp"
	require "user.telescope"
	require "user.treesitter"
	require "user.autopairs"
  require "user.comment"
	require "user.gitsigns"
	require "user.nvim-tree"
	require "user.bufferline"
	require "user.toggleterm"
	require "user.whichkey"
	require "user.autocommands"
	require "user.statusline"
	require "user.surround"
	require "user.renamer"
	require "user.registers"
-- }
