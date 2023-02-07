--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file for manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 07 Feb 2023, 18:49
--------------------------------------

local M = {}

M.setup = function()
  local icons = require "util.icons"

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
      prefix = icons.lsp.nvim_lsp .. " ",
    },
  }

  vim.diagnostic.open_float = (function(orig)
    return function(bufnr, opts)
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      local options = opts or {}
      local diagnostics = vim.diagnostic.get(options.bufnr or 0, { lnum = lnum })
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
        { "🭽", border_color },
        { "▔", border_color },
        { "🭾", border_color },
        { "▕", border_color },
        { "🭿", border_color },
        { "▁", border_color },
        { "🭼", border_color },
        { "▏", border_color },
      }
      orig(bufnr, options)
    end
  end)(vim.diagnostic.open_float)

  -- INFO: disabled for now! Using noice
  --
  -- Vim LSP hover
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = "rounded",
  -- })
  --
  -- Vim LSP signatureHelp
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = "rounded",
  -- })

  vim.lsp.handlers["textDocument/codeLens"] = vim.lsp.with(vim.lsp.handlers.codeLens, {
    dynamicRegistration = true
  })

  -- Jump directly to the first available definition every time.
  -- vim.lsp.handlers["textDocument/definition"] = function(_, result)
  --   if not result or vim.tbl_isempty(result) then
  --     vim.notify("[LSP] Could not find definition", "Info")
  --     return
  --   elseif vim.tbl_islist(result) then
  --     vim.lsp.util.jump_to_location(result[1], "utf-8")
  --   else
  --     vim.lsp.util.jump_to_location(result, "utf-8")
  --   end
  -- end


  vim.lsp.handlers["workspace/workspaceFolders"] = vim.lsp.with(vim.lsp.handlers.workspaceFolders, {
    library = {
      [vim.fn.expand('$VIMRUNTIME/lua')] = true,
      [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
    },
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
    signs = {
      severity_limit = "Error",
    },
    underline = {
      severity_limit = "Warning",
    },
    virtual_text = true,
  })

  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    vim.lsp.handlers["textDocument/references"], {
      -- Use location list instead of quickfix list
      loclist = true,
    }
  )

end

M.implementation = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    -- do not shiow mocks for impls in golang
    if ft == "go" then
      local new_result = vim.tbl_filter(function(v)
        return not string.find(v.uri, "mock_")
      end, result)

      if #new_result > 0 then
        result = new_result
      end
    end

    vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
    vim.cmd [[normal! zz]]
  end)
end

vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
  require "util.functions".toggle_format_on_save()
end, {})

M.code_action_listener = function()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err)
    if err ~= nil then vim.notify("Code Action Listener: " .. err, "Error") end
  end)
end

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  callback = function()
    M.code_action_listener()
  end,
})

return M
