--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file for manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 17 Mar 2024, 16:09
--------------------------------------

local M = {}

-- Code Lens
local function codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method("textDocument/codeLens")
  end)
  if not status_ok or not codelens_supported then return end

  vim.lsp.handlers["textDocument/codeLens"] = vim.lsp.with(vim.lsp.handlers.codeLens, {
    dynamicRegistration = true
  })

  local group = "lsp_code_lens_refresh"
  local cl_events = { "BufEnter", "CursorHold", "InsertLeave" }
  local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = cl_events,
  })
  if ok and #cl_autocmds > 0 then
    return
  end
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(cl_events, {
    group = group,
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end
  })
end

-- Code Action
local function code_action_listener()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err)
    if err ~= nil then
      vim.notify(string.format("Code Action Listener: %s", err),
        vim.log.levels.ERROR)
    end
  end)
end



M.setup = function(client, bufnr)
  local icons = require "lib.icons"

  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- Vim LSP Diagnostic
  local default_diagnostic_config = {
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    -- severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      title = "LSP • Diagnostic",
      prefix = icons.lsp.nvim_lsp .. " ",
      winblend = 8
    },
    on_init_callback = function(_, _)
      codelens_refresh(client, bufnr)
    end,
  }
  vim.diagnostic.config(default_diagnostic_config)


  vim.lsp.handlers["workspace/workspaceFolders"] = vim.lsp.with(
    vim.lsp.handlers.workspaceFolders, {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    })

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"],
    default_diagnostic_config)

  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    vim.lsp.handlers["textDocument/references"], {
      -- Use location list instead of quickfix list
      loclist = true,
    }
  )

  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = "*",
    callback = function()
      code_action_listener()
    end,
  })
end


return M