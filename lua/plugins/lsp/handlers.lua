--------------------------------------
-- File         : handlers.lua
-- Description  : Lsp handlers file for manage various lsp behaviours config
-- Author       : Kevin
-- Last Modified: 03 Dec 2023, 10:48
--------------------------------------

local M = {}

M.setup = function()
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
   vim.diagnostic.config(default_diagnostic_config)

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
   --    border = "rounded",
   --    border_color = "FloatBorder"
   -- })
   --
   -- Vim LSP signatureHelp
   -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   --   border = "rounded",
   -- })

   vim.lsp.handlers["textDocument/codeLens"] = vim.lsp.with(vim.lsp.handlers.codeLens, {
      dynamicRegistration = true
   })

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
end

M.implementation = function()
   local params = vim.lsp.util.make_position_params()

   vim.lsp.buf_request(0, "textDocument/implementation", params,
      function(err, result, ctx, config)
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

local function code_action_listener()
   local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
   local params = vim.lsp.util.make_range_params()
   params.context = context
   vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err)
      if err ~= nil then vim.notify(string.format("Code Action Listener: %s", err),
            vim.log.levels.ERROR) end
   end)
end

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
   pattern = "*",
   callback = function()
      code_action_listener()
   end,
})

return M