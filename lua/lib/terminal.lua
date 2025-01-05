-------------------------------------
--  File         : terminal.lua
--  Description  : terminal utilities functions
--  Author       : Kevin
--  Last Modified: 17/12/2024 - 08:53
-------------------------------------

local M = {
  channels = {},
}

M.presets = {
  lazygit = {
    title = "LazyGit",
    height = math.ceil(vim.o.lines * 0.94),
    width = vim.o.columns,
    relative = "editor",
    title_pos = "center",
    border = "rounded",
  },
  htop = {
    title = "Htop",
    height = math.ceil(vim.o.lines * 0.94),
    width = vim.o.columns,
    relative = "editor",
    title_pos = "center",
    border = "rounded",
  },
  ncdu = {
    title = "Ncdu",
    height = math.ceil(vim.o.lines * 0.94),
    width = vim.o.columns,
    relative = "editor",
    title_pos = "center",
    border = "rounded",
  },
}

---Open new Terminal
---@param cmd string
---@param autoclose boolean
---@param opts table?
function M.new_terminal_win(cmd, autoclose, opts)
  cmd = cmd ~= "" and cmd or vim.o.shell
  local exe = vim.split(cmd, " ", { plain = true, trimempty = true })[1]
  if vim.fn.executable(exe) ~= 1 then
    vim.notify(
      string.format("< %s > is not installed or executable", cmd),
      vim.log.levels.WARN,
      { title = "Terminal❭ Run" }
    )
    return
  end
  opts = opts or {}
  if opts.preset then
    opts = M.presets[opts.preset]
  end
  local buf = vim.api.nvim_create_buf(not autoclose, false) -- if autoclose -> buf = not listed
  local width = opts.width or nil
  local height = opts.height or nil
  local rows = opts.relative and math.ceil(vim.o.lines - height) * 0.5 - 1 or nil
  local cols = opts.relative and math.ceil(vim.o.columns - width) * 0.5 - 1 or nil

  local win = vim.api.nvim_open_win(buf, true, {
    border = opts.border or nil,
    title = opts.title or nil,
    title_pos = opts.title_pos or nil,
    relative = opts.relative or nil,
    row = rows,
    col = cols,
    width = width,
    height = height,
    split = opts.split or nil,
    win = opts.win or nil,
  })

  local chan = vim.fn.termopen(cmd, {
    detach = true,
    on_exit = function()
      if autoclose then
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      M.channels[buf] = nil
    end,
  })
  M.channels[buf] = chan

  vim.keymap.set("n", "q", "<cmd>close<CR>", {
    noremap = true,
    silent = true,
    buffer = buf,
  })

  vim.keymap.set({ "n", "v" }, "<leader>ts", function()
    local current_line = vim.api.nvim_get_current_line()
    vim.api.nvim_chan_send(M.channels[buf], current_line .. "\r")
  end, { desc = "send current line" })
end

return M
