---------------------------------------
--  File         : codelens.lua
--  Description  : lsp codelens config
--  Author       : Kevin
--  Last Modified: 06 May 2023, 17:01
---------------------------------------

local M = {}

M.setup_codelens_refresh = function(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method("textDocument/codeLens")
    end)
    if not status_ok or not codelens_supported then
        return
    end
    local group = "lsp_code_lens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })
    if ok and #cl_autocmds > 0 then
        return
    end
    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

vim.diagnostic.config({
   on_init_callback = function(_)
         M.setup_codelens_refresh(_)
     end,
})

return M
