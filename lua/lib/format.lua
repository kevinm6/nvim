-------------------------------------
-- File         : format.lua
-- Description  : format functions
-- Author       : Kevin
-- Last Modified: 17 Mar 2024, 13:17
-------------------------------------

local M = {}

---Use null-ls for lsp-formatting
M.lsp_format = function(bufnr)
   vim.lsp.buf.format {
      bufnr = bufnr,
      formatting_options = {
         -- tabSize = 3,
         insertSpaces = true,
         trimTrailingWhitespaces = false,
         insertFinalNewline = true,
         trimFinalNewline = false,
      },
      filter = function(client)
         return client.name ~= "null-ls"
      end,
   }
end

---Format on save
M.format_on_save = function(enable)
   local action = enable and "  ON" or "  OFF"
   local log_level = enable and "INFO" or "WARN"

   if enable then
      local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
         pattern = "*",
         callback = function(ev)
            M.lsp_format(ev.buf)
         end,
      })
      vim.g.format_on_save = autocmd_id
   else
      vim.api.nvim_del_autocmd(vim.g.format_on_save)
      vim.g.format_on_save = nil
   end

   vim.notify(
      action,
      vim.log.levels[log_level],
      {
         render = "wrapped-compact",
         title = "Auto Format LSP"
      }
   )
end

M.toggle_format_on_save = function()
   if vim.g.format_on_save then
      M.format_on_save()
   else
      M.format_on_save(true)
   end
end

return M