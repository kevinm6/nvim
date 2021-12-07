 -------------------------------------
 -- File: maps.lua
 -- Description: 
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/
 -- Last Modified: 05.12.21 05:29
 -------------------------------------


-- Section: Function to make easy mapping in Lua
	function map(mode, shortcut, command)
		vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = false })
	end

	function nmap(shortcut, command)
		map('n', shortcut, command)
	end

	function imap(shortcut, command)
		map('i', shortcut, command)
	end

	function vmap(shortcut, command)
		map('v', shortcut, command)
	end

	function cmap(shortcut, command)
		map('c', shortcut, command)
	end

	function tmap(shortcut, command)
		map('t', shortcut, command)
	end
-- }


-- Section: Special keys and commands {
	if vim.fn.exists(':tnoremap') == 1 then -- NeoVim & VimR keymaps
		nmap('<Leader>t', ':sb<bar>term<cr><C-W>J:resize12<cr>')
		tmap('<Esc>', '<C-\\><C-n>')

		if vim.fn.has('gui_vimr') == 1 then -- VimR keymaps (command key and others)
			map('<D-Right>', ' $')
			map('<D-Left>', ' 0')
			map('<D-down>', 'G')
			map('<D-up>', 'gg')
			nmap('<C-Tab>', 'gt')
			nmap('<C-S-Tab>', 'gT')
			imap('<D-BS>', '<C-u>')
			imap('<D-Del>', '<C-o>"_d$')
			imap('<D-Right>', '<Esc>A')
			imap('<D-Left>', '<Esc>I')
			imap('<D-Right>', '<C-o>$')
			imap('<D-Left>', '<C-o>0')
			imap('<D-down>', '<C-o>G')
			imap('<D-up>', '<C-o>gg')
			imap('<A-BS>', '<C-w>')
			imap('<A-Del>', '<C-o>"_dw')
		end
	else -- Vim keymaps
		imap('<ESC>oA', '<ESC>ki')
		imap('<ESC>oB', '<ESC>ji')
		imap('<ESC>oC', '<ESC>li')
		imap('<ESC>oD', '<ESC>hi')
	end
-- }



-- Section: N-V-O Mode {
	nmap('<A-Left>', 'b')
	nmap('<A-Right>', 'w')
-- }

-- Section: Command Mode {
	vim.cmd('set wcm=<C-Z>')
	cmap('<expr>', '<up> wildmenumode() ? "<Left>-- : "<up>"')
	cmap('<expr>', '<down> wildmenumode() ? "<Right>-- : "<down>"')
	cmap('<expr>', '<Left> wildmenumode() ? "<up>-- : "<left>"')
	cmap('<expr>', '<Right> wildmenumode() ? -- <bs><C-Z>": "\\<right>"')
-- }
	
-- Section: Insert Mode {
	imap('<Esc>', '<Esc>`^')
	imap('<A-Left>', '<Esc>bi')
	imap('<A-Right>', '<Esc>wi')
	imap('jk', '<Esc>')
	imap('kj', '<Esc>')
	imap('<S-Right>', '<C-o>vl')
	imap('<S-Left>', '<C-o>vh')
	imap('<S-down>', '<C-o>vj')
	imap('<S-up>', '<C-o>vk')
	imap('<S-Tab>', '<C-d>')
	imap('<F2>', '<C-R>=strftime("%d.%m.%y %H:%M")<CR>')
-- }

-- Section: Normal Mode {
	nmap('<Leader>html', ':-1read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a')
	nmap('<Leader>c', ':-1read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja')
	nmap('<Leader>java', ':-1read $NVIMDOTDIR/snippets/skeleton.java<CR>2jA<Left><Left><C-r>%<Esc>d2b2jo')
	nmap('<Leader>fjava', ':-1read $NVIMDOTDIR/snippets/method.java<CR>6jf(i')
	nmap('<Leader>inf', ':-1read $NVIMDOTDIR/snippets/skeleton.info<CR><C-v>}gc<Esc>gg<Esc>jA<C-r>%<Esc>4jA<F2><Esc>3kA')
	nmap('<Leader>md', ':-1read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go')
	nmap('<Leader>imd', ':-1read $NVIMDOTDIR/snippets/info.md<CR>i<C-r>%<Esc>6ggA<C-o>i<F2><Esc>Go')
	nmap('<silent><Leader>y', ':<C-u>CocList -A --normal yank<cr>')
	nmap('<silent><Leader>gs', ':Git status<CR>')
	nmap('<Leader>gaa', ':Git add .<CR>')
	nmap('<Leader>gc', ':Git commit -m \'\'<Left>')
	nmap('<Leader>gac', ':Git add % <bar> Git commit -m ""<Left>')
	nmap('<Leader>gdf', ':Git df % <CR>')
	nmap('<Leader>gda', ':Git df <CR>')
	nmap('<silent><Leader>gp', ':Git push<CR>')
	nmap('<C-l>', ':nohlsearch<CR><C-l>')
	nmap('<Tab>', '<C-W><C-W>')
	nmap('<S-Tab>', '<C-W><C-P>')
	nmap('<S-Left>', 'vh')
	nmap('<S-Right>', 'vl')
	nmap('<S-up>', 'vk')
	nmap('<S-down>', 'vj')
	nmap('S', ':%s///<Left><Left>')
	nmap('µ', ':CocCommand markdown-preview-enhanced.openPreview<CR>')
	nmap('˝', '<C-W>J')
	nmap('˛', '<C-W>K')
	nmap('¸', '<C-W>H')
	nmap('ˇ', '<C-W>L')
	nmap('Ø', 'O<Esc>j')
	nmap('ø', 'o<Esc>k')
	nmap('∂∂', ':Hexplore %:p:h<CR><C-W>K:resize12<cr>')

	nmap('x', '"_x')
	nmap('d', '"_d')
	nmap('D', '"_D')
	nmap('<leader>x', '""x')
	nmap('<leader>d', '""d')
	nmap('<leader>D', '""D')
-- }
	
-- Section: Visual Mode {
	vmap('<leader>d', '""dnmap † "_x')
	vmap('d', '"_d')
	vmap('<BS>', '"_d')

	vmap('<Tab>', '>')
	vmap('<S-Tab>', '')
	vmap(']', '')
	vmap('[', '')
	vmap('p', '_dP')
-- }

