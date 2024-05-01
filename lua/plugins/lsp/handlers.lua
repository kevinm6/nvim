--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file for manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 11 May 2024, 22:00
--------------------------------------

return {
  setup = function()
    local icons = require "lib.icons"

    local signs = {
      {
        name = "DiagnosticSignError",
        text = icons.diagnostics.Error,
        numhl = 'ErrorMsg'
      },
      {
        name = "DiagnosticSignWarn",
        text = icons.diagnostics.Warning,
        numhl = 'WarningMsg'
      },
      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
    }

    for _, sign in pairs(signs) do
      vim.fn.sign_define(sign.name, {
        texthl = sign.name,
        text = sign.text,
        numhl = sign.numhl or nil
      })
    end

    ---LSP•Diagnostic
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.WARN] = 'WarningMsg',
        }
      },
      virtual_text = false,
      underline = false,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        title = "LSP • Diagnostic",
        prefix = icons.lsp.nvim_lsp .. ' ',
        winblend = 8
      }
    }

    ---References
    vim.lsp.handlers['textDocument/references'] = vim.lsp.with(
      vim.lsp.handlers['textDocument/references'], {
        -- Use location list instead of quickfix list
        loclist = true,
      }
    )

    ---WorkspaceFolders
    vim.lsp.handlers['workspace/workspaceFolders'] = vim.lsp.with(
      vim.lsp.handlers['workspace/workspaceFolders'], {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    )
  end
}