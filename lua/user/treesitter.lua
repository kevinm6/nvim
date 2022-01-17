-------------------------------------
-- File: treesitter.lua
-- Description: TreeSitter config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/treesitter.lua
-- Last Modified: 17/01/2022 - 10:37
-------------------------------------


local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "beancount", "bibtex", "c_sharp", "clojure", "cmake", "comment", "commonlisp", "cuda", "d", "dart", "devicetree", "dockerfile", "dot", "elixir", "elm", "erlang", "fennel", "fish", "fortran", "fusion", "gdscript", "glimmer", "glsl", "godot_resource", "gomod", "graphql", "haskell", "hcl", "heex", "hjson", "javascript", "jsdoc", "julia", "kotlin", "ledger", "llvm", "nix", "ocaml", "ocaml_interface", "ocamllex", "pioasm", "prisma", "pug", "ql", "r", "regex", "rst", "rust", "scala", "scss", "sparql", "supercollider", "surface", "svelte", "teal", "tlaplus", "toml", "tsx", "turtle", "typescript", "verilog", "vue", "yaml", "yang", "zig", "hocon" },
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
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
			-- "Cornsilk",
			-- "Salmon",
			-- "LawnGreen",
		},
		disable = { "html" },
	},
	playground = {
		enable = true,
	},
})

