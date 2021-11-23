" -------------------------------------------------
" File: keymaps.vim
" Description: keymaps for NeoVim & VimR & Vim
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/keymaps.vim
" Last Modified: 22.11.21 15:30
" -------------------------------------------------


" Section: Special keys and commands {
	if exists(':tnoremap') " NeoVim & VimR keymaps
		nmap <Leader>t :sb<bar>term<cr><C-W>J:resize12<cr>
		tnoremap <Esc> <C-\><C-n>

		if has('gui_vimr') " VimR keymaps (command key and others)
			map <D-Right> $
			map <D-Left> 0
			map <D-down> G
			map <D-up> gg
			nmap <C-Tab> gt
			nmap <C-S-Tab> gT
			imap <D-BS> <C-u>
			imap <D-Del> <C-o>"_d$
			imap <D-Right> <Esc>A
			imap <D-Left> <Esc>I
			imap <D-Right> <C-o>$
			imap <D-Left> <C-o>0
			imap <D-down> <C-o>G
			imap <D-up> <C-o>gg
			imap <A-BS> <C-w>
			imap <A-Del> <C-o>"_dw
		endif
	else " Vim keymaps
		imap <ESC>oA <ESC>ki
		imap <ESC>oB <ESC>ji
		imap <ESC>oC <ESC>li
		imap <ESC>oD <ESC>hi
	endif
" }
	
" Section: Command Mode {
	set wildcharm=<C-Z>
	cnor <expr> <up> wildmenumode() ? "\<Left>" : "\<up>"
	cnor <expr> <down> wildmenumode() ? "\<Right>" : "\<down>"
	cnor <expr> <Left> wildmenumode() ? "\<up>" : "\<left>"
	cnor <expr> <Right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
" }
	
" Section: Insert Mode {
	imap <silent><expr> <c-space> coc#refresh()
	imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	imap <silent><expr><cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
	imap <Esc> <Esc>`^
	imap <A-Left> <Esc>Bi
	imap <A-Right> <Esc>Ei
	imap jk <Esc>
	imap kj <Esc>
	imap <S-Right> <C-o>vl
	imap <S-Left> <C-o>vh
	imap <S-down> <C-o>vj
	imap <S-up> <C-o>vk
	imap <S-Tab> <C-d>
	imap <F2> <C-R>=strftime("%d.%m.%y %H:%M")<CR>
" }

" Section: Normal Mode {
	nmap <A-Left> B
	nmap <A-Right> E
	nmap <Leader>html :-1read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a
	nmap <Leader>c :-1read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja
	nmap <Leader>java :-1read $NVIMDOTDIR/snippets/skeleton.java<CR>2j$o
	nmap <Leader>fjava :-1read $NVIMDOTDIR/snippets/method.java<CR>7ggt(a
	nmap <Leader>vim :-1read $NVIMDOTDIR/snippets/skeleton.vim<CR>jA<C-r>%<C-o>j<Space>
	nmap <Leader>md :-1read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go
	nmap <Leader>imd :-1read $NVIMDOTDIR/snippets/info.md<CR>i<C-r>%<Esc>6ggA<C-o>i<F2><Esc>Go
	nmap <silent> <Leader>y  :<C-u>CocList -A --normal yank<cr>
	nmap <Leader>f :CocCommand explorer<CR>
	nmap <silent><Leader>gs :Git status<CR>
	nmap <Leader>gaa :Git add .<CR>
	nmap <Leader>gc :Git commit -m ''<Left>
	nmap <Leader>gac :Git add <C-r>% <bar> Git commit -m ""<Left>
	nmap <silent><Leader>gp :Git push<CR>
	nmap <Space> <PageDown>
	nmap <Tab> <C-W><C-W>
	nmap <S-Tab> <C-W><C-P>
	nmap <S-Left> vh
	nmap <S-Right> vl
	nmap <S-up> vk
	nmap <S-down> vj
	nmap S :%s///g<Left><Left><Left>
	nmap µ :CocCommand markdown-preview-enhanced.openPreview<CR>
	nmap ˝ <C-W>J
	nmap ˛ <C-W>K
	nmap ¸ <C-W>H
	nmap ˇ <C-W>L
	nmap Ø O<Esc>j
	nmap ø o<Esc>k
	nmap ∂∂ :Hexplore %:p:h<CR><C-W>K:resize12<cr>
	nmap ∂å :Lexplore<CR>
	nmap † "_x
	nmap ∂ "_d
" }
	
" Section: Visual Mode {
	vmap <BS> "_d
	vmap <Tab> >
	vmap <S-Tab> <
	vmap ] >
	vmap [ <
	vmap p "_dP
" }

