local M = {}

---Process base64 encode/decode
---@param encode true | false
---@param range table | nil -- table with line1,line2 or nil if no range
function M.process_base64(encode, range)
  local bufnr = 0
  local line1, line2, col_start, col_end

  -- Try to get visual marks (if text was selected)
  local mark_start = vim.api.nvim_buf_get_mark(bufnr, "<")
  local mark_end = vim.api.nvim_buf_get_mark(bufnr, ">")
  local visual_selected = mark_start[1] > 0 and mark_end[1] > 0

  if visual_selected then
    -- Visual selection (including partial line)
    line1, col_start = mark_start[1] - 1, mark_start[2]
    line2, col_end = mark_end[1] - 1, mark_end[2] + 1

    -- Normalize backwards selections
    if line1 > line2 or (line1 == line2 and col_start > col_end) then
      line1, line2 = line2, line1
      col_start, col_end = col_end, col_start
    end
  elseif range and range.line1 ~= nil and range.range > 0 then
    -- Range provided (like :3,5Command)
    line1 = range.line1 - 1
    line2 = range.line2 - 1
    col_start = 0
    local last_line = vim.api.nvim_buf_get_lines(bufnr, line2, line2 + 1, false)[1]
    col_end = last_line and #last_line or 0
  else
    -- No selection or range → use current line
    line1 = vim.api.nvim_win_get_cursor(0)[1] - 1
    line2 = line1
    local line = vim.api.nvim_buf_get_lines(bufnr, line1, line1 + 1, false)[1]
    col_start = 0
    col_end = line and #line or 0
  end

  -- Get selected text
  local text = vim.api.nvim_buf_get_text(bufnr, line1, col_start, line2, col_end, {})
  local string_text = table.concat(text)

  -- Encode or Decode, perform base64 operation
  local result
  assert(encode ~= nil, "Encode boolean must be passed")
  if encode then
    local ok, encoded = pcall(vim.base64.encode, string_text)
    if not ok then
      vim.notify("Base64 - encode failed => " .. encoded, vim.log.levels.ERROR)
      return
    end
    result = encoded
  else
    local ok, decoded = pcall(vim.base64.decode, string_text)
    if not ok then
      vim.notify("Base64 - decode failed => " .. decoded, vim.log.levels.ERROR)
      return
    end
    result = decoded
  end

  -- Replace original text
  if result then
    local replacement = vim.split(result, "\n", { plain = true })
    vim.api.nvim_buf_set_text(bufnr, line1, col_start, line2, col_end, replacement)
  end
end

return M