-------------------------------------
-- File: cmp.lua
-- Description: Lua K NeoVim & VimR cmp config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/cmp.lua
-- Last Modified: 11/01/22 - 15:24
-------------------------------------


local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

-- CMP {
		cmp.setup ({
			snippet = {
				expand = function(args)
					require'luasnip'.lsp_expand(args.body)
				end,
			},
			mapping = {
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
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
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'path' },
				{ name = 'cmdline' },
				-- { name = 'vim-snippets' }
				-- { name = 'ultisnips' },
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			documentation = false,
			-- documentation = {
			-- 	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			-- },
			experimental = {
				ghost_text = true,
				native_menu = false,
			},
		})

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
