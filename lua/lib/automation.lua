-------------------------------------
--  File         : automation.lua
--  Description  : automatic functions lib triggered by events
--  Author       : Kevin
--  Last Modified: 05 Feb 2026, 11:51
-------------------------------------

local M = {}

---If buffer modified, update any 'Last modified: ' in the first 10 lines.
---Restores cursor and window position using save_cursor variable.
---@param exts? string|table pattern or list of extension pattern to match with
function M.auto_timestamp(exts)
  exts = exts or { "*.lua", "*.md", "*.yml", "*.conf", "*.config", "*.zsh", "*.sh" }
  local _autoupdate_tmsp = vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("_autoupdate_timestamp", { clear = true }),
    pattern = exts,
    callback = function()
      if vim.opt_local.modified:get() == true then
        -- undojoin ensures the timestamp update is undone along with the actual edit
        vim.cmd.undojoin()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local lines = vim.api.nvim_buf_line_count(0)
        local max_range = math.min(lines, 10)
        if max_range > 0 then
          local range = "0," .. max_range
          -- 1. "Last Modified: ..." (your original)
          -- 2. "date: ..." (standard YAML)
          -- 3. "modified: ..." (alternative YAML)
          local pattern = [[\v^(\s*%(Last [Mm]odified|date|modified):\s*).*]]
          local replacement = [[\=submatch(1) . strftime('%d %b %Y, %H:%M')]]
          vim.api.nvim_command(('keepjumps silent %s s/%s/%s/e'):format(range, pattern, replacement))
        end
        vim.fn.histdel("search", -1)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
    end,
  })
  vim.g.autoupdate_timestamp = _autoupdate_tmsp
end

---Auto Remove trailing spaces before saving current buffer
function M.auto_remove_trailing_spaces()
  local _autorm_tlsp = vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("_autoremove_trailing_space", { clear = true }),
    pattern = "*",
    callback = function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd [[%s/\s\+$//e]]
      end
    end,
  })
  vim.g.autoremove_trailingspace = _autorm_tlsp
end

return M