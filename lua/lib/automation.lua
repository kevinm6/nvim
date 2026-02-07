-------------------------------------
-- title: automation.lua
-- abstract: automatic functions lib triggered by events
-- author: Kevin
-- date: 07 Feb 2026, 17:23
-------------------------------------

local M = {}

---If buffer modified, update any 'date' in the first 6 lines
---Restores cursor and window position using save_cursor variable.
---@param exts? string|table pattern or list of extension pattern to match with
function M.auto_timestamp(exts)
  exts = exts or { "*.lua", "*.md", "*.yml", "*.conf", "*.config", "*.zsh", "*.sh" }
  local group_id = vim.api.nvim_create_augroup("_autoupdate_timestamp", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group_id,
    pattern = exts,
    callback = function()
      if vim.opt_local.modified:get() == true then
        -- ensures the timestamp update is undone along with the actual edit
        vim.cmd.undojoin()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local lines = vim.api.nvim_buf_line_count(0)
        local max_range = math.min(lines, 6)
        if max_range > 0 then
          local range = "0," .. max_range
          -- 1. "Last Modified: ..." (your original)
          -- 2. "date: ..." (standard YAML)
          -- 3. "modified: ..." (alternative YAML)
          local pattern = [[\v<(\s*%(Last [Mm]odified|date|modified):\s*).*]]
          local replacement = [[\=submatch(1) . strftime('%d %b %Y, %H:%M')]]
          vim.api.nvim_command(('keepjumps silent %s s/%s/%s/e'):format(range, pattern, replacement))
        end
        vim.fn.histdel("search", -1)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
    end,
  })
  vim.g.autoupdate_timestamp = group_id
end

---Auto Remove trailing spaces before saving current buffer
function M.auto_remove_trailing_spaces()
  local group_id = vim.api.nvim_create_augroup("_autoremove_trailing_space", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group_id,
    pattern = "*",
    callback = function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd [[%s/\s\+$//e]]
      end
    end,
  })
  vim.g.autoremove_trailingspace = group_id
end

return M