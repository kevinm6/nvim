-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration
-- Author       : Kevin
-- Last Modified: 12/03/2022 - 18:30
-------------------------------------

vim.opt.makeprg = "gcc % -o %<"


local which_key_ok, which_key = pcall(require, "which-key")
if not which_key_ok then
	return
end

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	F = {
		name = "Filetype [ C ]",
    c = {
      "<cmd>cd %:p:h<CR> <cmd>update<CR> <cmd>r!gcc % -o %< <CR> <cmd>NvimTreeRefresh<CR>",
      "Save & Compile"
    },
    r = { "<cmd>cd %:p:h<CR> :call Scratch() <bar> :r!./#< <CR>", "Run program" },
    C = {
      "<cmd>cd %:p:h<CR> <cmd>update<CR> <cmd>!gcc % -o %< <CR> <cmd>NvimTreeRefresh<CR> :call Scratch() <bar> :r!./#< <CR>",
      "Compile & Run"
    },
	},
}

which_key.register(mappings, opts)
