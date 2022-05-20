--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file, to manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 18/05/2022 - 09:50
--------------------------------------

local M = {}

M.setup = function()
	local icons = require "user.icons"

  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
	}

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- Vim LSP Diagnostic
  vim.diagnostic.config {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = icons.lsp.nvim_lsp.." ",
    },
  }

  vim.diagnostic.open_float = (function(orig)
    return function(bufnr, opts)
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
        local options = opts or {}
        local diagnostics = vim.diagnostic.get(options.bufnr or 0, {lnum = lnum})
        local max_severity = vim.diagnostic.severity.HINT
        for _, d in ipairs(diagnostics) do
          if d.severity < max_severity then
              max_severity = d.severity
          end
        end
        local border_color = ({
          [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
          [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
          [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
          [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        })[max_severity]
        options.border = {
          {"🭽", border_color},
          {"▔", border_color},
          {"🭾", border_color},
          {"▕", border_color},
          {"🭿", border_color},
          {"▁", border_color},
          {"🭼", border_color},
          {"▏", border_color},
        }
        orig(bufnr, options)
    end
  end)(vim.diagnostic.open_float)

  -- Vim LSP hover
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  -- Vim LSP signatureHelp
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/codeLens"] = vim.lsp.with(vim.lsp.handlers.codeLens, {
    dynamicRegistration = false
  })

end

function M.enable_format_on_save()
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("_format_on_save", { clear = true }),
    pattern = "*",
    callback = function()
      vim.lsp.buf.formatting()
    end,
  })
  vim.notify(" Enabled format on save", "Info", { title = "LSP" })
end

function M.disable_format_on_save()
  vim.api.nvim_clear_autocmds { group = "_format_on_save" }
  vim.notify(" Disabled format on save", "Info", { title = "LSP" })
end

function M.toggle_format_on_save()
  if vim.fn.exists "#_format_on_save#BufWritePre" == 0 then
    M.enable_format_on_save()
  else
      M.disable_format_on_save()
  end
end

vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
  require("user.lsp.handlers").toggle_format_on_save()
end, {})

function M.code_action_listener()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  -- vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, _, result)
  --   if re ~= "" then
  --     print(err)
  --   end
  -- end)
end


vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    require("user.lsp.handlers").code_action_listener()
  end,
})

return M
