-------------------------------------
-- File: cmp.lua
-- Description: Lua K NeoVim & VimR cmp config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/cmp.lua
-- Last Modified: 28/03/2022 - 19:41
-------------------------------------

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then return end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then return end

local icons = require "user.icons"
local kind = icons.kind

-- Sources
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load { paths = { ("./lua/") } }

 -- Luasnip Configuration
luasnip.config.set_config {
	history = true,
	updateevents = "TextChanged, TextChangedI",
	delete_check_events = "TextChanged",
}


-- Cmp Configuration
cmp.setup {
	snippet = {
		expand = function(args)
			require'luasnip'.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),

		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),

		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

		["<C-e>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},

		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true
		},

		["<Tab>"] = cmp.mapping({
      i =	function(fallback) -- InsertMode
          if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      s =	function(fallback) -- SelectMode
          if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      c = function () -- CmdlineMode
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        else
          cmp.complete()
        end
      end
    }),

		["<S-Tab>"] = cmp.mapping({
      i =	function(fallback) -- InsertMode
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      s =	function(fallback) -- SelectMode
          if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      c = function () -- CmdlineMode
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        else
          cmp.complete()
        end
      end
    }),

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
      vim_item.kind = string.format(" %s ", kind[vim_item.kind])
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
      })[entry.source.name]
    return vim_item
	end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
    { name = "nvim_lua" },
		{ name = "buffer" },
    { name = "nvim_lsp_signature_help" },
    { name = "treesitter" },
		{ name = "path", option = { trailing_slash = true } },
		{ name = "cmdline" },
    { name = "zsh" },
    -- { name = "digraphs" },
    { name = "calc" },
    { name = "latex_symbols" },
    { name = "emoji", option = { length = 2 } },
    { name = "spell" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	-- documentation = false,
	documentation = {
    timeout = 800, delay = 800, -- figure out if this work to delay showing docs
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
	experimental = {
		ghost_text = true,
    native_menu = false,
	},
}

-- Completion for command mode
cmp.setup.cmdline(":", {
	sources = {
			{ name = "cmdline" }
  }
})

-- Completion for / search based on current buffer
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" }
	}
})

-- cmp_zsh
require("cmp_zsh").setup {
  zshrc = true, -- Source the zshrc (adding all custom completions). default: false
  filetypes = { "zsh" } -- Filetypes to enable cmp_zsh source. default: {"*"}
}
