-------------------------------------
-- File: maps.lua
-- Description: Lua keymaps for NeoVim & VimR
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/maps.lua
-- Last Modified: 13/12/21 - 19:14
-------------------------------------


-- Section: Function to make easy mapping in Lua
	local opts = { noremap = true, silent = true }
	local term_opts = { silent = true }
	local keymap = vim.api.nvim_set_keymap
	vim.g.mapleader = ","
	vim.g.maplocalleader = ","
-- }


-- Section: Special keys and commands {
	if vim.fn.exists(':tnoremap') == 2 then -- NeoVim & VimR keymaps
		keymap('t', '<Leader>t', ':sb<bar>term<cr><C-W>J:resize12<cr>', term_opts)
		keymap('t', '<Esc>', '<C-\\><C-n>', term_opts)
		if vim.fn.has('gui_vimr') == 1 then -- VimR keymaps (command key and others)
			-- Normal-mode
			keymap('n', '<D-Right>', '$', opts)
			keymap('n', '<D-Left>', '0', opts)
			keymap('n', '<D-down>', 'G', opts)
			keymap('n', '<D-up>', 'gg', opts)
			keymap('n', '<C-Tab>', 'gt', opts)
			keymap('n', '<C-S-Tab>', 'gT', opts)
			-- Insert-mode
			keymap('i', '<D-Right>', '$', opts)
			keymap('i', '<D-Left>', '0', opts)
			keymap('i', '<D-down>', 'G', opts)
			keymap('i', '<D-up>', 'gg', opts)
			keymap('i', '<D-BS>', '<C-u>', opts)
			keymap('i', '<D-Del>', '<C-o>"_d$', opts)
			keymap('i', '<D-Right>', '<Esc>A', opts)
			keymap('i', '<D-Left>', '<Esc>I', opts)
			keymap('i', '<D-Right>', '<C-o>$', opts)
			keymap('i', '<D-Left>', '<C-o>0', opts)
			keymap('i', '<D-down>', '<C-o>G', opts)
			keymap('i', '<D-up>', '<C-o>gg', opts)
			keymap('i', '<M-BS>', '<C-w>', opts)
			keymap('i', '<M-Del>', '<C-o>"_dw', opts)
			-- Visual-mode
			keymap('v', '<D-Right>', '$', opts)
			keymap('v', '<D-Left>', '$', opts)
			keymap('v', '<D-down>', 'G', opts)
			keymap('v', '<D-up>', 'gg', opts)
		end
	else -- Vim keymaps
		keymap('i', '<ESC>oA', '<ESC>ki', opts)
		keymap('i', '<ESC>oB', '<ESC>ji', opts)
		keymap('i', '<ESC>oC', '<ESC>li', opts)
		keymap('i', '<ESC>oD', '<ESC>hi', opts)
	end
-- }


-- Section: Insert Mode {
	keymap('i', '<Esc>', '<Esc>`^', opts)
	keymap('i', '<M-Left>', '<Esc>bi', opts)
	keymap('i', '<M-Right>', '<Esc>wi', opts)
	keymap('i', 'jk', '<Esc>', opts)
	keymap('i', 'kj', '<Esc>', opts)
	keymap('i', '<S-Right>', '<C-o>vl', opts)
	keymap('i', '<S-Left>', '<C-o>vh', opts)
	keymap('i', '<S-down>', '<C-o>vj', opts)
	keymap('i', '<S-up>', '<C-o>vk', opts)
	keymap('i', '<S-Tab>', '<C-d>', opts)
	keymap('i', '<F2>', '<C-R>=strftime("%d/%m/%y - %H:%M")<CR>', opts)
-- }

-- Section: Normal Mode {
	keymap('n', '<Leader>html', ':-1read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a', opts)
	keymap('n', '<Leader>c', ':-1read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja', opts)
	keymap('n', '<Leader>java', ':-1read $NVIMDOTDIR/snippets/skeleton.java<CR>2jA<Left><Left><C-r>%<Esc>d2b2jo', opts)
	keymap('n', '<Leader>fjava', ':-1read $NVIMDOTDIR/snippets/method.java<CR>6jf(i', opts)
	keymap('n', '<Leader>inf', ':-1read $NVIMDOTDIR/snippets/skeleton.info<CR><C-v>}gc<Esc>gg<Esc>jA<C-r>%<Esc>4jA<F2><Esc>3kA', opts)
	keymap('n', '<Leader>md', ':-1read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go', opts)
	keymap('n', '<Leader>imd', ':-1read $NVIMDOTDIR/snippets/info.md<CR>i<C-r>%<Esc>6ggA<C-o>i<F2><Esc>Go', opts)
	keymap('n', '<Leader>y', ':<C-u>CocList -A --normal yank<cr>', opts)
	keymap('n', '<Leader>gs', ':Git status<CR>', opts)
	keymap('n', '<Leader>gaa', ':Git add .<CR>', opts)
	keymap('n', '<Leader>gc', ':Git commit -m \'\'<Left>', opts)
	keymap('n', '<Leader>gac', ':Git add % <bar> Git commit -m ""<Left>', opts)
	keymap('n', '<Leader>gdf', ':Git df % <CR>', opts)
	keymap('n', '<Leader>gda', ':Git df <CR>', opts)
	keymap('n', '<Leader>w', ':write<CR>', opts)
	keymap('n', '<Leader>gp', ':Git push<CR>', opts)
	keymap('n', '<C-l>', ':nohlsearch<CR><C-l>', opts)
	keymap("n", "<S-l>", ":bnext<CR>", opts)
	keymap("n", "<S-h>", ":bprevious<CR>", opts)
	keymap('n', '<M-Left>', 'b', opts)
	keymap('n', '<M-Right>', 'w', opts)
	keymap('n', 'U', '<C-r>', opts)
	keymap('n', '<Tab>', '<C-W><C-W>', opts)
	keymap('n', '<S-Tab>', '<C-W><C-P>', opts)
	keymap('n', '<S-Left>', 'vh', opts)
	keymap('n', '<S-Right>', 'vl', opts)
	keymap('n', '<S-up>', 'vk', opts)
	keymap('n', '<S-down>', 'vj', opts)
	keymap('n', 'S', ':%s///<Left><Left>', opts)
	keymap('n', 'µ', ':CocCommand markdown-preview-enhanced.openPreview<CR>', opts)
	keymap('n', '˝', '<C-W>J', opts)
	keymap('n', '˛', '<C-W>K', opts)
	keymap('n', '¸', '<C-W>H', opts)
	keymap('n', 'ˇ', '<C-W>L', opts)
	keymap('n', 'Ø', 'O<Esc>j', opts)
	keymap('n', 'ø', 'o<Esc>k', opts)
	keymap('n', '∂∂', ':Hexplore %:p:h<CR><C-W>K:resize12<cr>', opts)

	-- delete & cut
	keymap('n', 'x', '"_x', opts)
	keymap('n', 'd', '"_d', opts)
	keymap('n', 'D', '"_D', opts)
	keymap('n', '<leader>x', '""x', opts)
	keymap('n', '<leader>d', '""d', opts)
	keymap('n', '<leader>D', '""D', opts)
-- }


-- Section: Visual Mode {
	keymap('v', '<leader>d', '""dnmap † "_x', opts)
	keymap('v', 'd', '"_d', opts)
	keymap('v', '<BS>', '"_d', opts)

	keymap('v', '<M-Left>', 'b', opts)
	keymap('v', '<M-Right>', 'w', opts)

	keymap('v', '<Tab>', '>', opts)
	keymap('v', '<S-Tab>', '', opts)
	keymap('v', ']', '', opts)
	keymap('v', '[', '', opts)
	keymap('v', 'p', '_dP', opts)
-- }

