-------------------------------------
--  File         : lsp.lua
--  Description  : lsp utility functions
--  Author       : Kevin
--  Last Modified: 26 Apr 2024, 20:22
-------------------------------------

local lsp = {}

---Get current buf lsp Capabilities
---@see nvim_lsp_get_active_clients |nvim_lsp_get_active_clients()|
function lsp.get_current_buf_lsp_capabilities(client, _)
  local capAsList = {}
  for key, value in pairs(client.server_capabilities) do
    if value and key:find "Provider" then
      local capability = key:gsub("Provider$", "")
      table.insert(capAsList, "- " .. capability)
    end
  end
  table.sort(capAsList) -- sorts alphabetically
  local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
  vim.notify(msg, vim.log.levels.INFO, {
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
    end,
    timeout = 14000,
  })
  vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
end

---Enable|Disable Diagnostics
---@param buf number int id of buffer
function lsp.toggle_diagnostics(buf)
  vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = buf }, { bufnr = buf })
end

return lsp
