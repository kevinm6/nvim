--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file, to manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 01/05/2022 - 12:28
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

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

function M.enable_format_on_save()
  local _format_on_save = vim.api.nvim_create_augroup("_format_on_save", {
    clear = true,
  })

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = _format_on_save,
    pattern = "*",
    command = "lua vim.lsp.buf.formatting()",
  })
  vim.notify "Enabled format on save"
end

function M.disable_format_on_save()
  vim.api.nvim_clear_autocmds({ group = "_format_on_save" })
  vim.notify "Disabled format on save"
end

function M.toggle_format_on_save()
  if vim.fn.exists("#_format_on_save#BufWritePre") == 0 then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("user.lsp.handlers").toggle_format_on_save()' ]]

local lsp_util = vim.lsp.util

function M.code_action_listener()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = lsp_util.make_range_params()
  params.context = context
  -- vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, _, result)
  --   if re ~= "" then
  --     print(err)
  --   end
  -- end)
end


vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "lua require('user.lsp.handlers').code_action_listener()",
})

return M
