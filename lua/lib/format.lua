-------------------------------------
-- File         : format.lua
-- Description  : format functions
-- Author       : Kevin
-- Last Modified: 14 Oct 2023, 09:15
-------------------------------------

local F = {}

---Use null-ls for lsp-formatting
F.lsp_format = function(bufnr)
   vim.lsp.buf.format {
      bufnr = bufnr,
      formatting_options = {
         tabSize = 3,
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
F.format_on_save = function(enable)
   local action = enable and "  ON" or "  OFF"
   local log_level = enable and "INFO" or "WARN"

   if enable then
      local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
         pattern = "*",
         callback = function(ev)
            F.lsp_format(ev.buf)
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

F.toggle_format_on_save = function()
   if vim.g.format_on_save then
      F.format_on_save()
   else
      F.format_on_save(true)
   end
end

return F
