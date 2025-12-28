-----------------------------------
-- File         : cheat_sheet.lua
-- Description  : query < https://cht.sh > to get result in Neovim
-- Author       : Kevin
-- Last Modified: 28 Dec 2025, 17:24
-----------------------------------

local M = {
  opts = {
    auto_fill = {
      filetype = true,
      current_word = true,
    },

    main_win = {
      style = "minimal",
      border = "rounded",
      title = "CheatSH",
      title_pos = "center",
      noautocmd = true,
      anchor = "NW",
    },
  },
}

local api = vim.api

-- function cheat_sheet.setup(user_conf)
--   opts = vim.tbl_deep_extend("force", opts, user_conf or {})
-- end

function M.run(input)
  local ui = api.nvim_list_uis()[1]
  local min_width = math.floor(ui.width * 0.8)
  local min_height = math.floor(ui.height * 0.46)
  M.main_win = nil
  M.main_buf = nil
  M.main_win_width = min_width > 0 and min_width or vim.o.columns * 0.5
  M.main_win_height = min_height > 0 and min_height or vim.o.lines * 0.5
  M.main_win_style = M.opts.main_win.style
  M.main_win_relative = "win"
  M.main_win_border = M.opts.main_win.border
  M.main_col = ui.width / 2 - M.main_win_width / 2
  M.main_row = ui.height / 2 - M.main_win_height / 2

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
  for str in string.gmatch(input_string, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function M.open_preview(args)
  local search_input = {}
  local sep = "/"

  if args ~= "" then
    search_input = split_string(args, sep)
  else
    vim.ui.input({
      prompt = "Enter <language>" .. sep .. "<search>: ",
      default = vim.bo.filetype .. "/",
    }, function(input)
      if input then
        search_input = split_string(input, sep)
      else
        vim.notify("CheatSH - no search input passed", vim.log.levels.ERROR)
      end
    end)
  end

  local filetype, query = search_input[1], search_input[2]

  -- search and get result
  local url = string.format("https://cheat.sh/%s/%s", filetype, query)

  -- figure out a way to run async and then present the window
  local output = vim.system({ "curl", "-s", url }, { text = true, timeout = 5000 }):wait()
  output = split_string(output.stdout, "\n")
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
    anchor = M.opts.main_win.anchor,
    border = M.opts.main_win.border,
    title_pos = M.opts.main_win.title_pos,
    title = string.format("CheatSH < %s/%s >", filetype, query),
    noautocmd = true,
  })

  api.nvim_set_current_win(M.main_win)

  local set_opt = api.nvim_set_option_value
  set_opt("cursorline", true, { win = M.main_win })
  -- set background color for the window
  -- api.nvim_set_option_value("winhighlight", "Normal:CursorLine", { win = cheat_sheet.main_win })
  set_opt("filetype", filetype, { buf = M.main_buf })
  for _, line in ipairs(output) do
    line = line:gsub("[^m]*m", "")
    api.nvim_buf_set_lines(M.main_buf, -1, -1, true, { line })
  end

  set_opt("modifiable", false, { buf = M.main_buf })
  set_opt("swapfile", false, { buf = M.main_buf })
  set_opt("bufhidden", "wipe", { buf = M.main_buf })
  set_opt("buftype", "nofile", { buf = M.main_buf })
  set_opt("buftype", "nofile", { buf = M.main_buf })
  vim.keymap.set("n", "<esc><esc>", "<cmd>quit<cr>", {
    desc = "Close CheatSH",
    buffer = M.main_buf,
  })
  -- Stop client if is started due to the ft option set to highlights the syntax of output
  -- vim.lsp.stop_client(vim.lsp.get_clients { bufnr = M.main_buf })
end

return M