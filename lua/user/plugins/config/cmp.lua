-------------------------------------
-- File         : cmp.lua
-- Description  : Lua K NeoVim & VimR cmp config
-- Author       : Kevin
-- Last Modified: 27 Aug 2022, 09:50
-------------------------------------

local cmp_ok, cmp = pcall(require, "cmp")
local cmd_dap_ok, cmp_dap = pcall(require, "cmp_dap")
local ls_ok, ls = pcall(require, "luasnip")

if (not cmp_ok) or (not cmd_dap_ok) or (not ls_ok) then return end

local icons = require "user.icons"
local icons_kind = icons.kind

-- Cmp Configuration
cmp.setup {
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},

  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or cmp_dap.is_dap_buffer()
  end,

  mapping = cmp.mapping.preset.insert {
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

		["<C-n>"] = cmp.mapping(function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
		end, { "i", "s" }),

		["<C-p>"] = cmp.mapping(function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
		end, { "i", "s" }),

		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),

		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),

		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    ["<C-l>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.complete_common_string()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { "i", "c" }),

		["<C-e>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},

    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Right>"] = cmp.mapping.confirm { select = true },

    ["<M-CR>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),

		["<Tab>"] = cmp.mapping{
			i = function(fallback) -- InsertMode
				return ls.expand_or_jumpable() and
					ls.expand_or_jump() or fallback()
			end,
			s = function(fallback) -- SelectMode
				return ls.expand_or_jumpable() and
					ls.expand_or_jump() or fallback()
			end,
			c = function(fallback) -- CmdlineMode
				if cmp.visible() then
					cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
				else
          fallback()
				end
			end,
		},
		["<S-Tab>"] = cmp.mapping {
      i = function(fallback) -- InsertMode
				return ls.expand_or_jumpable() and
					ls.expand_or_jump() or fallback()
			end,
			s = function(fallback) -- SelectMode
				return ls.expand_or_jumpable() and
					ls.expand_or_jump() or fallback()
			end,
			c = function() -- CmdlineMode
				if cmp.visible() then
					cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
				else
					cmp.complete { reason = cmp.ContexReason, config = cmp.ConfigSchema }
				end
			end,
    },

    ["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i" }),

		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i" }),
	},

	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", icons_kind[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = icons.lsp.nvim_lsp,
				nvim_lua = icons.lsp.nvim_lua,
				luasnip = icons.lsp.luasnip,
				buffer = icons.lsp.buffer,
				path = icons.lsp.path,
				treesitter = icons.lsp.treesitter,
				calc = icons.lsp.calc,
				latex_symbols = icons.lsp.latex_symbols,
				emoji = icons.lsp.emoji,
        dap = "",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp", priority = 9 },
		{ name = "luasnip", priority = 9 },
		{ name = "buffer", option = { keyword_length = 3, keyword_pattern = [[\k\+]] }, priority = 8 },
		{ name = "treesitter", priority = 6 },
		{ name = "path", option = { trailing_slash = true } },
		{ name = "nvim_lsp_signature_help" },
		{ name = "latex_symbols", keyword_length = 2, priority = 2 },
		{ name = "calc" },
    { name = "dap" },
    { name = "orgmode" },
		-- { name = "digraphs" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
    },
	},
	experimental = {
		ghost_text = {
			enable = true,
			hl_group = "Comment",
		},
	},
}

--[[ cmp.event:on( ]]
--[[   'confirm_done', ]]
--[[   require("nvim-autopairs.completion.cmp").on_confirm_done() ]]
--[[ ) ]]

-- Completion for command mode
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "cmdline", priority = 10 },
		{ name = "path", priority = 5 },
	},
})

-- Completion for / search based on current buffer
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		name = "nvim_lsp_document_symbol",
	}, {
		{ name = "treesitter", priority = 5 },
	}),
})

-- per-filetype window config
cmp.setup.filetype("help", {
	window = {
		documentation = cmp.config.disable,
	},
})

