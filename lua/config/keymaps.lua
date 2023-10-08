-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim
-- Author       : Kevin
-- Last Modified: 13 Oct 2023, 17:25
-------------------------------------


--- Set opts for keymaps. It's a wrapper to return a table of options.
--- @param opts table populated table of keymap specific opts or empty table to ovverride
--- default
--- @return table opts options to be used for keymaps
local function set_opts(opts)
   local remap = (opts.remap == nil) and false or opts.remap
   local noremap = (opts.noremap == nil and not opts.remap) and true or opts.noremap
   local silent = (opts.silent == nil) and true or opts.silent

   return { noremap = noremap, remap = remap, silent = silent, desc = opts.desc }
end

local set_keymap = vim.keymap.set


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
end, set_opts { desc = "Set cwd from current buffer " })
set_keymap({ "n", "v" }, "<M-Left>", "b", set_opts { remap = true })
set_keymap({ "n", "v" }, "<M-Right>", "E", set_opts { remap = true })
set_keymap("n", "<C-h>", "<C-w>h", set_opts {})
set_keymap("n", "<C-j>", "<C-w>j", set_opts {})
set_keymap("n", "<C-k>", "<C-w>k", set_opts {})


vim.keymap.set({ "n", "v" }, "<leader>R", function() end, { desc = "Run" })

-- Session
set_keymap("n", "<leader>S", function() end, set_opts { desc = "Sessions" })
set_keymap("n", "<leader>Ss", function()
   require "user_lib.sessions".save_session()
end, set_opts { desc = "Save" })
set_keymap("n", "<leader>Sr", function()
   require "user_lib.sessions".restore_session()
end, set_opts { desc = "Restore" })
set_keymap("n", "<leader>Sd", function()
   require "user_lib.sessions".delete_session()
end, set_opts { desc = "Delete" })

-- useful maps
set_keymap("n", "<leader>w", function()
   vim.cmd.update { bang = true }
end, set_opts { desc = "Save buffer" })
set_keymap("n", "<leader>H", function()
   vim.cmd.nohlsearch()
end, set_opts { desc = "No Highlight" })
set_keymap("n", "<leader>c", function()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts { desc = "Close buffer" })
set_keymap("n", "<leader>x", function()
   vim.cmd.update()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts { desc = "Save and Close buffer" })
set_keymap("n", "<leader>q", function()
   vim.cmd.bdelete()
end, set_opts { desc = "Quit" })
set_keymap("n", "<leader>nn", function()
   vim.cmd.Notifications {}
end, set_opts { desc = "Notifications" })
set_keymap("n", "<leader>nm", function()
   vim.cmd.messages()
end, set_opts { desc = "Messages" })
set_keymap("n", "<leader>Q", function()
   vim.cmd.copen()
end, set_opts { desc = "QuickFixList" })
set_keymap("n", "<leader>L", function()
   vim.cmd.lopen()
end, set_opts { desc = "LocationList" })

set_keymap("n", "<C-l>", "<Nop>", set_opts {})
set_keymap("n", "<C-l>", "<C-w>l", set_opts {})
set_keymap("n", "<C-d>", "<C-d>zz", set_opts {})
set_keymap("n", "<C-u>", "<C-u>zz", set_opts {})
set_keymap(
   "n",
   "<C-s>",
   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
   set_opts { silent = false, desc = "Replace occurence from <cword>" }
)

set_keymap("n", "<S-l>", function()
   vim.cmd.bnext()
end, set_opts {})
set_keymap("n", "<S-h>", function()
   vim.cmd.bprevious {}
end, set_opts {})
set_keymap("n", "<Esc>", function()
   vim.cmd.noh()
end, set_opts {})
set_keymap("n", "Q", function()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts {})
set_keymap("n", "U", "<C-r>", set_opts {})
set_keymap("n", "Y", "y$", set_opts {})
set_keymap("n", "J", "mzJ`z", set_opts {})
set_keymap("n", "n", "nzzzv", set_opts {})
set_keymap("n", "N", "Nzzzv", set_opts {})
set_keymap("n", "S", ":%s///g<Left><Left><Left>", set_opts { silent = false })
-- set_keymap("n", "µ", "<cmd>Glow<cr>", set_opts {})
set_keymap("n", "—", "<C-w>| <C-w>_", set_opts {})
set_keymap("n", "˝", "<C-w>J", set_opts {})
set_keymap("n", "˛", "<C-w>K", set_opts {})
set_keymap("n", "¸", "<C-w>H", set_opts {})
set_keymap("n", "ˇ", "<C-w>L", set_opts {})
set_keymap("n", "Ø", "O<Esc>j", set_opts {})
set_keymap("n", "ø", "o<Esc>k", set_opts {})

-- move text
set_keymap("n", "º", "<Esc>:m .-2<CR>==", set_opts {})
set_keymap("n", "ª", "<Esc>:m .+1<CR>==", set_opts {})

-- delete & cut
set_keymap("n", "x", [["_x]], set_opts {})
-- set_keymap({ "n", "v" }, "d", [["_d]], set_opts {})
-- set_keymap("n", "D", [["_D]], set_opts {})

-- Window managing
set_keymap("n", "<leader>W", "<C-W>", set_opts { desc = "Window", remap = true })

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

set_keymap({ "n", "v" }, "<leader>y", function() end, set_opts { desc = "Yank" })
set_keymap("n", "<leader>yy", [["+yy]], set_opts { desc = "Yank line to clipboard" })
set_keymap("n", "<leader>Y", [["+y$]], set_opts { desc = "Yank 'til end to clipboard" })

-- Tabs
set_keymap("n", "<Tab>", "<cmd>tabnext<cr>", set_opts {})
set_keymap("n", "<S-Tab>", "<cmd>tabprev<cr>", set_opts {})

-- Config File
set_keymap("n", "<leader>Cc", function()
   local has_telescope, telescope = pcall(require, "telescope")
   if has_telescope then
      telescope.extensions.file_browser.file_browser { cwd = "$NVIMDOTDIR" }
   else
      vim.cmd.edit "$NVIMDOTDIR"
   end
end, set_opts { desc = "Neovim Config" })

-- exit from NeoVim and Save or not
set_keymap("n", "ZZ", function()
   vim.cmd.update()
   vim.cmd.DeleteCurrentBuffer()
end, set_opts { desc = "Save and Close buffer" })
set_keymap("n", "ZQ", function()
   vim.cmd.quit { bang = true }
end, set_opts { desc = "Close buffer and go to next" })
set_keymap("n", "ZA", ":%bdelete | :Alpha<CR>", set_opts { desc = "Close all Buffers" })

set_keymap({ "n", "v" }, "<leader>fT", function()
   require("plugins.translator.translate").translate()
end, set_opts { desc = "Translate" })


-- TERMINAL MODE
set_keymap("t", "<Esc>", [[<C-\><C-n>]], set_opts {})
set_keymap("t", "<C-e>", [[<C-\><C-n>]], set_opts {})
set_keymap("t", "<C-o>", [[<C-\><C-o>]], set_opts {})
set_keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], set_opts {})
set_keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], set_opts {})
set_keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], set_opts {})
set_keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], set_opts {})


-- INSERT MODE
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
set_keymap("v", "<C-s>", [[:s///gI<Left><Left><Left><Left>]], set_opts { silent = false, desc = "Range Search & Replace" })
set_keymap("v", "<leader>y", [["+y]], set_opts { desc = "Yank to clipboard" })
--set_keymap("v", "d", "\+d", set_opts { expr = true, desc = "Copy deletion into register \""})
--set_keymap("v", "D", "\+D", set_opts { expr = true, desc = "Copy deletion to end into register \"" })
--set_keymap("v", "y", "\+y", set_opts { expr = true, desc = "Copy yank into register \"" })
--set_keymap("v", "<BS>", "\"+d", set_opts { desc = "Copy deletion into register \"" })
set_keymap("v", "ga", function()
   vim.cmd.normal "!"
   vim.ui.input({ prompt = "Align regex pattern: ", default = nil }, function(input)
      if input then
         require "user_lib.alignment".align(input)
      end
   end)
end, set_opts { desc = "Align from regex" })

-- move selected text
set_keymap("x", "<leader>p", '"_dP', set_opts {})
set_keymap("x", "ª", [[:move '>+1<CR>gv-gv]], set_opts {})
set_keymap("x", "º", [[:move '<-2<CR>gv-gv]], set_opts {})
