-------------------------------------
-- File: cmp.lua
-- Description: Lua K NeoVim & VimR cmp config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/cmp.lua
-- Last Modified: 15/03/2022 - 14:08
-------------------------------------

local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

local ok_luasnip, luasnip = pcall(require, "luasnip")
if not ok_luasnip then return end

local icons = require "user.icons"


local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

-- Sources
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { ("./lua/") } })


 -- Luasnip Configuration
luasnip.config.set_config({
	history = true,
	updateevents = "TextChanged, TextChangedI",
	delete_check_events = "TextChanged",
})


-- Cmp Configuration
cmp.setup ({
	snippet = {
		expand = function(args)
			require'luasnip'.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() or not luasnip.in_snippet() then
				fallback()
			else
				fallback()
			end
		end, { "i", "s" }
		),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }
		),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
		-- Kind icons
		vim_item.kind = string.format("%s", icons.kind[vim_item.kind])
		vim_item.menu = ({
			-- nvim_lsp = "[LSP]",
			-- nvim_lua = "[Nvim]",
			-- luasnip = "[Snippet]",
			-- buffer = "[Buffer]",
			-- path = "[Path]",
			-- emoji = "[Emoji]",

			nvim_lsp = "",
			nvim_lua = "",
			luasnip = "",
			buffer = "",
			path = "",
			emoji = "",
		})[entry.source.name]
		return vim_item
	end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "cmdline" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	-- documentation = false,
	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
	experimental = {
		ghost_text = true,
		native_menu = false,
	},
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
	sources = {
		{
			{ name = "buffer" }
		}, {
			{ name = "buffer" }
		}
	}
})

-- Use cmdline & path source for '/'
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = "path" }
	}, {
		{ name = "cmdline" }
	})
})

