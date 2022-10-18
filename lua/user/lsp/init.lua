-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 18 Oct 2022, 09:43
-------------------------------------


local has_lspconf, lspconfig = pcall(require, "lspconfig")
if not has_lspconf then vim.notify(" Error: LSPconfig", "Error") return end

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
local function lsp_keymaps()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
  -- HACK:
  --     Move for now this keymap cause with nvim0.8 is 
  --     override for go-to manual (is now in /after/plugin/keymaps)
  --     vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.api.nvim_buf_create_user_command(0, "Format", function()
    vim.lsp.buf.formatting()
  end, { force = true })
end


-- Custom configs to apply when starting lsp
local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end



-- Custom configs to apply when attaching lsp to buffer
local custom_attach = function(client, bufnr)
  -- Update capabilities with extended
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  lsp_keymaps()
  lsp_highlight_document(client)

  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok then
    navic.attach(client, bufnr)
  else
    vim.notify("Error attaching navic to LSP: "..navic, "Error", { title = "LSP" })
  end

  require("user.lsp.handlers").setup()
  require("user.lsp.codelens").run()
  capabilities.textDocument.codeLens = { dynamicRegistration = true }
end


-- LSP: Servers Configuration w/ Mason
-- local setup_server = function(server, config)
--   if not config then
--     vim.notify(
--       " No configuration passed to server < "..server.." >",
--       "Warn",
--       { title = "LSP: Servers Configuration" }
--     )
--   end

--   if type(config) ~= "table" then config = {} end
-- end

local global_lsp_config = {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = capabilities,
  flags = { debounce_text_changes = nil }
}

-- Manage handlers w/ Mason-lspconfig
require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function (server_name)
    if server_name == "jdtls" or server_name == "jdt.ls" and
      vim.bo.filetype == "java" then
      global_lsp_config['on_attach'] = function ()
        require 'jdtls'.setup_dap { hotcodereplace = "auto" }
        require("jdtls.dap").setup_dap_main_class_configs()
        require("jdtls.setup").add_commands()
      end
      return global_lsp_config
    end
    lspconfig[server_name].setup(global_lsp_config)  -- default handler (optional)
  end,

  -- Next, you can provide targeted overrides for specific servers.
  -- Manage server with custom setup
  ["sumneko_lua"] = function() lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.sumneko_lua")) end,
  ["jsonls"] = function() lspconfig.jsonls.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.jsonls")) end,
  ["sqls"] = function() lspconfig.sqls.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.sqls")) end,
  ["grammarly"] = function() lspconfig.grammarly.setup(vim.tbl_deep_extend("force", global_lsp_config, { autostart = false })) end,
  ["ltex"] = function() lspconfig.ltex.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.ltex")) end,
  ["clangd"] = function() lspconfig.clangd.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.clangd")) end,
  ["gopls"] = function() lspconfig.gopls.setup(vim.tbl_deep_extend("force", global_lsp_config, require "user.lsp.configs.gopls")) end,
}


return global_lsp_config
