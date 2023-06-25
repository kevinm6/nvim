-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 27 Jun 2023, 11:43
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

-- General
local _general_settings = augroup("_general_settings", { clear = true })

autocmd({ "FileType" }, {
   group = augroup("_q_exit", { clear = true }),
   pattern = {
      "qf",
      "help",
      "git*",
      "lspinfo",
      "tsplayground",
      "crunner",
      "man",
      "diff",
      "Scratch",
      "checkhealth",
      "sqls_output",
      "noice.log",
   },
   callback = function(ft)
      if ft.match == "man" or ft.match == "diff" then -- for man and diff exit on 'q'
         vim.keymap.set("n", "q", function()
            vim.cmd.quit { bang = true }
         end, { buffer = true, silent = true })
         vim.keymap.set("n", "<esc>", function()
            vim.cmd.quit { bang = true }
         end, { buffer = true, silent = true })
      else
         vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
         vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { buffer = true, silent = true })
      end
   end,
})

-- TODO: configure to display image w/ hologram (very-low priority)
--
-- autocmd({ "BufReadPre" }, {
--    group = augroup("_manage_pics", { clear = true }),
--    pattern = { "*.png", "*.jpg", "*.jpeg" },
--    callback = function(data)
--       local buf = vim.api.nvim_get_current_buf()
--       local match = data.match
--       -- vim.print(match)
--       local startline = -2
--       local endline = -1

--       if vim.endswith(match, "png") then
--          vim.api.nvim_buf_set_option(buf, "filetype", "png")
--       elseif vim.endswith(match, "jpeg") or vim.endswith(match, "jpg") then
--          vim.api.nvim_buf_set_option(buf, "filetype", "jpg")
--       end
--       vim.api.nvim_buf_set_lines(buf, startline, endline, false, "")
--    end,
-- })

-- autocmd({ "BufReadPre", "BufNewFile" }, {
--    group = augroup("_manage_folders", { clear = true }),
--    pattern = { "*.plist" },
--    callback = function(data)
--       vim.print(data)
--       local buf = vim.api.nvim_get_current_buf()
--       local match = data.match
--       local filetypes = {
--          plist = "xml",
--       }
--       if filetypes[match.match] then
--          vim.api.nvim_buf_set_option(buf, "filetype", filetypes[match.match])
--       end
--    end,
-- })

-- Hightlight on yank
autocmd({ "TextYankPost" }, {
   group = augroup("_highlight_yank", { clear = true }),
   pattern = "*",
   callback = function()
      vim.highlight.on_yank { higroup = "TextYankPost", timeout = 80, on_macro = true }
   end,
})

-- Statusline
autocmd({ "BufNewFile", "CursorMoved", "ModeChanged" }, {
   group = vim.api.nvim_create_augroup("_statusline", { clear = true }),
   pattern = "*",
   callback = function()
      vim.api.nvim_eval_statusline("%!v:lua.require'core.statusline'.get_statusline()", {})
      -- vim.wo.statusline = "%!v:lua.require'core.statusline'.get_statusline()"
   end,
})

-- WinBar
autocmd({ "CursorMoved", "ModeChanged" }, {
   group = augroup("_winbar", { clear = true }),
   callback = function()
      if not vim.api.nvim_win_get_config(0).relative ~= "" then -- disable on float windows
         vim.wo.winbar = require("core.winbar").get_winbar()
      end
   end,
})

-- If buffer modified, update any 'Last modified: ' in the first 10 lines.
-- Restores cursor and window position using save_cursor variable.
local auto_timestamp = function()
   autocmd({ "BufWritePre" }, {
      group = augroup("_update_timestamp", { clear = true }),
      pattern = "*",
      callback = function()
         if vim.opt_local.modified:get() == true then
            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
            vim.fn.histdel("search", -1)
            vim.api.nvim_win_set_cursor(0, cursor_pos)
         end
      end,
   })
end

auto_timestamp()

user_command("ToggleTimeStamp", function()
   local _autocmd_timestamp =
       vim.api.nvim_get_autocmds { group = "_update_timestamp", event = "BufWritePre", pattern = "*" }

   if vim.g.auto_timestamp and _autocmd_timestamp[1] then
      vim.api.nvim_del_autocmd(_autocmd_timestamp[1].id)
      vim.g.auto_timestamp = 0
      vim.notify("❌ TimeStamp update on save disabled.", vim.log.levels.INFO, { title = "Update file INFO" })
   else
      vim.g.auto_timestamp = 1
      auto_timestamp()
      vim.notify("✅ TimeStamp update on save enabled.", vim.log.levels.INFO, { title = "Update file INFO" })
   end
end, { desc = "Update TimeStamp on save" })

-- Jump to last < cursor-pos > in file
autocmd({ "BufRead" }, {
   group = augroup("_goto_last_pos", { clear = true }),
   callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
         pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
   end,
})

-- Set makeprg for filetype (using default compiler when available)
autocmd({ "FileType" }, {
   group = augroup("_set_makefile", { clear = true }),
   pattern = "*",
   callback = function(ev)
      local filetypes = {
         java = "javac",
         c = "gcc",
         rust = "rustc",
         lua = {
            prg = "nvim -l",
            efmt = "%f",
         },
         go = {
            prg = "go run",
            efmt = "%-G# %.%#, %A%f:%l:%c: %m, %A%f:%l: %m, %C%*\\s%m, %-G%.%#",
         },
         python = {
            prg = "python3",
            efmt = '%C %.%#,%A  File "%f"\\, line %l%.%#,%Z%[%^ ]%\\@=%m',
         },
         erlang = {
            prg = "erlc -Wall %:S",
            efmt = "%f:%l:%c: %m",
         },
      }
      if filetypes[ev.match] then
         if filetypes[ev.match].prg then
            vim.opt_local.makeprg = filetypes[ev.match].prg
            vim.opt_local.errorformat = filetypes[ev.match].efmt
         else
            vim.cmd.compiler(filetypes[ev.match])
         end
         vim.keymap.set("n", "<leader>RR", ":make %<CR>", { buffer = true, desc = "Compile Code" })
         vim.keymap.set({ "n", "v" }, "<leader>R", function() end, { buffer = true, desc = "Run" })
      end
   end,
})

-- Git
autocmd({ "FileType", "BufNewFile" }, {
   group = augroup("_edit_gitfiles", { clear = true }),
   pattern = { "gitcommit", "gitrebase" },
   callback = function()
      vim.cmd.startinsert()
   end,
})

-- Match FileTypes
vim.filetype.add {
   extension = {
      conf = "config",
   },
   pattern = {
      ["*.mdown"] = "markdown",
      ["*.mkd"] = "markdown",
      ["*.mkdn"] = "markdown",
      ["*.md"] = "markdown",
      ["*.psql*"] = "sql",
      ["README.(a+)$"] = function(_, _, ext)
         if ext == "md" then
            return "markdown"
         elseif ext == "rst" then
            return "rst"
         end
      end,
   },
}

-- Java
autocmd({ "BufWritePost" }, {
   pattern = { "*.java" },
   callback = function()
      vim.lsp.codelens.refresh()
   end,
})

-- Kitty conf files
autocmd({ "BufRead", "BufNewFile" }, {
   group = augroup("_kitty", { clear = true }),
   pattern = { "kitty.conf", "*/kitty/*.conf", "*/kitty/*.session" },
   callback = function()
      vim.api.nvim_buf_set_option(0, "filetype", "kitty")
      vim.api.nvim_buf_set_option(0, "comments", ":#,:#\\:")
      vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
   end,
})

-- PDF
autocmd({ "FileType" }, {
   group = augroup("_pdf_reader", { clear = true }),
   pattern = { "pdf", "PDF" },
   callback = function(ev)
      vim.api.nvim_buf_set_option(ev.buf, "readonly", true)
      if not vim.fn.executable "pdftotext" then
         vim.notify("vim-pdf: pdftotext is not found.\nStop converting...", vim.log.levels.ERROR)
         return
      end

      require "user_lib.pdf".load_pdf(ev.file)
   end,
})


-- Scratch
local Scratch = function()
   vim.cmd.new()
   vim.opt_local.buftype = "nofile"
   vim.opt_local.bufhidden = "wipe"
   vim.opt_local.buflisted = false
   vim.opt_local.swapfile = false
   vim.opt_local.filetype = "Scratch"
end

user_command("Scratch", Scratch, { desc = "Create a Scratch buffer" })

-- Note
local Note = function()
   vim.cmd.new()
   vim.opt_local.buftype = "nofile"
   vim.opt_local.bufhidden = "hide"
   vim.opt_local.buflisted = false
   vim.opt_local.swapfile = false
   vim.opt_local.filetype = "Note"
end

user_command("Note", Note, { desc = "Create a Note buffer" })

-- Remove trailing spaces
autocmd("BufWritePre", {
   pattern = "*",
   callback = function()
      if vim.opt_local.filetype:get() ~= "markdown" then
         vim.cmd [[%s/\s\+$//e]]
      end
   end,
})
user_command("RemoveTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

-- Delete Current Buffer (helper function for autocmd)
local delete_current_buffer = function()
   local cBuf = vim.api.nvim_get_current_buf()
   local bufs = vim.fn.getbufinfo { buflisted = true }
   if #bufs == 0 then
      return
   end

   for idx, b in ipairs(bufs) do
      if b.bufnr == cBuf then
         if idx == #bufs then
            vim.cmd.bprevious {}
         else
            vim.cmd.bnext {}
         end
         break
      end
   end
   vim.cmd.bdelete(cBuf)
end

user_command("DeleteCurrentBuffer", function()
   delete_current_buffer()
end, { desc = "Close current buffer and go to next" })

user_command("CheatSH", function(args)
   require("user_lib.cheatSH.cheat_sheet").run(args)
end, {
   nargs = "?",
   desc = "Cheat-Sheet",
   complete = "filetype",
})

-- compare changes in the current buffer with a related file on your disk,
-- before it will be saved, if Git does not track this file yet
-- @help :h usr_05.txt
user_command("DiffOrig", function()
   -- Get start buffer
   local start = vim.api.nvim_get_current_buf()

   -- `vnew` - Create empty vertical split window
   -- `set buftype=nofile` - Buffer is not related to a file, will not be written
   -- `0d_` - Remove an extra empty start row
   -- `diffthis` - Set diff mode to a new vertical split
   vim.cmd "vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis"

   -- Get scratch buffer
   local scratch = vim.api.nvim_get_current_buf()

   -- `wincmd p` - Go to the start window
   -- `diffthis` - Set diff mode to a start window
   vim.cmd "wincmd p | diffthis"

   -- Map `q` for both buffers to exit diff view and delete scratch buffer
   for _, buf in ipairs { scratch, start } do
      vim.keymap.set("n", "q", function()
         vim.api.nvim_buf_delete(scratch, { force = true })
         vim.keymap.del("n", "q", { buffer = start })
      end, { buffer = buf })
   end
end, {})

-- Hex Dump
user_command("HexToggle", function()
   require("user_lib.hex_handler.hex").setup {}
end, {})

user_command("LspCapabilities", function()
   require("user_lib.functions").get_current_buf_lsp_capabilities()
end, {})
