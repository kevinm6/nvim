-------------------------------------
--  File         : automation.lua
--  Description  : automatic functions lib triggered by events
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 13:33
-------------------------------------

local automation = {}

---If buffer modified, update any 'Last modified: ' in the first 10 lines.
---Restores cursor and window position using save_cursor variable.
function automation.auto_timestamp()
  local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("_autoupdate_timestamp", { clear = true }),
    pattern = "*",
    callback = function()
      if vim.opt_local.modified:get() == true then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)

        vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
        vim.fn.histdel("search", -1)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
    end
  })
  vim.g.auto_timestamp = autocmd_id
end

---Auto Remove trailing spaces before saving current buffer
function automation.auto_remove_trailing_spaces()
  local autocmd_id = vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("_autoremove_trailing_space", { clear = true }),
    pattern = "*",
    callback = function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd [[%s/\s\+$//e]]
      end
    end
  })
  vim.g.auto_remove_trail_spaces = autocmd_id
end

return automation