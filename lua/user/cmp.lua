-------------------------------------
-- File         : cmp.lua
-- Description  : Lua K NeoVim & VimR cmp config
-- Author       : Kevin
-- Last Modified: 25/05/2022 - 09:08
-------------------------------------

local cmp_ok, cmp = pcall(require, "cmp")
local luasnip_ok, luasnip = pcall(require, "luasnip")
local cmd_dap_ok, cmp_dap = pcall(require, "cmp_dap")

if (not cmp_ok) or
  (not luasnip_ok) or
  (not cmd_dap_ok) then return end

local icons = require "user.icons"
local icons_kind = icons.kind

-- Sources for snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Luasnip Configuration
luasnip.config.set_config {
	history = true,
	updateevents = "TextChanged, TextChangedI",
	delete_check_events = "TextChanged",
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


-- Cmp Configuration
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or cmp_dap.is_dap_buffer()
  end,

	mapping = cmp.mapping.preset.insert {
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),

		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),

		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    ['<C-l>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.complete_common_string()
      end
      fallback()
    end, { 'i', 'c' }),

		["<C-e>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},

		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
    ["<M-CR>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),

		["<Tab>"] = cmp.mapping {
			i = function(fallback) -- InsertMode
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					return luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
					fallback()
				end
			end,
			s = function(fallback) -- SelectMode
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
				else
					fallback()
				end
			end,
			c = function() -- CmdlineMode
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				elseif has_words_before() then
					cmp.complete()
				end
			end,
		},

		["<S-Tab>"] = cmp.mapping {
			i = function(fallback) -- InsertMode
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.expand_or_locally_jumpable() then
					return luasnip.expand_or_jump() or fallback()
				else
					fallback()
				end
			end,
			s = function(fallback) -- SelectMode
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end,
			c = function() -- CmdlineMode
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete({ reason = cmp.ContexReason, config = cmp.ConfigSchema })
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
		{ name = "emoji", keyword_length = 3, option = { keyword_length = 2 }, priority = 1 },
    { name = "dap" },
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
cmp.setup.filetype({ "markdown", "help" }, {
	window = {
		documentation = cmp.config.disable,
	},
})

-- cmp_zsh
require("cmp_zsh").setup {
	zshrc = true, -- Source the zshrc (adding all custom completions). default: false
	filetypes = { "zsh" }, -- Filetypes to enable cmp_zsh source. default: {"*"}
}
