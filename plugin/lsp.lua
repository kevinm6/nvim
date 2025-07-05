-------------------------------------
-- File         : lsp.lua
-- Description  : lsp config nvim-0.11
-- Author       : Kevin
-- Last Modified: 05/07/2025, 09:20
-------------------------------------

local lsp = vim.lsp

---Create capabilities and set default values
---default and `cmp_nvim_lsp`
---@return table capabilities custom capabilities merged with default
local function init_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()

  -- Adding snippetSupport enabled by default for each LSP
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end


-- Custom configs to apply when starting lsp
--- @param client table client passed to attach config
local function custom_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
  client.config.flags.debounce_text_changes = 150
end

--- Custom configs to apply when attaching lsp to buffer
--- It setup handlers, keymaps and capabilities
--- @param client table client passed to attach config
--- @param bufnr integer buffer id passed to attach config
local function custom_attach(client, bufnr)
  require("lib.lsp").set_buf_keymaps(client, bufnr)
  require("lib.lsp").set_buf_funcs_for_capabilities(client, bufnr)
end

---Default Lsp Config
vim.lsp.config("*", {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = init_capabilities(),
})

lsp.config("bashls", {
  settings = {
    bashIde = {
      shellcheckArguments = {
        "-e",
        "SC2086", -- Double quote to prevent globbing and word splitting
        "-e",
        "SC2155", -- Declare and assign separately to avoid masking return values
      },
    },
  },
})

lsp.enable {
  "marksman",
  "gopls",
  "luals",
  "clangd",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "sqls",
  "ts_ls",
  "intelephense",
  "texlab",
  "sourcekit",
  "cssls",
  "gradle_ls",
  "lemminx",
  "html",
  "dockerls",
  "groovyls",
  -- "jdtls",
  -- "metals",
}