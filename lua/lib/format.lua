-------------------------------------
-- File         : format.lua
-- Description  : format functions
-- Author       : Kevin
-- Last Modified: 24 Mar 2024, 13:38
-------------------------------------

local format = {}

---Use null-ls for lsp-formatting
function format.lsp_format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    formatting_options = {
      -- tabSize = 3,
      insertSpaces = true,
      trimTrailingWhitespaces = true,
      insertFinalNewline = false,
      trimFinalNewline = false,
    },
    async = true,
    filter = function(client)
      return client.name ~= "null-ls"
    end,
  }
end

---Format on save
function format.format_on_save(enable)
  local action = enable and "  ON" or "  OFF"
  local log_level = enable and "INFO" or "WARN"

  if enable then
    local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = "*",
      callback = function(ev)
        format.lsp_format(ev.buf)
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

function format.toggle_format_on_save()
  if vim.g.format_on_save then
    format.format_on_save()
  else
    format.format_on_save(true)
  end
end

return format