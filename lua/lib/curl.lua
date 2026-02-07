-----------------------------------
-- title: curl.lua
-- abstract: wrap of curl, to use with nvim
-- author: Kevin
-- date: 31 Dec 2025, 16:32
-----------------------------------

local M = {}

---Parse command and result from curl
---@param lines string[] result array
---@param verbose boolean? verbose mode
---@param debug boolean? debug mode
local function parse(lines, verbose, debug)
  local method, url, headers, body
  headers = {}
  body = ""

  -- Parse lines to extract HTTP request details
  for _, line in ipairs(lines) do
    if line:match("^%s*(%u+)%s+(http.+)$") then
      method, url = line:match("^%s*(%u+)%s+(http.+)$")
    elseif line:match("^%s*([%w-]+)%s*:%s*(.+)$") then
      local header, value = line:match("^%s*([%w-]+)%s*:%s*(.+)$")
      table.insert(headers, ('-H "%s: %s"'):format(header, value))
    else
      body = body .. line
    end
  end

  if not method or not url then
    print("Error: Invalid HTTP request block.")
    return
  end
  -- Construct curl command
  local curl_command = 'curl -X ' .. method .. ' "' .. url .. '"'
  if headers then
    curl_command = curl_command .. " " .. table.concat(headers, " ")
  end
  if body and body ~= "" then
    curl_command = curl_command .. ' -d "' .. body:gsub('"', '\\"') .. '"'
  end
  if verbose then
    curl_command = curl_command .. " -v"
  end
  if debug then
    print(curl_command)
  end

  local json = false
  for _, header in ipairs(headers) do
    if header:match("-H \"Accept: application/json\"") then
      json = true
      break
    end
  end
  local to_jq = json and " | jq" or ""
  -- Execute curl command in a new split
  local cmd = curl_command .. " -s -w \\%{time_total} " .. to_jq
  require("lib.terminal").new_terminal_win(cmd, false, {
    height = math.floor(vim.o.lines * 0.3),
    win = -1,
    split = "below",
  })
  -- local _, err = pcall(vim.cmd, { "vsplit","|", "term", curl_command, " -s -w \\%{time_total}", to_jq })
  -- if err:match("E114") or err:match("E116") then
  --   print("Terminal change due 'termopen' doesnt support long curl commands.\n" ..
  --   vim.fn.system(curl_command .. " -s -w %{time_total}" .. to_jq))
  -- end
end

---Execute curl command
---@param verbose boolean? run curl in verbose mode
---@param debug boolean? run curl in debug mode
function M.exec(verbose, debug)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local total_lines = vim.api.nvim_buf_line_count(0)
  local current_line = cursor_pos[1]

  -- Find the start of the current block
  local start_line = current_line
  while start_line > 1 do
    local line = vim.api.nvim_buf_get_lines(0, start_line - 2, start_line - 1, false)[1]
    if line:match("^###") then
      break
    end
    start_line = start_line - 1
  end

  -- Find the end of the current block
  local end_line = current_line
  while end_line <= total_lines do
    local line = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]
    if line:match("^###") and end_line ~= current_line then
      break
    end
    end_line = end_line + 1
  end

  if start_line == end_line then
    print("Error: No HTTP request block found.")
    return
  end

  -- Get the lines of the current block
  parse(vim.api.nvim_buf_get_lines(0, start_line - 1, end_line - 1, false), verbose, debug)
end

return M