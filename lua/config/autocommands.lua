-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 26 May 2023, 10:12
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
      "DressingSelect",
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
autocmd({ "BufNewFile", "CursorMoved" }, {
   group = vim.api.nvim_create_augroup("_statusline", { clear = true }),
   pattern = "*",
   callback = function()
      vim.api.nvim_eval_statusline("%!v:lua.require'core.statusline'.get_statusline()", {})
      -- vim.wo.statusline = "%!v:lua.require'core.statusline'.get_statusline()"
   end,
})

-- WinBar
autocmd({ "CursorMoved" }, {
   group = augroup("_winbar", { clear = true }),
   callback = function()
      if not vim.api.nvim_win_get_config(0).relative ~= "" then -- disable on float windows
         vim.wo.winbar = require("core.winbar").get_winbar()
      end
   end,
})

-- Use null-ls for lsp-formatting
local lsp_formatting = function(bufnr)
   vim.lsp.buf.format {
      filter = function(client)
         return client.name == "null-ls"
      end,
      bufnr = bufnr,
   }
end

-- Format on save
local function format_on_save(buf, enable)
   local action = function()
      return enable and "Enabled" or "Disabled"
   end

   if enable then
      autocmd({ "BufWritePre" }, {
         group = augroup("_format_on_save", { clear = true }),
         pattern = "*",
         callback = function()
            lsp_formatting(buf)
         end,
      })
   else
      vim.api.nvim_clear_autocmds { group = "_format_on_save" }
   end

   vim.notify(action() .. " format on save", vim.log.levels.INFO, { title = "LSP" })
end

autocmd("LspAttach", {
   group = augroup("_Lsp_attach", { clear = true }),
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == "jdtls" then
         return
      end

      local has_telescope, telescope = pcall(require, "telescope.builtin")

      -- local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gl", function()
         vim.diagnostic.open_float()
      end, { buffer = args.buf, desc = "Open float" })
      vim.keymap.set("n", "K", function()
         vim.lsp.buf.hover()
      end, { buffer = args.buf })

      if client.server_capabilities.declarationProvider then
         vim.keymap.set("n", "gD", function()
            if has_telescope then
               telescope.lsp_declarations {}
            else
               vim.lsp.buf.declaration()
            end
         end, { buffer = args.buf, desc = "GoTo declaration" })
      end
      if client.server_capabilities.definitionProvider then
         vim.keymap.set("n", "gd", function()
            if has_telescope then
               telescope.lsp_definitions {}
            else
               vim.lsp.buf.definition()
            end
         end, { buffer = args.buf, desc = "GoTo definition" })
      end
      if client.server_capabilities.implementationProvider then
         vim.keymap.set("n", "gI", function()
            if has_telescope then
               telescope.lsp_incoming_calls {}
            else
               vim.lsp.buf.implementation()
            end
         end, { buffer = args.buf, desc = "GoTo implementation" })
      end
      if client.server_capabilities.referencesProvider then
         vim.keymap.set("n", "gr", function()
            if has_telescope then
               telescope.lsp_references {}
            else
               vim.lsp.buf.references()
            end
         end, { buffer = args.buf, desc = "GoTo references" })
      end
      -- if client.server_capabilities.referencesProvider then
      vim.keymap.set("n", "<leader>ll", function()
         vim.lsp.codelens.run()
      end, { buffer = args.buf, desc = "CodeLens Action" })
      -- end

      -- lsp-document_highlight
      if client.server_capabilities.documentHighlightProvider then
         local lsp_hi_doc_group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true })
         autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
            group = lsp_hi_doc_group,
            buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
            callback = function()
               vim.lsp.buf.document_highlight()
            end,
         })
         autocmd({ "BufEnter", "CursorMoved" }, {
            group = lsp_hi_doc_group,
            buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
            callback = function()
               vim.lsp.buf.clear_references()
            end,
         })
         -- TODO: must be implemented better
         -- else -- fallback w/ treesitter
         --    local lsp_hi_doc_group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true })
         --    autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
         --      group = lsp_hi_doc_group,
         --      buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
         --      callback = function()
         --          require "util.functions".ts_fallback_lsp_highlighting(args.buf)
         --      end
         --    })
         --    autocmd({ "BufEnter", "CursorMoved" }, {
         --      group = lsp_hi_doc_group,
         --      buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
         --      callback = function() vim.lsp.buf.clear_references() end
         --    })
      end

      -- Formatting
      if client.supports_method "textDocument/formatting" then
         user_command("LspToggleAutoFormat", function()
            if vim.fn.exists "#_format_on_save#BufWritePre" == 0 then
               format_on_save(args.buf, true)
            else
               format_on_save(args.buf)
            end
         end, {})

         user_command("Format", function()
            vim.lsp.buf.format()
         end, { force = true })

         vim.keymap.set("n", "<leader>lf", function()
            lsp_formatting(args.buf)
         end, { desc = "Format" })
         vim.keymap.set("n", "<leader>lF", function()
            vim.cmd.LspToggleAutoFormat()
         end, { desc = "Toggle AutoFormat" })
      end

      vim.keymap.set("n", "<leader>la", function()
         vim.lsp.buf.code_action()
      end, { buffer = args.buf, desc = "Code Action" })
      vim.keymap.set("n", "<leader>lI", function()
         vim.cmd.LspInfo {}
      end, { buffer = args.buf, desc = "Lsp Info" })
      vim.keymap.set("n", "<leader>lL", function()
         vim.cmd.LspLog {}
      end, { buffer = args.buf, desc = "Lsp Log" })
      vim.keymap.set("n", "<leader>r", function()
         vim.lsp.buf.rename()
      end, { buffer = args.buf, desc = "Rename" })
      vim.keymap.set("n", "<leader>lq", function()
         vim.diagnostic.setloclist()
      end, { buffer = args.buf, desc = "Lsp Diagnostics" })
      -- Diagnostics
      vim.keymap.set("n", "<leader>dj", function()
         vim.diagnostic.goto_next { buffer = args.buf }
      end, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "<leader>dk", function()
         vim.diagnostic.goto_prev { buffer = args.buf }
      end, { desc = "Prev Diagnostic" })
   end,
})

-- If buffer modified, update any 'Last modified: ' in the first 10 lines.
-- Restores cursor and window position using save_cursor variable.
local updateTimeStamp = autocmd({ "BufWritePre" }, {
   group = augroup("_update_timestamp", { clear = true }),
   pattern = "*",
   callback = function()
      if vim.opt_local.modified._value == true then
         local cursor_pos = vim.api.nvim_win_get_cursor(0)

         vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
         vim.fn.histdel("search", -1)
         vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
   end,
})

local autoTimeStampID = updateTimeStamp

user_command("ToggleTimeStamp", function()
   local au = vim.api.nvim_get_autocmds { group = _general_settings, event = "BufWritePre", pattern = "*" }
   if autoTimeStampID ~= nil and au[1] ~= nil then
      -- remove autocmd if exists and match w/ the one created
      --[[ print(au[1].id == toggleUpdateTimeStamp) ]]
      if au[1].id == autoTimeStampID then
         vim.api.nvim_del_autocmd(autoTimeStampID)
         autoTimeStampID = nil
         vim.notify("❌ TimeStamp update on save disabled.", vim.log.levels.INFO, { title = "Update file INFO" })
      end
   else
      autoTimeStampID = autocmd({ "BufWritePre" }, {
         group = augroup("_update_timestamp", { clear = true }),
         pattern = "*",
         callback = function()
            if vim.opt_local.modified._value == true then
               local cursor_pos = vim.api.nvim_win_get_cursor(0)

               vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
               vim.fn.histdel("search", -1)
               vim.api.nvim_win_set_cursor(0, cursor_pos)
            end
         end,
      })

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
         lua = {
            prg = "nvim -l",
            efmt = "%f",
         },
         go = {
            prg = "go run",
            efmt = "%-G# %.%#, %A%f:%l:%c: %m, %A%f:%l: %m, %C%*\\s%m, %-G%.%#"
         },
         python = {
            prg = "python3",
            efmt = "%C %.%#,%A  File \"%f\"\\, line %l%.%#,%Z%[%^ ]%\\@=%m"
         },
         erlang = {
            prg = "erlc -Wall %:S",
            efmt = "%f:%l:%c: %m"
         },
      }
      if filetypes[ev.match] then
         if filetypes[ev.match].prg then
            vim.opt_local.makeprg = filetypes[ev.match].prg
            vim.opt_local.errorformat = filetypes[ev.match].efmt
         else
            vim.cmd.compiler(filetypes[ev.match])
         end
        vim.api.nvim_buf_set_keymap(ev.buf, "n", '<leader>RR', ':make %<CR>', { desc = "Compile Code" })
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
      if not vim.bo.filetype == "markdown" then
         return
      end
      vim.cmd [[%s/\s\+$//e]]
   end,
})
user_command("RemoveTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

-- Delete Current Buffer (helper function for autocmd)
local DeleteCurrentBuffer = function()
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

user_command("DeleteCurrentBuffer", DeleteCurrentBuffer, { desc = "Close current buffer and go to next" })

user_command("CheatSH", function(args)
   require("util.cheatSH.cheat_sheet").run(args)
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
   require("util.hex.hex").setup {}
end, {})

user_command("LspCapabilities", function()
  require("util.functions").get_current_buf_lsp_capabilities()
end, {})
