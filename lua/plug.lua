-------------------------------------
-- File: plug.lua
-- Description: Lua K NeoVim & VimR plugins w/ packer
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/plug.lua
-- Last Modified: 10/12/21 - 10:10
-------------------------------------


-- Section: PLUGINS {

	local use = require('packer').use
	require('packer').startup(function()
		use {
			-- Plugin/package manager
			'wbthomason/packer.nvim',

			-- lsp
			'neovim/nvim-lspconfig',
			'williamboman/nvim-lsp-installer',

			-- autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'windwp/nvim-autopairs',

			-- file finder
			'nvim-telescope/telescope.nvim',

			-- coding helper
			'nvim-treesitter/nvim-treesitter',
			'tpope/vim-surround',
			'tpope/vim-commentary',
			{ 'junegunn/goyo.vim', run = ':Goyo' },

			-- git
			'tpope/vim-fugitive',
			{ 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } },

			'nvim-lua/plenary.nvim',
			'nvim-lua/popup.nvim',

			-- snippets
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			{'honza/vim-snippets', cmd = 'InsertEnter'},

			-- database
			{ 'tpope/vim-dadbod', ft = { 'sql' }, cmd = 'DB' },
			{ 'kristijanhusak/vim-dadbod-ui', ft = { 'sql' }, cmd = 'DBUI' },

			-- markdown
			{ 'joelbeedle/pseudo-syntax', cmd = 'InsertEnter', ft = { 'markdown', 'pseudo', 'md' } },
			{ 'tpope/vim-markdown', ft = { 'markdown', 'pseudo', 'md', 'latex' } },
			{ 'iamcco/markdown-preview.nvim', ft = { 'markdown', 'pseudo', 'md' },
				run = 'cd app && yarn install',
				cmd = 'MarkdownPreview',
			},

			-- pdf
			{ 'makerj/vim-pdf', ft = { 'pdf' } },

			-- theme
			{ 'morhetz/gruvbox', opt = true, cmd = { 'colorscheme' } }

		}
	end)
-- }

-- PER-PLUGIN SETTINGS {

	-- NVIM-LSP-INSTALLER {
		local lsp_installer = require('nvim-lsp-installer')
		lsp_installer.settings({
			ui = {
				server_installed = "✓",
				server_pending = "➜",
				server_uninstalled = "✗"
			},
			keymaps = {
				toggle_server_expand = "<CR>", "o"
			},
		})

		lsp_installer.on_server_ready(function(server)

		-- Specify the default options which we'll use to setup all servers
		local default_opts = {
			on_attach = on_attach,
		}

		local server_opts = {}

		-- Use the server's custom settings, if they exist, otherwise default to the default options
		local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
			server:setup(server_options)
		end)
	-- nvim-lsp-installer }

	-- CMP {
		local cmp =  require('cmp')
		cmp.setup {
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			mapping = {
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<Down>'] = cmp.mapping.select_next_item(),
				['<Up>'] = cmp.mapping.select_prev_item(),
				['<Left>'] = cmp.mapping.abort(),
				['<Right>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					-- Insert-mode
					i = cmp.mapping.confirm({ select = true }),
					-- Command-mode
					c = cmp.mapping.confirm({ select = false })
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'buffer' },
				{ name = 'path' },
				{ name = 'cmdline' },
				{ name = 'luasnip' }
				-- { name = 'ultisnips' },
			},
		}
		-- Use buffer source for `/`
		cmp.setup.cmdline('/', {
			sources = {
				{ name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
			}
		})
		-- }	

		-- Use cmdline & path source for '/'
		cmp.setup.cmdline(':', {
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			})
		})
		-- }
	-- cmp }


	-- AUTOPAIRS {
		local autopairs = require('nvim-autopairs')
		autopairs.setup({
			disable_filetype = { "TelescopePrompt" },
			cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({  map_char = { tex = '' } }))
		})
	-- autopairs }


	-- GITSIGNS {
		require('gitsigns').setup {
			signs = {
				add = {
					hl = 'GitSignsAdd',	text = '+',
					numhl='GitSignsAddNr', linehl='GitSignsAddLn'
				},
				change = {
					hl = 'GitSignsChange', text = '\\', 
					numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'
				},
				delete = {
					hl = 'GitSignsDelete', text = '_',
					numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
				},
				topdelete = {
					hl = 'GitSignsDelete', text = '‾',
					numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
				},
				changedelete = {
					hl = 'GitSignsChange', text = '~',
					numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
				},
			},
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
		}
	-- gitsigns }

-- per-plugin settings }
