-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim
-- Author       : Kevin
-- Last Modified: 28 May 2023, 13:30
-------------------------------------

local set_opts = function(opts)
   local noremap = opts.noremap == nil and true or opts.noremap
   local silent = opts.silent == nil and true or opts.silent
   local desc = opts.desc
   return { noremap = noremap, silent = silent, desc = desc }
end

local set_keymap = vim.keymap.set


-- GUI
-- VimR keymaps (command key and others not supported in term)
if vim.fn.has "gui_vimr" == 1 then
   -- NORMAL-MODE & VISUAL-MODE
   set_keymap({ "n", "v" }, "<D-Right>", "$", set_opts {})
   set_keymap({ "n", "v" }, "<D-Left>", "0", set_opts {})
   set_keymap({ "n", "v" }, "<D-Down>", "G", set_opts {})
   set_keymap({ "n", "v" }, "<D-Up>", "gg", set_opts {})
   set_keymap("n", "<C-Tab>", "<cmd>bnext<cr>", set_opts {})
   set_keymap("n", "<C-S-Tab>", "<cmd>bprevious<cr>", set_opts {})
   -- move text
   set_keymap("n", "ª", ":move .+1<CR>==gi", set_opts {}) -- "ª" = "<A-j>"
   set_keymap("n", "º", ":move .-2<CR>==gi", set_opts {}) -- "º" = "<A-k>"

   -- INSERT-MODE
   set_keymap("i", "<D-BS>", "<C-u>", set_opts {})
   set_keymap("i", "<D-Del>", [[<Esc>"_dA]], set_opts {})
   set_keymap("i", "<D-Right>", "<Esc>A", set_opts {})
   set_keymap("i", "<D-Left>", "<Esc>I", set_opts {})
   set_keymap("i", "<D-Down>", "<Esc>Gi", set_opts {})
   set_keymap("i", "<D-Up>", "<Esc>ggi", set_opts {})
   set_keymap("i", "<M-BS>", "<C-w>", set_opts {})
   set_keymap("i", "<M-Del>", [[<C-o>"_dw]], set_opts {})
end


-- NORMAL MODE & VISUAL MODE
set_keymap("n", "<leader>.", function()
   vim.cmd.cd "%:h"
   vim.notify((" Current Working Directory:   « %s »"):format(vim.fn.expand "%:p:h"), vim.log.levels.INFO, {
      title = "File Explorer",
      timeout = 4,
      on_open = function(win)
         local buf = vim.api.nvim_win_get_buf(win)
         vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      end,
   })
end, set_opts { desc = "Set dir to buffer parent" })
set_keymap({ "n", "v" }, "<M-Left>", "b", set_opts {})
set_keymap({ "n", "v" }, "<M-Right>", "E", set_opts {})
set_keymap("n", "<S-Left>", "vh", set_opts {})
set_keymap("n", "<S-Right>", "vl", set_opts {})
set_keymap("n", "<S-Up>", "vk", set_opts {})
set_keymap("n", "<S-Down>", "vj", set_opts {})
set_keymap("n", "<C-h>", "<C-w>h", set_opts {})
set_keymap("n", "<C-j>", "<C-w>j", set_opts {})
set_keymap("n", "<C-k>", "<C-w>k", set_opts {})

-- Session
set_keymap("n", "<leader>Ss", function()
   require "user_lib.functions".save_session()
end, set_opts { desc = "Save" })
set_keymap("n", "<leader>Sr", function()
   require "user_lib.functions".restore_session()
end, set_opts { desc = "Restore" })
set_keymap("n", "<leader>Sd", function()
   require "user_lib.functions".delete_session()
end, set_opts { desc = "Delete" })

-- useful maps
set_keymap("n", "<leader>w", function()
   vim.cmd.update { bang = true }
end, set_opts { desc = "Save buffer" })
set_keymap("n", "<leader>H", function()
   vim.cmd.nohlsearch {}
end, set_opts { desc = "No Highlight" })
set_keymap("n", "<leader>c", function()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts { desc = "Close buffer" })
set_keymap("n", "<leader>x", function()
   vim.cmd.update {}
   vim.cmd.DeleteCurrentBuffer()
end, set_opts { desc = "Save and Close buffer" })
set_keymap("n", "<leader>q", function()
   vim.cmd.bdelete {}
end, set_opts { desc = "Quit" })
set_keymap("n", "<leader>nn", function()
   vim.cmd.Notifications {}
end, set_opts { desc = "Notifications" })
set_keymap("n", "<leader>nm", function()
   vim.cmd.messages {}
end, set_opts { desc = "Messages" })
set_keymap("n", "<leader>Q", function()
   vim.cmd.copen {}
end, set_opts { desc = "QuickFixList" })
set_keymap("n", "<leader>L", function()
   vim.cmd.copen {}
end, set_opts { desc = "LocationList" })

set_keymap("n", "<C-l>", "<Nop>", set_opts {})
set_keymap("n", "<C-l>", "<C-w>l", set_opts {})
set_keymap("n", "<C-d>", "<C-d>zz", set_opts {})
set_keymap("n", "<C-u>", "<C-u>zz", set_opts {})
set_keymap(
   "n",
   "<C-s>",
   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
   set_opts { silent = false, desc = "Search" }
)
set_keymap("n", "<S-l>", function()
   vim.cmd.bnext {}
end, set_opts {})
set_keymap("n", "<S-h>", function()
   vim.cmd.bprevious {}
end, set_opts {})
set_keymap("n", "<Esc>", function()
   vim.cmd.noh {}
end, set_opts {})
set_keymap("n", "Q", function()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts {})
set_keymap("n", "U", "<C-r>", set_opts {})
set_keymap("n", "Y", "y$", set_opts {})
set_keymap("n", "J", "mzJ`z", set_opts {})
set_keymap("n", "n", "nzzzv", set_opts {})
set_keymap("n", "N", "Nzzzv", set_opts {})
set_keymap("n", "S", ":s///<Left><Left>", set_opts { silent = false })
-- set_keymap("n", "µ", "<cmd>Glow<cr>", set_opts {})
set_keymap("n", "—", "<C-w>| <C-w>_", set_opts {})
set_keymap("n", "˝", "<C-w>J", set_opts {})
set_keymap("n", "˛", "<C-w>K", set_opts {})
set_keymap("n", "¸", "<C-w>H", set_opts {})
set_keymap("n", "ˇ", "<C-w>L", set_opts {})
set_keymap("n", "Ø", "O<Esc>j", set_opts {})
set_keymap("n", "ø", "o<Esc>k", set_opts {})
set_keymap("n", "+", "<C-a>", set_opts {})
set_keymap("n", "-", "<C-x>", set_opts {})
set_keymap("n", "ff", "/", set_opts { silent = false, desc = "Search" })

-- move text
set_keymap("n", "º", "<Esc>:m .-2<CR>==", set_opts {})
set_keymap("n", "ª", "<Esc>:m .+1<CR>==", set_opts {})
-- delete & cut
set_keymap("n", "x", [["_x]], set_opts {})
set_keymap({ "n", "v" }, "d", [["_d]], set_opts {})
set_keymap("n", "D", [["_D]], set_opts {})

-- Window managing
set_keymap("n", "<leader>Ws", function()
   vim.cmd.split {}
end, set_opts { desc = "HSplit" })
set_keymap("n", "<leader>Wv", function()
   vim.cmd.vsplit {}
end, set_opts { desc = "VSplit" })
set_keymap("n", "<leader>Wo", function()
   vim.cmd.only()
end, set_opts { desc = "Close other windows" })
set_keymap("n", "<leader>W=", "<C-w>=", set_opts { desc = "Windows equals" })
set_keymap("n", "<leader>Wm", "<C-w>|<bar> <C-w>_", set_opts { desc = "Window maximise" })

-- resize windows
set_keymap("n", "<S-Up>", function()
   vim.cmd.resize "+2"
end)
set_keymap("n", "<S-Down>", function()
   vim.cmd.resize "-2"
end)
set_keymap("n", "<S-Left>", function()
   vim.cmd "vertical resize -2"
end)
set_keymap("n", "<S-Right>", function()
   vim.cmd "vertical resize +2"
end)

set_keymap("n", "<leader>yy", [["+yy]], set_opts { desc = "Yank line to clipboard" })
set_keymap("n", "<leader>Y", [["+y$]], set_opts { desc = "Yank 'til end to clipboard" })

-- Config File
-- set_keymap("n", "<leader>0s", function()
--    vim.cmd.source "$MYVIMRC"
--    vim.notify("Config file sourced", vim.log.levels.INFO)
-- end, set_opts { desc = "Source Neovim config file" })
-- set_keymap("n", "<leader>0e", function()
--    vim.cmd.edit "$NVIMDOTDIR/init.lua"
-- end, set_opts { desc = "Edit Neovim config file" })
-- set_keymap("n", "<leader>0r", function()
--    vim.cmd.luafile "%"
-- end, set_opts { desc = "Reload current buffer" })
-- set_keymap("n", "<leader>0S", function()
--    vim.cmd.source "~/.config/nvim/lua/plugins/core/luasnip.lua"
-- end, set_opts { desc = "Reload custom snippet" })

-- exit from NeoVim and Save or not
set_keymap("n", "ZZ", function()
   vim.cmd.update {}
   vim.cmd.DeleteCurrentBuffer {}
end, set_opts { desc = "Save and Close buffer" })
set_keymap("n", "ZQ", function()
   vim.cmd.quit { bang = true }
end, set_opts { desc = "Close buffer and go to next" })
set_keymap("n", "ZA", ":%bdelete | :Alpha<CR>", set_opts { desc = "Close all Buffers" })

set_keymap({ "n", "v" }, "<leader>ft", function()
   require("plugins.translator.translate").translate()
end, set_opts { desc = "Translate" })


-- TERMINAL MODE
set_keymap("t", "<Esc>", "<C-\\><C-n>", set_opts {})

-- INSERT MODE
set_keymap("i", "<S-Right>", "<C-o>vl", set_opts {})
set_keymap("i", "<S-Left>", "<C-o>vh", set_opts {})
set_keymap("i", "<S-Down>", "<C-o>vj", set_opts {})
set_keymap("i", "<S-Up>", "<C-o>vk", set_opts {})
set_keymap("i", "<M-Left>", "<Esc>bi", set_opts {})
set_keymap("i", "<M-Right>", "<Esc>ea", set_opts {})
set_keymap("i", "<Esc>", "<Esc>`^", set_opts {})
set_keymap("i", "<F2>", [[<C-R>=strftime("%d %b %y, %H:%M")<CR>]], set_opts {})
set_keymap("i", "jk", "<Esc>", set_opts {})
set_keymap("i", ",", ",<C-g>u", set_opts {}) -- checkpoints for undo
set_keymap("i", ".", ".<C-g>u", set_opts {}) -- checkpoints for undo

-- add description to <C-x> mappings
set_keymap("i", "<C-x><C-l>", "<C-x><C-l>", set_opts { expr = true, desc = "Whole lines" })
set_keymap("i", "<C-x><C-n>", "<C-x><C-n>", set_opts { expr = true, desc = "Keywords in current file" })
set_keymap("i", "<C-x><C-k>", "<C-x><C-k>", set_opts { expr = true, desc = "Keywords in dictionary" })
set_keymap("i", "<C-x><C-t>", "<C-x><C-t>", set_opts { expr = true, desc = "Keywords in thesaurus" })
set_keymap("i", "<C-x><C-i>", "<C-x><C-i>", set_opts { expr = true, desc = "Keywords in current and included files" })
set_keymap("i", "<C-x><C-]>", "<C-x><C-]>", set_opts { expr = true, desc = "Tags" })
set_keymap("i", "<C-x><C-f>", "<C-x><C-f>", set_opts { expr = true, desc = "File names" })
set_keymap("i", "<C-x><C-d>", "<C-x><C-d>", set_opts { expr = true, desc = "Definitions or macros" })
set_keymap("i", "<C-x><C-v>", "<C-x><C-v>", set_opts { expr = true, desc = "Vim command-line" })
set_keymap("i", "<C-x><C-u>", "<C-x><C-u>", set_opts { expr = true, desc = "User defined completion" })
set_keymap("i", "<C-x><C-o>", "<C-x><C-o>", set_opts { expr = true, desc = "Omni completion" })
set_keymap("i", "<C-x>s", "<C-x>s", set_opts { expr = true, desc = "Spelling suggestions" })


-- VISUAL MODE
set_keymap("v", "<BS>", [["_d]], set_opts {})
set_keymap("v", "<", "<gv", set_opts {})
set_keymap("v", ">", ">gv", set_opts {})
set_keymap("v", "p", "_dP", set_opts {})
set_keymap("v", "<C-s>", [[:s///gI<Left><Left><Left><Left>]], set_opts { silent = false, desc = "Search" })
set_keymap("v", "<leader>y", [["+y]], set_opts { desc = "Yank to clipboard" })
set_keymap("v", "<leader>lf", function()
   require("user_lib.functions").range_format()
end, set_opts { desc = "Range format" })
--set_keymap("v", "d", "\+d", set_opts { expr = true, desc = "Copy deletion into register \""})
--set_keymap("v", "D", "\+D", set_opts { expr = true, desc = "Copy deletion to end into register \"" })
--set_keymap("v", "y", "\+y", set_opts { expr = true, desc = "Copy yank into register \"" })
--set_keymap("v", "<BS>", "\"+d", set_opts { desc = "Copy deletion into register \"" })
set_keymap("v", "ga", function()
   vim.cmd.normal "!"
   vim.ui.input({ prompt = "Align regex pattern: ", default = nil }, function(input)
      if input then
         require "user_lib.functions".align(input)
      end
   end)
end, set_opts { desc = "Align from regex" })

-- move selected text
set_keymap("x", "<leader>p", '"_dP', set_opts {})
set_keymap("x", "J", [[:move '>+1<CR>gv-gv]], set_opts {})
set_keymap("x", "K", [[:move '<-2<CR>gv-gv]], set_opts {})
set_keymap("x", "ª", [[:move '>+1<CR>gv-gv]], set_opts {}) -- <A-j>
set_keymap("x", "º", [[:move '<-2<CR>gv-gv]], set_opts {}) -- <A-k>
