-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim
-- Author       : Kevin
-- Last Modified: 26 Dec 2024, 11:01
-------------------------------------

--- NOTE:if they deliver this -> https://github.com/neovim/neovim/issues/28536
--- at least at the begin just switch the indexes (3, 4) in mapping function wrapper

---Helper function
---@param tbl table table that contains all the params to be passed to `vim.keymap.set`
---  1. mode
---  2. keys
---  3. command|function
---  4. opts
local function map(tbl)
  vim.keymap.set(tbl[1], tbl[2], tbl[3], tbl[4])
end
local function nmap(tbl)
  map { "n", tbl[1], tbl[2], { desc = tbl[3] } }
end
local function vmap(tbl)
  map { "v", tbl[1], tbl[2], { desc = tbl[3] } }
end
local function tmap(tbl)
  map { "t", tbl[1], tbl[2], { desc = tbl[3] } }
end
local function imap(tbl)
  map { "i", tbl[1], tbl[2], { desc = tbl[3] } }
end

-- NORMAL MODE & VISUAL MODE
nmap {
  "<leader>.",
  function()
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
  end,
  "Set cwd from cbuf",
}
map { { "n", "v" }, "<M-Left>", "b", { remap = true } }
map { { "n", "v" }, "<M-Right>", "E", { remap = true } }

-- nmap { "<C-h>", "<C-w>h" }
-- nmap { "<C-j>", "<C-w>j" }
-- nmap { "<C-k>", "<C-w>k" }
-- nmap { "<C-l>", "<C-w>l" }
nmap { "<C-d>", "<C-d>zz" }
nmap { "<C-u>", "<C-u>zz" }

-- useful maps
nmap {
  "<leader>w",
  function()
    vim.cmd.update { bang = true }
  end,
  "Save buffer",
}
-- map("n", "<leader>H", function()
--    vim.cmd.nohlsearch()
-- end, { desc = "No Highlight" })
nmap {
  "<leader>c",
  function()
    require("lib").delete_curr_buf_open_next()
  end,
  "Close buffer",
}
nmap {
  "<leader>x",
  function()
    vim.cmd.update()
    require("lib").delete_curr_buf_open_next()
  end,
  "Save and Close buffer",
}
nmap {
  "<leader>q",
  function()
    pcall(vim.cmd.bdelete, { bang = true })
  end,
  "Quit",
}
nmap { "<leader>nn", "<cmd>Notifications<cr>", "Notifications" }
nmap { "<leader>nm", "<cmd>messages<cr>", "Messages" }
nmap {
  "<leader>Q",
  function()
    pcall(vim.cmd.copen)
  end,
  "QuickFixList",
}
nmap {
  "<leader>L",
  function()
    pcall(vim.cmd.lopen)
  end,
  "LocationList",
}

nmap {
  "<C-s>",
  [[:%s/\<<C-r><C-w>\>/&/gI<Left><Left><Left>]],
  "Replace occurence from <cword>",
}

nmap {
  "<C-ì>",
  function()
    pcall(vim.cmd.edit, "#")
  end,
}
-- nmap { "<S-l>", function() pcall(vim.cmd.bnext) end }
-- nmap { "<S-h>", function() pcall(vim.cmd.bNext) end }
nmap { "<Esc>", "<cmd>nohlsearch<cr>" }
nmap {
  "Q",
  function()
    pcall(vim.cmd.DeleteCurrentBuffer)
  end,
}

nmap {
  "z=",
  function()
    vim.ui.select(
      vim.fn.spellsuggest(vim.fn.expand "<cword>"),
      { prompt = "Select spell suggestion" },
      vim.schedule_wrap(function(selected)
        if selected then
          vim.cmd("normal! ciw" .. selected)
        end
      end)
    )
  end,
  "Spelling suggestion",
}

nmap { "U", "<C-r>" }
nmap { "Y", "y$" }
nmap { "J", "mzJ`z" }
nmap { "n", "nzz" }
nmap { "N", "Nzz" }
nmap { "#", "#zz" }
nmap { "g*", "g*zz" }
nmap { "S", ":%s///g<Left><Left><Left>" }
nmap { "<M-s>", ":%s//&/gn<Left><Left><Left><Left><Left>", "Count occurrences of search" }
-- nmap { "<M-S-->", "<C-w>| <C-w>_" }
-- nmap { "<M-J>", "<C-w>J" }
-- nmap { "<M-K>", "<C-w>K" }
-- nmap { "<M-H>", "<C-w>H" }
-- nmap { "<M-L>", "<C-w>L" }
nmap { "<M-O>", "O<Esc>j" }
nmap { "<M-o>", "o<Esc>k" }

-- move text
map { "n", "<M-k>", "<Esc>:m .-2<CR>==", { silent = true } }
map { "n", "<M-j>", "<Esc>:m .+1<CR>==", { silent = true } }

-- delete & cut
nmap { "x", [["_x]] }
-- set_keymap({ "n", "v" }, "d", [["_d]])
-- set_keymap("n", "D", [["_D]])

-- resize windows
nmap {
  "<S-Up>",
  function()
    vim.cmd.resize "+2"
  end,
}
nmap {
  "<S-Down>",
  function()
    vim.cmd.resize "-2"
  end,
}
nmap {
  "<S-Left>",
  function()
    vim.cmd "vertical resize -2"
  end,
}
nmap {
  "<S-Right>",
  function()
    vim.cmd "vertical resize +2"
  end,
}

map { { "n", "v" }, "<leader>y", function() end, { desc = "Yank" } }
nmap { "<leader>yy", [["+yy]], "Yank line to clipboard" }
nmap { "<leader>Y", [["+y$]], "Yank 'til end to clipboard" }

-- Tabs
-- nmap { "<Tab>", "<cmd>tabnext<cr>" }
-- nmap { "<S-Tab>", "<cmd>tabprev<cr>" }

-- Buffers
nmap { "<M-l>", "<cmd>bnext<cr>" }
nmap { "<M-h>", "<cmd>bNext<cr>" }

-- exit from NeoVim and Save or not
nmap {
  "ZZ",
  function()
    vim.cmd.update()
    require("lib").delete_curr_buf_open_next()
  end,
  "Save and Close buffer",
}
nmap {
  "ZQ",
  function()
    vim.cmd.quit { bang = true }
  end,
  "Close buffer and go to next",
}
nmap { "ZA", ":%bdelete | :Alpha<CR>", "Close all Buffers" }

nmap {
  "<leader>fp",
  function()
    require("lib").projects()
  end,
  "Projects",
}

---Terminal (open)
nmap {
  "<leader>th",
  function()
    local height = math.floor(vim.o.lines * 0.25)
    require("lib.terminal").new_terminal_win("", true, {
      height = height,
      win = -1,
      split = "below",
    })
  end,
  "Terminal❭ Horizontal",
}

nmap {
  "<leader>tv",
  function()
    local width = math.floor(vim.o.columns * 0.4)
    require("lib.terminal").new_terminal_win("", true, {
      width = width,
      win = -1,
      split = "right",
    })
  end,
  "Terminal❭ Vertical",
}

nmap {
  "<leader>te",
  function()
    local cmd = vim.fn.input { prompt = "Term command => " }
    if cmd ~= "" then
      require("lib.terminal").new_terminal_win(cmd, false, {
        height = math.floor(vim.o.lines * 0.3),
        win = -1,
        split = "below",
      })
    end
  end,
  "Terminal❭ exec",
}

nmap {
  "<leader>tf",
  function()
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.80)
    require("lib.terminal").new_terminal_win("", true, { height = height, width = width, relative = "editor" })
  end,
  "Terminal❭ Float",
}

nmap {
  "<leader>tl",
  function()
    require("lib.terminal").new_terminal_win("lazygit", true, { preset = "lazygit" })
  end,
  "LazyGit",
}

nmap {
  "<leader>tt",
  function()
    require("lib.terminal").new_terminal_win("htop", true, { preset = "htop" })
  end,
  "Htop",
}

-- TERMINAL MODE
tmap { "<Esc><Esc>", [[<C-\><C-n>]] }
tmap { "<C-e>", [[<C-\><C-n>]] }
tmap { "<C-o>", [[<C-\><C-o>]] }
map {
  "t",
  "<C-r>",
  function()
    local char = vim.fn.getchar()
    return '<C-\\><C-N>"' .. vim.fn.nr2char(char) .. "pi"
  end,
  { expr = true, noremap = true },
}
-- tmap { "<C-h>", [[<C-\><C-n><C-w>h]] }
-- tmap { "<C-j>", [[<C-\><C-n><C-w>j]] }
-- tmap { "<C-k>", [[<C-\><C-n><C-w>k]] }
-- tmap { "<C-l>", [[<C-\><C-n><C-w>l]] }

-- INSERT MODE
imap { "<M-Left>", "<Esc>bi" }
imap { "<M-Right>", "<Esc>ea" }
imap { "<Esc>", "<Esc>`^" }
imap { "jk", "<Esc>" }
imap { ",", ",<C-g>u" } -- checkpoints for undo
imap { ".", ".<C-g>u" } -- checkpoints for undo

-- add description to <C-x> mappings
imap { "<C-x><C-l>", "<C-x><C-l>", "Whole lines" }
imap { "<C-x><C-n>", "<C-x><C-n>", "Keywords in current file" }
imap { "<C-x><C-k>", "<C-x><C-k>", "Keywords in dictionary" }
imap { "<C-x><C-t>", "<C-x><C-t>", "Keywords in thesaurus" }
imap { "<C-x><C-i>", "<C-x><C-i>", "Keywords in current and included files" }
imap { "<C-x><C-t>", "<C-x><C-]>", "Tags" }
imap { "<C-x><C-f>", "<C-x><C-f>", "File names" }
imap { "<C-x><C-d>", "<C-x><C-d>", "Definitions or macros" }
imap { "<C-x><C-v>", "<C-x><C-v>", "Vim command-line" }
imap { "<C-x><C-u>", "<C-x><C-u>", "User defined completion" }
imap { "<C-x><C-o>", "<C-x><C-o>", "Omni completion" }
imap { "<C-x>s", "<C-x>s", "Spelling suggestions" }

-- VISUAL MODE
vmap { "<BS>", [["_d]] }
vmap { "<", "<gv" }
vmap { ">", ">gv" }
vmap { "p", "_dP" }
vmap { "<C-s>", [[:s///gI<Left><Left><Left><Left>]], "Range Search & Replace" }
vmap { "<leader>y", [["+y]], " Yank to clipboard" }
map {
  "x",
  "ga",
  function()
    vim.cmd.normal "!"
    vim.ui.input({
      prompt = "Align regex pattern: ",
      default = nil,
    }, function(input)
      if not input then
        return
      end
      require("lib.alignment").align(input)
    end)
  end,
  { desc = "Align from regex" },
}

-- move selected text
map { "x", "<leader>p", '"_dP' }
map { "x", "<M-j>", [[:move '>+1<CR>gv-gv]], { silent = true } }
map { "x", "<M-k>", [[:move '<-2<CR>gv-gv]], { silent = true } }

vim.cmd.cnoreabbrev("Wq", "wq")
vim.cmd.cnoreabbrev("Wq", "wq")
vim.cmd.cnoreabbrev("Xa", "xa")
vim.cmd.cnoreabbrev("XA", "xa")

--TODO nvim-0.11 ?
--NOTE enable on nvim-0.11 and disable nvim-cmp?
---Completion
-- local function feedkeys(keys)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
-- end
--
-- local function pumvisible()
--   return tonumber(vim.fn.pumvisible()) ~= 0
-- end

-- map {
--   "i",
--   "<cr>",
--   function()
--     return pumvisible() and "<C-y>" or "<cr>"
--   end,
--   { expr = true, desc = "Completion confirm" },
-- }

-- Use <C-n> to navigate to the next completion or:
-- - Trigger LSP completion.
-- - If there's no one, fallback to vanilla omnifunc.

-- imap {
--   "<C-j>",
--   function()
--     if pumvisible() then
--       feedkeys "<C-n>"
--     else
--       -- feedkeys "<C-j>"
--       if next(vim.lsp.get_clients { bufnr = 0 }) then
--         vim.lsp.completion.trigger()
--       else
--         if vim.bo.omnifunc == "" then
--           feedkeys "<C-x><C-n>"
--         else
--           feedkeys "<C-x><C-o>"
--         end
--       end
--     end
--   end,
--   "select next completion",
-- }
--
-- imap {
--   "<C-k>",
--   function()
--     if pumvisible() then
--       feedkeys "<C-p>"
--     else
--       feedkeys "<C-k>"
--       -- if next(vim.lsp.get_clients { bufnr = 0 }) then
--       --   vim.lsp.completion.trigger()
--       -- else
--       -- if vim.bo.omnifunc == "" then
--       --   feedkeys "<C-x><C-p>"
--       -- else
--       --   feedkeys "<C-x><C-o>"
--       -- end
--       -- end
--     end
--   end,
--   "Trigger/select next completion",
-- }
--
-- imap {
--   "<C-space>",
--   function()
--     if pumvisible() then
--       feedkeys "<C-e>"
--     else
--       feedkeys "<C-x><C-o>"
--     end
--   end,
--   "Toggle completion",
-- }
--
-- map {
--   { "i", "x" },
--   "<C-l>",
--   function()
--     if pumvisible() then
--       feedkeys "<C-y>"
--     else
--       feedkeys "<C-e>"
--     end
--   end,
--   { desc = "Trigger/confirm completion" },
-- }
--
-- map {
--   { "i", "s" },
--   "<C-i>",
--   function()
--     if vim.snippet.active { direction = 1 } then
--       vim.schedule(function()
--         vim.snippet.jump(1)
--       end)
--     else
--       feedkeys "<C-i>"
--     end
--   end,
--   { desc = "Snippet jump forwards" },
-- }
--
-- -- prev position of snippet $x -> $x-1
-- map {
--   { "i", "s" },
--   "<C-S-i>",
--   function()
--     if vim.snippet.active { direction = -1 } then
--       vim.schedule(function()
--         vim.snippet.jump(-1)
--       end)
--     else
--       feedkeys "<C-S-i>"
--     end
--   end,
--   { desc = "Snippet jump backwards" },
-- }