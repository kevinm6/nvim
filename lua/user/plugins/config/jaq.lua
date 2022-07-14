-------------------------------------
--  File         : jaq.lua
--  Description  : jaq plugin conf
--  Author       : Kevin
--  Last Modified: 12 Jul 2022, 16:56
-------------------------------------

local ok, jaq = pcall(require, "jaq-nvim")
if not ok then return end

jaq.setup {
	-- Commands used with 'Jaq'
	cmds = {
		-- Default UI used (see `Usage` for options)
		default = "float",

		-- Uses external commands such as 'g++' and 'cargo'
		external = {
			cpp = "g++ % -o $fileBase && ./$fileBase",
			c = "gcc % -o $fileBase && ./$fileBase",
			go = "go run %",
			sh = "sh %",
			markdown = "glow %",
			python = "python3 %",
			typescript = "deno run %",
			javascript = "node %",
			rust = "rustc % && ./$fileBase && rm $fileBase",
		},

		-- Uses internal commands such as 'source' and 'luafile'
		internal = {
			lua = "luafile %",
			vim = "source %"
		}
	},

	-- UI settings
	ui = {
		-- Start in insert mode
		startinsert = false,

		-- Switch back to current file
		-- after using Jaq
		wincmd      = false,

    -- Auto-save the current file
    -- before executing it
    autosave    = true,

		-- Floating Window / FTerm settings
		float = {
			-- Floating window border (see ':h nvim_open_win')
			border    = "rounded",

			-- Num from `0 - 1` for measurements
			height    = 0.8,
			width     = 0.8,
			x         = 0.5,
			y         = 0.5,

			-- Highlight group for floating window/border (see ':h winhl')
			border_hl = "FloatBorder",
			float_hl  = "Normal",

			-- Floating Window Transparency (see ':h winblend')
			blend     = 6
		},

		terminal = {
			-- Position of terminal
			position = "bot",

			-- Open the terminal without line numbers
			line_no = false,

			-- Size of terminal
			size     = 10
		},

		toggleterm = {
			-- Position of terminal, one of "vertical" | "horizontal" | "window" | "float"
			position = "horizontal",

			-- Size of terminal
			size     = 10
		},

		quickfix = {
			-- Position of quickfix window
			position = "bot",

			-- Size of quickfix window
			size     = 10
		}
	}
}

