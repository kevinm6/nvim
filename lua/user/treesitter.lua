-------------------------------------
-- File: treesitter.lua
-- Description: TreeSitter config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/treesitter.lua
-- Last Modified: 02/03/2022 - 09:19
-------------------------------------


local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "beancount", "bibtex", "c_sharp", "clojure", "cmake", "commonlisp", "cuda", "d", "dart", "eex", "elixir", "elm", "erlang", "fennel", "foam", "fortran", "fusion", "gdscript", "glimmer", "glsl", "gomod", "gowork", "haskell", "hcl", "heex", "hocon", "ledger", "ninja", "norg", "ocaml", "ocaml_interface", "ocamllex", "pioasm", "prisma", "pug", "r", "rasi", "rst", "scala", "sparql", "supercollider", "surface", "svelte", "teal", "tlaplus", "toml", "tsx", "turtle", "verilog", "yang", "zig"
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "css", "python", "yaml" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = true,
	},
	autotag = {
		enable = true,
		disable = { "xml" },
	},
	rainbow = {
		enable = true,
		colors = {
			"Gold",
			"Orchid",
			"DodgerBlue",
			-- "LawnGreen",
			-- "Cornsilk",
			-- "Salmon",
		},
		disable = { "html" },
	},
	playground = {
		enable = true,
	},
})

