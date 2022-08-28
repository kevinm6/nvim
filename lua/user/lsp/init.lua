-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 25 Aug 2022, 21:07
-------------------------------------

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local util = lspconfig.util

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Lsp highlights
local function lsp_highlight_document(client)
 if client.server_capabilities.documentHighlightProvider then
    local lsp_hi_doc_group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = lsp_hi_doc_group,
      pattern = "*",
      callback = function() vim.lsp.buf.document_highlight() end
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = lsp_hi_doc_group,
      pattern = "*",
      callback = function() vim.lsp.buf.clear_references() end
    })
  end
end

-- Create custom keymaps for useful lsp functions
-- The missing functions are most covered whith which-key mappings
-- the `hover()` -> covers even signature_help on functions/methods
local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
	vim.api.nvim_buf_create_user_command(0, "Format", function()
		vim.lsp.buf.formatting()
	end, { force = true })
end

-- Default lsp config for filetypes
local filetype_attach = setmetatable({
	go = function()
		local lspbufformat = vim.api.nvim_create_augroup("lsp_buf_format", { clear = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lspbufformat,
			callback = function()
				vim.lsp.buf.formatting_sync()
			end,
		})
	end,
	java = function(client)
		if client.name == "jdt.ls" then return end
  end,
}, {
	__index = function()
		return function() end
	end,
})

-- Custom configs to apply when starting lsp
local custom_init = function(client)
	client.config.flags = client.config.flags or {}
	client.config.flags.allow_incremental_sync = true
end

-- Custom configs to apply when attaching lsp to buffer
local custom_attach = function(client, bufnr)
  -- Update capabilities with extended
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  -- vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)

  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok then
    navic.attach(client, bufnr)
  else
    vim.notify("Error attaching navic to LSP: "..navic, "Error", { title = "LSP" })
  end

  require("user.lsp.handlers").setup()
  require("user.lsp.codelens").run()
  filetype_attach[filetype](client)
end



-- Manage server with custom setup
local servers = {
	sumneko_lua = require("user.lsp.configs.sumneko_lua"),
	pyright = require("user.lsp.configs.pyright"),
  emmet_ls = require("user.lsp.configs.emmet_ls"),
	jsonls = require("user.lsp.configs.jsonls"),
	ltex = require("user.lsp.configs.ltex"),
	sqls = require("user.lsp.configs.sqls"),
	asm_lsp = require("user.lsp.configs.asm_lsp"),
	vimls = require("user.lsp.configs.vimls"),
	bashls = {
		cmd = { "bash-language-server", "start" },
		cmd_env = {
			GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)",
		},
		filetypes = { "sh", "bash" },
		root_dir = util.find_git_ancestor,
		single_file_support = true,
	},
	grammarly = {
		filetypes = { "markdown", "txt", "text" },
		single_file_support = true,
		autostart = false,
		root_dir = util.find_git_ancestor,
	},
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
		-- Required for lsp-status
		init_options = {
			clangdFileStatus = true,
		},
	},
	intelephense = {
		cmd = { "intelephense", "--stdio" },
		filetypes = { "php" },
		root_dir = util.root_pattern("composer.json", ".git"),
	},
  sourcekit = {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift" },
    root_dir = util.root_pattern("Package.swift", ".git"),
  },
	gopls = {
		root_dir = function(fname)
			local Path = require("plenary.path")

			local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
			local absolute_fname = Path:new(fname):absolute()

			if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
				return absolute_cwd
			end

			return util.root_pattern("go.mod", ".git")(fname)
		end,
		settings = {
			gopls = {
				codelenses = { test = true },
			},
		},
		flags = {
			debounce_text_changes = 200,
		},
	},
}

-- LSP: Servers Configuration
local setup_server = function(server, config)
	if not config then
    vim.notify(
      " No configuration passed to server < "..server.." >",
      "Warn",
      { title = "LSP: Servers Configuration" }
    )
	end

	if type(config) ~= "table" then config = {} end

	config = vim.tbl_deep_extend("force", {
		on_init = custom_init,
		on_attach = custom_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = nil,
		},
	}, config)

	lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
	setup_server(server, config)
end


return {
	on_init = custom_init,
	on_attach = custom_attach,
	capabilities = capabilities,
}
