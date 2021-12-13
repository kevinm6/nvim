-------------------------------------
-- File: treesitter.lua
-- Description: Lua K NeoVim & VimR treesitter config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/treesitter.lua
-- Last Modified: 13/12/21 - 13:50
-------------------------------------



-- NVIM-TREESITTER {
	require'nvim-treesitter.configs'.setup {
		ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
		-- ignore_install = { "javascript" }, -- List of parsers to ignore installing
		highlight = {
			enable = true,              -- false will disable the whole extension
			indent = { enable = true, disable = { "python" } },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			autotag = {
				enable = true,
				disable = { "xml" },
			},
			ignore_install = { "beancount", "bibtex", "c_sharp", "clojure", "cmake", "comment", "commonlisp", "cuda", "d", "dart", "devicetree", "dockerfile", "dot", "elixir", "elm", "erlang", "fennel", "fish", "fortran", "fusion", "gdscript", "glimmer", "glsl", "godot_resource", "gomod", "graphql", "haskell", "hcl", "heex", "hjson", "javascript", "jsdoc", "julia", "kotlin", "ledger", "llvm", "nix", "ocaml", "ocaml_interface", "ocamllex", "pioasm", "prisma", "pug", "ql", "r", "regex", "rst", "rust", "scala", "scss", "sparql", "supercollider", "surface", "svelte", "teal", "tlaplus", "toml", "tsx", "turtle", "typescript", "verilog", "vue", "yaml", "yang", "zig" },
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
	}

