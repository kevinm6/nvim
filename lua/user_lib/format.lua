-------------------------------------
--  File         : format.lua
--  Description  : format functions
--  Author       : Kevin
--  Last Modified: 23 Jun 2023, 09:18
-------------------------------------

local F = {}

-- Use null-ls for lsp-formatting
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
         return client.name == "null-ls"
      end,
   }
end

-- Format on save
F.format_on_save = function(enable)
   local action = enable and "Enabled" or "Disabled"

   if enable then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
         group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
         pattern = "*",
         callback = function(ev)
            F.lsp_format(ev.buf)
         end,
      })
   else
      vim.api.nvim_clear_autocmds { group = "format_on_save" }
   end

   vim.notify(
      action .. " format on save",
      vim.log.levels.INFO,
      { title = "LSP - Format" }
   )
end

F.toggle_format_on_save = function()
   if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
      F.format_on_save(true)
   else
      F.format_on_save()
   end
end

return F
