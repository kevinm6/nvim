--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file for manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 11 May 2024, 22:00
--------------------------------------

return {
  setup = function()
    local icon_err, icon_warn, icon_info, icon_hint = "", "", "", "󱧢"

    local signs = {
      {
        name = "DiagnosticSignError",
        text = icon_err,
        numhl = "ErrorMsg",
      },
      {
        name = "DiagnosticSignWarn",
        text = icon_warn,
        numhl = "WarningMsg",
      },
      { name = "DiagnosticSignHint", text = icon_hint },
      { name = "DiagnosticSignInfo", text = icon_info },
    }

    for _, sign in pairs(signs) do
      vim.fn.sign_define(sign.name, {
        texthl = sign.name,
        text = sign.text,
        numhl = sign.numhl or nil,
      })
    end

    ---LSP•Diagnostic
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icon_err,
          [vim.diagnostic.severity.WARN] = icon_warn,
          [vim.diagnostic.severity.INFO] = icon_info,
          [vim.diagnostic.severity.HINT] = icon_hint,
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
      },
      virtual_text = false,
      underline = false,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        title = "LSP • Diagnostic",
        prefix = "",
        winblend = 8,
      },
    }
  end,
}
