-----------------------------------
-- File         : cheat_sheet.lua
-- Description  : query < https://cht.sh > to get result in Neovim
-- Author       : Kevin
-- Last Modified: 14 Oct 2023, 09:15
-----------------------------------

local M = {}
local api = vim.api

local opts = {
  auto_fill = {
    filetype = true,
    current_word = true,
  },

  main_win = {
    style = "minimal",
    border = "rounded",
  },
}

---TODO: to improve and remove deprecated code after update to nvim-0.10
function M.setup(user_conf)
  opts = vim.tbl_deep_extend("force", opts, user_conf or {})
end

function M.run(input)
  local ui = api.nvim_list_uis()[1]
  M.main_win = nil
  M.main_buf = nil
  M.main_win_width = math.floor(ui.width / 1.2)
  M.main_win_height = math.floor(ui.height / 1.2)
  M.main_win_style = opts.main_win.style
  M.main_win_relative = "win"
  M.main_win_border = opts.main_win.border
  M.main_col = ui.width / 2 - M.main_win_width / 2
  M.main_row = ui.height / 1.1 - M.main_win_height / 2

  M.open_preview(input.args)
end


---Split a string based on input
---@param input_string string string to be splitted
---@param sep string string to be used as separator
---@return table t string splitted in a table
local function split_string(input_string, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(input_string, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function M.open_preview(args)
  local search_input = {}
  local sep = " "


  if args == "" then
    sep = "/"
    vim.ui.input({
      prompt = "Enter <language>"..sep.."<search>: ",
      default = vim.bo.filetype.."/",
    }, function(input)
        if input then
          search_input = split_string(input, sep)
        else
          vim.notify("No search input passed", vim.log.levels.ERROR)
        end
      end)
  else
    search_input = split_string(args, sep)
  end

  local filetype, search = search_input[1], search_input[2]

  -- search and get result
  local url = string.format("https://cheat.sh/%s/%s", filetype, search)

  local cmdcommand = "curl -s " .. url
  local output = vim.api.nvim_call_function("system", { cmdcommand })
  output = split_string(output, "\n")
  local win_height = M.main_win_height
  if #output < M.main_win_height then
    win_height = #output
  end

  M.main_buf = api.nvim_create_buf(false, true)
  M.main_win = api.nvim_open_win(M.main_buf, false, {
    relative = M.main_win_relative,
    width = M.main_win_width,
    height = win_height,
    style = M.main_win_style,
    row = M.main_row,
    col = M.main_col,
    anchor = "NW",
    border = M.main_win_border,
  })

  api.nvim_set_current_win(M.main_win)
  api.nvim_win_set_option(M.main_win, "cursorline", true)
  -- set background color for the window
  api.nvim_win_set_option(M.main_win, "winhighlight", "Normal:CursorLine")
  api.nvim_buf_set_option(M.main_buf, "filetype", filetype)
  for _, line in ipairs(output) do
    line = line:gsub("[^m]*m", "")
    api.nvim_buf_set_lines(M.main_buf, -1, -1, true, { line })
  end

  api.nvim_buf_set_option(M.main_buf, "modifiable", false)
end

return M
