-----------------------------------
-- File         : cheat_sheet.lua
-- Description  : query < https://cht.sh > to get result in Neovim
-- Author       : Kevin
-- Last Modified: 24 Mar 2024, 13:58
-----------------------------------

local cheat_sheet = {}
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
function cheat_sheet.setup(user_conf)
  opts = vim.tbl_deep_extend("force", opts, user_conf or {})
end

function cheat_sheet.run(input)
  local ui = api.nvim_list_uis()[1]
  cheat_sheet.main_win = nil
  cheat_sheet.main_buf = nil
  cheat_sheet.main_win_width = math.floor(ui.width / 1.2)
  cheat_sheet.main_win_height = math.floor(ui.height / 1.2)
  cheat_sheet.main_win_style = opts.main_win.style
  cheat_sheet.main_win_relative = "win"
  cheat_sheet.main_win_border = opts.main_win.border
  cheat_sheet.main_col = ui.width / 2 - cheat_sheet.main_win_width / 2
  cheat_sheet.main_row = ui.height / 1.1 - cheat_sheet.main_win_height / 2

  cheat_sheet.open_preview(input.args)
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

function cheat_sheet.open_preview(args)
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
  local win_height = cheat_sheet.main_win_height
  if #output < cheat_sheet.main_win_height then
    win_height = #output
  end

  cheat_sheet.main_buf = api.nvim_create_buf(false, true)
  cheat_sheet.main_win = api.nvim_open_win(cheat_sheet.main_buf, false, {
    relative = cheat_sheet.main_win_relative,
    width = cheat_sheet.main_win_width,
    height = win_height,
    style = cheat_sheet.main_win_style,
    row = cheat_sheet.main_row,
    col = cheat_sheet.main_col,
    anchor = "NW",
    border = cheat_sheet.main_win_border,
  })

  api.nvim_set_current_win(cheat_sheet.main_win)
  api.nvim_win_set_option(cheat_sheet.main_win, "cursorline", true)
  -- set background color for the window
  api.nvim_win_set_option(cheat_sheet.main_win, "winhighlight", "Normal:CursorLine")
  api.nvim_buf_set_option(cheat_sheet.main_buf, "filetype", filetype)
  for _, line in ipairs(output) do
    line = line:gsub("[^m]*m", "")
    api.nvim_buf_set_lines(cheat_sheet.main_buf, -1, -1, true, { line })
  end

  api.nvim_buf_set_option(cheat_sheet.main_buf, "modifiable", false)
end

return cheat_sheet