" -------------------------------------------------
" File: keymaps.vim
" Description: keymaps for NeoVim & VimR & Vim
" Author: Kevin
" Source: https://github.com/kevinm6/nvim/blob/nvim/core/keymaps.vim
" Last Modified: 01/12/21 - 16:59
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

" Section: N-V-O Mode {
	map <A-Left> b
	map <A-Right> w
" }

" Section: Command Mode {
	set wildcharm=<C-Z>
	cnor <expr> <up> wildmenumode() ? "\<Left>" : "\<up>"
	cnor <expr> <down> wildmenumode() ? "\<Right>" : "\<down>"
	cnor <expr> <Left> wildmenumode() ? "\<up>" : "\<left>"
	cnor <expr> <Right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
" }
	
" Section: Insert Mode {
	imap <silent> <expr> <c-Space> coc#refresh()
	imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	if exists('*complete_info')
		inor <silent><expr> <cr> complete_info(['selected'])['selected'] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
	endif
	inor <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	imap <Esc> <Esc>`^
	imap <A-Left> <Esc>bi
	imap <A-Right> <Esc>wi
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
	nmap <Leader>html :-1read $NVIMDOTDIR/snippets/skeleton.html<CR>3jf>a
	nmap <Leader>c :-1read $NVIMDOTDIR/snippets/skeleton.c<CR>4ja
	nmap <Leader>java :-1read $NVIMDOTDIR/snippets/skeleton.java<CR>2jA<Left><Left><C-r>%<Esc>d2b2jo
	nmap <Leader>fjava :-1read $NVIMDOTDIR/snippets/method.java<CR>6jf(i
	nmap <Leader>inf :-1read $NVIMDOTDIR/snippets/skeleton.info<CR><C-v>}gc<Esc>gg<Esc>jA<C-r>%<Esc>4jA<F2><Esc>3kA
	nmap <Leader>md :-1read $NVIMDOTDIR/snippets/skeleton.md<CR>A<Space><C-r>%<Esc>Go
	nmap <Leader>imd :-1read $NVIMDOTDIR/snippets/info.md<CR>i<C-r>%<Esc>6ggA<C-o>i<F2><Esc>Go
	nmap <silent><Leader>y  :<C-u>CocList -A --normal yank<cr>
	nmap <Leader>f :CocCommand explorer<CR>
	nmap <silent><Leader>gs :Git status<CR>
	nmap <Leader>gaa :Git add .<CR>
	nmap <Leader>gc :Git commit -m ''<Left>
	nmap <Leader>gac :Git add % <bar> Git commit -m ""<Left>
	nmap <Leader>gdf :Git df % <CR>
	nmap <Leader>gda :Git df <CR>
	nmap <silent><Leader>gp :Git push<CR>
	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gœ <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	" Use <C-k> to show documentation in preview window.
	nnoremap K :call <SID>show_documentation()<CR>
	nnoremap <C-l> :nohlsearch<CR><C-l>
	" nmap <silent> <leader> :<c-u>WhichKey ','<CR>
	nmap <Tab> <C-W><C-W>
	nmap <S-Tab> <C-W><C-P>
	nmap <S-Left> vh
	nmap <S-Right> vl
	nmap <S-up> vk
	nmap <S-down> vj
	nmap S :%s///<Left><Left>
	nmap µ :CocCommand markdown-preview-enhanced.openPreview<CR>
	nmap ˝ <C-W>J
	nmap ˛ <C-W>K
	nmap ¸ <C-W>H
	nmap ˇ <C-W>L
	nmap Ø O<Esc>j
	nmap ø o<Esc>k
	nmap ∂∂ :Hexplore %:p:h<CR><C-W>K:resize12<cr>

	nnoremap x "_x
	nnoremap d "_d
	nnoremap D "_D
	nnoremap <leader>d ""d
	nnoremap <leader>D ""D
" }
	
" Section: Visual Mode {
	vnoremap <leader>d ""dnmap † "_x
	vnoremap d "_d
	vmap <BS> "_d

	vmap <Tab> >
	vmap <S-Tab> <
	vmap ] >
	vmap [ <
	vmap p "_dP
" }

