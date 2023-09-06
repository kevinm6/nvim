-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 23 Sep 2023, 18:22
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

-- General
-- local _general_settings = augroup("_general_settings", { clear = true })

--- FileTypes to exclude
--- @param filetype string filetype to be matched
--- @return boolean
local filetypes_to_exclude = function(filetype)
   local special_ft = {
      alpha = true,
      WhichKey = true,
      NvimTree = true,
      lspinfo = true,
      TelescopePrompt = true,
      TelescopeResults = true,
      Trouble = true,
      qf = true,
      toggleterm = true,
      lazy = true,
      crunner = true,
      mason = true,
      Outline = true,
      noice = true,
      checkhealth = true,
      notify = true,
      cmpmenu = true,
      vim = true,
      oil = true,
      help = true,
   }

   return special_ft[filetype]
end

--- Set 'keywordprg' based on filetype
---@return string | nil
local set_keywordprg = function(filetype)
   local custom_keywordprg = {
      python = 'python3 -m pydoc',
      vim = ':help',
      html = "open https://developer.mozilla.org/search?topic=api&topic=html&q=",
      css = "open https://developer.mozilla.org/search?topic=api&topic=css&q=",
      javascript = "open https://developer.mozilla.org/search?topic=api&topic=js&q="
   }

   return custom_keywordprg[filetype]
end


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

-- Hightlight on yank
autocmd({ "TextYankPost" }, {
   group = augroup("_highlight_yank", { clear = true }),
   pattern = "*",
   callback = function()
      vim.highlight.on_yank { higroup = "TextYankPost", timeout = 80, on_macro = true }
   end,
})

-- Insert mode on Terminal buffers
autocmd({ "TermOpen" }, {
   group = augroup("_terminal_open", { clear = true }),
   -- pattern = "*",
   callback = function()
      vim.cmd.startinsert()
   end,
})

-- Statusline
autocmd(
   {
      "BufNewFile",
      "CursorMoved",
      "ModeChanged",
      "VimResized",
      "FileType",
      "FileChangedShellPost",
   },
   {
      group = vim.api.nvim_create_augroup("_statusline", { clear = true }),
      pattern = "*",
      callback = function()
         vim.api.nvim_eval_statusline(
            "%!v:lua.require'core.statusline'.get_statusline()",
            {}
         )
         -- vim.wo.statusline = "%!v:lua.require'core.statusline'.get_statusline()"
      end,
   }
)

-- WinBar
autocmd({ "CursorMoved", "ModeChanged" }, {
   group = augroup("_winbar", { clear = true }),
   callback = function()
      -- disable on float windows
      if
         not vim.api.nvim_win_get_config(0).relative ~= ""
         and not filetypes_to_exclude(vim.bo.filetype)
      then
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

user_command("ToggleTimeStamp", function()
   local _autocmd_timestamp = vim.api.nvim_get_autocmds {
      group = "_update_timestamp",
      event = "BufWritePre",
      pattern = "*",
   }

   if vim.g.auto_timestamp and _autocmd_timestamp[1] then
      vim.api.nvim_del_autocmd(_autocmd_timestamp[1].id)
      vim.g.auto_timestamp = 0
      vim.notify(
         "🔴 TimeStamp update on save disabled.",
         vim.log.levels.INFO,
         { title = "Update file INFO" }
      )
   else
      vim.g.auto_timestamp = 1
      auto_timestamp()
      vim.notify(
         "🟢 TimeStamp update on save enabled.",
         vim.log.levels.INFO,
         { title = "Update file INFO" }
      )
   end
end, { desc = "Update TimeStamp on save" })


-- Check if want to install Treesitter parser for current
-- filetype if missing
autocmd({ "FileType" }, {
   group = augroup("_ensureTSparsers", { clear = true }),
   pattern = "*",
   callback = function(ev)
      if filetypes_to_exclude(ev.match) then return end

      local has_ts, ts_parsers = pcall(require, "nvim-treesitter.parsers")
      if not has_ts then return end

      local lang = ts_parsers.get_buf_lang()
      local donot_ask_install = vim.g.ask_install or {}
      if
         ts_parsers.get_parser_configs()[lang]
         and not ts_parsers.has_parser(lang)
         and not donot_ask_install[lang] == true
      then
         vim.schedule_wrap(function()
            local msg = ("Install missing TS parser for < %s >?"):format(lang)
            local choice = vim.fn.confirm(msg, "&Yes\n&No")

            if choice == 1 then
               vim.cmd("TSInstall " .. lang)
            else
               donot_ask_install[lang] = true
               vim.g.donot_ask_install = donot_ask_install
            end
         end)()
      end
   end,
})

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

-- Set makeprg and keywordprg for filetype (using default compiler when available)
autocmd({ "FileType" }, {
   group = augroup("_set_makefile", { clear = true }),
   pattern = "*",
   callback = function(ev)
      if ev.match and set_keywordprg(ev.match) then
         vim.opt_local.keywordprg = set_keywordprg(ev.match)
      end
      if ev.match and not filetypes_to_exclude(ev.match) then
         require("user_lib.compilers").set_compiler(ev)
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
      ["*.plist*"] = "xml",
      ["README.(a+)$"] = function(_, _, ext)
         if ext == "md" then
            return "markdown"
         elseif ext == "rst" then
            return "rst"
         end
      end,
   },
}

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
         vim.notify(
            "vim-pdf: pdftotext is not found.\nStop converting...",
            vim.log.levels.ERROR
         )
         return
      end

      require("user_lib.pdf").load_pdf(ev.file)
   end,
})

-- NewFile & NewTempFile
user_command("NewFile", function() require("user_lib.functions").new_file() end, {
  desc = "Create new File"
})
user_command("NewTempFile", function() require("user_lib.functions").new_tmp_file() end, {
  desc = "Create new temp File"
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

-- user_command("RemoveTrailingSpaces", function()
--    [[%s/\s\+$//e]]
-- end, { desc = "Remove extra trailing white spaces" })
local auto_remove_trailing_spaces = function()
   -- Remove trailing spaces
   autocmd("BufWritePre", {
      pattern = "*",
      callback = function()
         if vim.bo.filetype ~= "markdown" then
            vim.cmd [[%s/\s\+$//e]]
         end
      end,
   })
end

user_command("AutoRemoveTrailingSpaces", function()
   local _autocmd_remove_trailing_spaces = vim.api.nvim_get_autocmds {
      group = "_remove_trailing_spaces",
      event = "BufWritePre",
      pattern = "*",
   }

   if vim.g.auto_remove_trailing_spaces and _autocmd_remove_trailing_spaces[1] then
      vim.api.nvim_del_autocmd(_autocmd_remove_trailing_spaces[1].id)
      vim.g.auto_remove_trailing_spaces = 0
      vim.notify(
         "🔴 Auto-remove trailing spaces on save disabled.",
         vim.log.levels.INFO,
         { title = "Remove trailing spaces" }
      )
   else
      vim.g.auto_remove_trailing_spaces = 1
      auto_remove_trailing_spaces()
      vim.notify(
         "🟢 Auto-remove trailing spaces on save enabled.",
         vim.log.levels.INFO,
         { title = "Remove trailing spaces" }
      )
   end
end, { desc = "Remove extra trailing white spaces" })

autocmd({ "VimEnter" }, {
   pattern = "*",
   callback = function()
      auto_timestamp()
      auto_remove_trailing_spaces()
   end,
})

-- Delete Current Buffer (helper function for autocmd)
user_command("DeleteCurrentBuffer", function()
   local cBuf = vim.api.nvim_get_current_buf()
   local bufs = vim.fn.getbufinfo { buflisted = true }
   if #bufs == 0 then
      return
   end

   for idx, buf in ipairs(bufs) do
      if buf.bufnr == cBuf then
         if idx == #bufs then
            vim.cmd.bprevious {}
         else
            vim.cmd.bnext {}
         end
         break
      end
   end
   vim.cmd.bdelete(cBuf)
end, { desc = "Close current buffer and go to next" })

user_command("CheatSH", function(args)
   require("user_lib.cheat_sheet").run(args)
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

user_command("WipeReg", function()
   local regs = vim.fn.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\\zs')
   for _, v in pairs(regs) do
      vim.call('setreg', v, '')
   end
   vim.notify("All Registers wiped", vim.log.levels.INFO, { title = "Registers" })
end, { desc = "Wipe all Registers" })
