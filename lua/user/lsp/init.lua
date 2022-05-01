-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 01/05/2022 - 14:40
-------------------------------------

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local lspconfig_util = require "lspconfig.util"

require("user.lsp.lsp-signature")
require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()
require("user.lsp.codelens")


local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    local illuminate_ok, illuminate = pcall(require, "illuminate")
    if not illuminate_ok then return end
    illuminate.on_attach(client)
  end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.keymap.set("n", "<leader>ll", "<cmd>lua require('user.lsp.codelens').run<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.keymap.set("n", "gq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.api.nvim_buf_create_user_command(
    0, "Format",
    function()
      vim.lsp.buf.formatting()
    end, { force = true }
  )
end

local filetype_attach = setmetatable({
  go = function(client)
    local lspbufformat = vim.api.nvim_create_augroup("lsp_buf_format", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lspbufformat,
      buflocal = true,
      callback = function()
        vim.lsp.buf.formatting_sync()
      end
    })
  end,
  java = function(client)
    if client.name == "jdt.ls" then
      client.resolved_capabilities.document_formatting = false

      require("jdtls").setup_dap { hotcodereplace = "auto" }
      require("jdtls.dap").setup_dap_main_class_configs()
      vim.lsp.codelens.refresh()
    end
  end
}, {
  __index = function()
    return function() end
  end,
})


local custom_attach = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  filetype_attach[filetype](client)

  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end


local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

local servers = {
  sumneko_lua = require("user.lsp.settings.sumneko_lua"),
  pyright = require("user.lsp.settings.pyright"),
  jsonls = require("user.lsp.settings.jsonls"),
  emmet_ls = require("user.lsp.settings.emmet_ls"),
  ltex = require("user.lsp.settings.ltex"),
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

  gopls = {
    root_dir = function(fname)
      local Path = require("plenary.path")

      local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
      local absolute_fname = Path:new(fname):absolute()

      if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
        return absolute_cwd
      end

      return lspconfig_util.root_pattern("go.mod", ".git")(fname)
    end,

    settings = {
      gopls = {
        codelenses = { test = true },
      },
    },

    flags = {
      debounce_text_changes = 200,
    },
  }
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

-- Set up null-ls
local use_null = false
if use_null then
  require("user.lsp.null-ls")
end

return {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}
