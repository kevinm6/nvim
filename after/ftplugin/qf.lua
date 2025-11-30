local del_qf_item = function()
  local items = vim.fn.getqflist()
  local line = vim.fn.line "."
  table.remove(items, line)
  vim.fn.setqflist(items, "r")
  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

---Keymaps
local set_keymap = vim.keymap.set
set_keymap("n", "<C-k>", "<cmd>cprev<CR>", { buffer = true, silent = true })
set_keymap("n", "<C-j>", "<cmd>cnext<CR>", { buffer = true, silent = true })
set_keymap("n", "<C-l>", "<CR>", { buffer = true, silent = true })
set_keymap("n", "q", function()
  vim.cmd.quit { bang = true }
end, { buffer = true, silent = true })
set_keymap("n", "<esc>", function()
  vim.cmd.quit { bang = true }
end, { buffer = true, silent = true })

set_keymap("n", "dd", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
set_keymap("v", "D", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })