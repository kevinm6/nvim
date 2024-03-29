-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim
-- Author       : Kevin
-- Last Modified: 23 Mar 2024, 21:20
-------------------------------------

local map = vim.keymap.set

-- NORMAL MODE & VISUAL MODE
map("n", "<leader>.", function()
   vim.cmd.cd "%:h"
   vim.notify(string.format(" Current Working Directory:\n « %s »", vim.fn.expand "%:p:h"), vim.log.levels.INFO, {
      title = "File Explorer",
      render = "wrapped-compact",
      timeout = 4,
    on_open = function(win)
         local buf = vim.api.nvim_win_get_buf(win)
         vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
      end,
   })
end, { desc = "Set cwd from current buffer " })
map({ "n", "v" }, "<M-Left>", "b", { remap = true })
map({ "n", "v" }, "<M-Right>", "E", { remap = true })

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map({ "n", "v" }, "<leader>R", function() end, { desc = "Run" })


-- useful maps
map("n", "<leader>w", function()
   vim.cmd.update { bang = true }
end, { desc = "Save buffer" })
map("n", "<leader>H", function()
   vim.cmd.nohlsearch()
end, { desc = "No Highlight" })
map("n", "<leader>c", function()
   require("lib.utils").delete_curr_buf_open_next()
end, { desc = "Close buffer" })
map("n", "<leader>x", function()
   vim.cmd.update()
   require("lib.utils").delete_curr_buf_open_next()
end, { desc = "Save and Close buffer" })
map("n", "<leader>q", function()
   vim.cmd.bdelete()
end, { desc = "Quit" })
map("n", "<leader>nn", function()
   vim.cmd.Notifications()
end, { desc = "Notifications" })
map("n", "<leader>nm", function()
   vim.cmd.messages()
end, { desc = "Messages" })
map("n", "<leader>Q", function()
  pcall(vim.cmd.copen)
end, { desc = "QuickFixList" })
map("n", "<leader>L", function()
  pcall(vim.cmd.lopen)
end, { desc = "LocationList" })

map(
   "n",
   "<C-s>",
   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
   { desc = "Replace occurence from <cword>" }
)

map("n", "<S-l>", function() pcall(vim.cmd.bnext) end)
map("n", "<S-h>", function() pcall(vim.cmd.bNext) end)
map("n", "<Esc>", function() vim.cmd.noh() end)
map("n", "Q", function() pcall(vim.cmd.DeleteCurrentBuffer) end)

map("n", "U", "<C-r>")
map("n", "Y", "y$")
map("n", "J", "mzJ`z")
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")
map("n", "S", ":%s///g<Left><Left><Left>")
map("n", "<M-S-->", "<C-w>| <C-w>_")
map("n", "<M-J>", "<C-w>J")
map("n", "<M-K>", "<C-w>K")
map("n", "<M-H>", "<C-w>H")
map("n", "<M-L>", "<C-w>L")
map("n", "<M-O>", "O<Esc>j")
map("n", "<M-o>", "o<Esc>k")

-- move text
map("n", "<M-k>", "<Esc>:m .-2<CR>==", { silent = true })
map("n", "<M-j>", "<Esc>:m .+1<CR>==", { silent = true })

-- delete & cut
map("n", "x", [["_x]])
-- set_keymap({ "n", "v" }, "d", [["_d]])
-- set_keymap("n", "D", [["_D]])

-- Window managing
map("n", "<leader>W", "<C-W>", { desc = "Window", remap = true })

-- resize windows
map("n", "<S-Up>", function()
   vim.cmd.resize "+2"
end)
map("n", "<S-Down>", function()
   vim.cmd.resize "-2"
end)
map("n", "<S-Left>", function()
   vim.cmd "vertical resize -2"
end)
map("n", "<S-Right>", function()
   vim.cmd "vertical resize +2"
end)

map({ "n", "v" }, "<leader>y", function() end, { desc = "Yank" })
map("n", "<leader>yy", [["+yy]], { desc = "Yank line to clipboard" })
map("n", "<leader>Y", [["+y$]], { desc = "Yank 'til end to clipboard" })

-- Tabs
map("n", "<Tab>", "<cmd>tabnext<cr>")
map("n", "<S-Tab>", "<cmd>tabprev<cr>")


-- exit from NeoVim and Save or not
map("n", "ZZ", function()
   vim.cmd.update()
   pcall(vim.cmd.DeleteCurrentBuffer)
end, { desc = "Save and Close buffer" })
map("n", "ZQ", function()
   vim.cmd.quit { bang = true }
end, { desc = "Close buffer and go to next" })
map("n", "ZA", ":%bdelete | :Alpha<CR>", { desc = "Close all Buffers" })

map("n", "<leader>fp", function()
   require("lib.utils").projects()
end, { desc = "Projects" })

map("n", "<leader>fx",  function ()
  local file = vim.fn.expand "%:t"
  vim.api.nvim_exec2(':!chmod +x %', {})
  local msg = string.format("File\n < %s >\n is now executable", file)
  vim.notify(msg, vim.log.levels.INFO, { title = "File Info" })
end, { desc = "File executable" })

-- TERMINAL MODE
map("t", "<Esc>", [[<C-\><C-n>]])
map("t", "<C-e>", [[<C-\><C-n>]])
map("t", "<C-o>", [[<C-\><C-o>]])
map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
map("t", "<C-l>", [[<C-\><C-n><C-w>l]])


-- INSERT MODE
map("i", "<M-Left>", "<Esc>bi")
map("i", "<M-Right>", "<Esc>ea")
map("i", "<Esc>", "<Esc>`^")
map("i", "<F2>", [[<C-R>=strftime("%d %b %y, %H:%M")<CR>]])
map("i", "jk", "<Esc>")
map("i", ",", ",<C-g>u") -- checkpoints for undo
map("i", ".", ".<C-g>u") -- checkpoints for undo

-- add description to <C-x> mappings
map("i", "<C-x><C-l>", "<C-x><C-l>", { desc = "Whole lines" })
map("i", "<C-x><C-n>", "<C-x><C-n>", { desc = "Keywords in current file" })
map("i", "<C-x><C-k>", "<C-x><C-k>", { desc = "Keywords in dictionary" })
map("i", "<C-x><C-t>", "<C-x><C-t>", { desc = "Keywords in thesaurus" })
map("i", "<C-x><C-i>", "<C-x><C-i>", { desc = "Keywords in current and included files" })
map("i", "<C-x><C-t>", "<C-x><C-]>", { desc = "Tags" })
map("i", "<C-x><C-f>", "<C-x><C-f>", { desc = "File names" })
map("i", "<C-x><C-d>", "<C-x><C-d>", { desc = "Definitions or macros" })
map("i", "<C-x><C-v>", "<C-x><C-v>", { desc = "Vim command-line" })
map("i", "<C-x><C-u>", "<C-x><C-u>", { desc = "User defined completion" })
map("i", "<C-x><C-o>", "<C-x><C-o>", { desc = "Omni completion" })
map("i", "<C-x>s", "<C-x>s", { desc = "Spelling suggestions" })


-- VISUAL MODE
map("v", "<BS>", [["_d]])
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "p", "_dP")
map("v", "<C-s>", [[:s///gI<Left><Left><Left><Left>]], { desc = "Range Search & Replace" })
map("v", "<leader>y", [["+y]], { desc = "Yank to clipboard" })
--set_keymap("v", "d", "\+d", { expr = true, desc = "Copy deletion into register \""})
--set_keymap("v", "D", "\+D", { expr = true, desc = "Copy deletion to end into register \"" })
--set_keymap("v", "y", "\+y", { expr = true, desc = "Copy yank into register \"" })
--set_keymap("v", "<BS>", "\"+d", { desc = "Copy deletion into register \"" })
map("x", "ga", function()
   vim.cmd.normal "!"
   vim.ui.input({
      prompt = "Align regex pattern: ",
      default = nil
   }, function(input)
      if not input then return end
      require "lib.alignment".align(input)
   end)
end, { desc = "Align from regex" })

-- move selected text
map("x", "<leader>p", '"_dP')
map("x", "<M-j>", [[:move '>+1<CR>gv-gv]], { silent = true })
map("x", "<M-k>", [[:move '<-2<CR>gv-gv]], { silent = true })

vim.cmd.cnoreabbrev("Wq", "wq")
vim.cmd.cnoreabbrev("Wq", "wq")
vim.cmd.cnoreabbrev("Xa", "xa")
vim.cmd.cnoreabbrev("XA", "xa")