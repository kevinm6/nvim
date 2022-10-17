-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 17 Oct 2022, 09:25
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

-- General
local _general_settings = augroup("_general_settings", {
  clear = true,
})

autocmd({ "FileType" }, {
  group = _general_settings,
  pattern = {
    "qf", "help", "man", "git", "lspinfo",
    "Scratch", "checkhealth", "sqls_output", "DressingSelect", "Jaq", "noice.log"
  },
  callback = function ()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end
})

autocmd({ "TextYankPost" }, {
  group = _general_settings,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 80, on_macro = true })
  end,
})


-- Autoreload modules
-- autocmd({ "BufWritePost" }, {
--   group = _general_settings,
--   pattern = { "*.lua" },
--   callback = function()
--     -- local file = vim.fn.expand "<afile>"
--     local fname = vim.fn.expand "%:r"

--     vim.notify(fname .. " reloaded! ", "Info", { title = "Modules" })
--   end
-- })


-- If buffer modified, update any 'Last modified: ' in the first 10 lines.
-- Restores cursor and window position using save_cursor variable.
local updateTimeStamp = autocmd({ "BufWritePre" }, {
  group = _general_settings,
  pattern = "*",
  callback = function()
    if vim.opt_local.modified._value == true then
      local cursor_pos = vim.api.nvim_win_get_cursor(0)

      vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
      vim.fn.histdel('search', -1)
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end
})

local autoTimeStampID = updateTimeStamp


command("ToggleTimeStamp",
  function()
    local au = vim.api.nvim_get_autocmds({ group = _general_settings, event = "BufWritePre", pattern = "*" })
    if (autoTimeStampID ~= nil and au[1] ~= nil) then
      -- remove autocmd if exists and match w/ the one created
      --[[ print(au[1].id == toggleUpdateTimeStamp) ]]
      if au[1].id == autoTimeStampID then
        vim.api.nvim_del_autocmd(autoTimeStampID)
        autoTimeStampID = nil
        vim.notify("❌ TimeStamp update on save disabled.", "Info", { title = "Update file INFO" })
      end
    else
      autoTimeStampID = autocmd({ "BufWritePre" }, {
        group = _general_settings,
        pattern = "*",
        callback = function()
          if vim.opt_local.modified._value == true then
            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
            vim.fn.histdel('search', -1)
            vim.api.nvim_win_set_cursor(0, cursor_pos)
          end
        end
      })

      vim.notify("✅ TimeStamp update on save enabled.", "Info", { title = "Update file INFO" })
    end
  end,
  { desc = "Update TimeStamp on save" }
)

-- Autocommand for Statusline & WinBar
-- Using CursorMoved to nvim-gps
autocmd({ "CursorMoved" }, {
  group = augroup("_statusline", { clear = true, }),
  pattern = "*",
  callback = function()
    vim.wo.statusline = "%!v:lua.require'user.statusline'.get_statusline()"
  end,
})

-- WinBar
autocmd({ "CursorMoved" }, {
  group = augroup("_winbar", { clear = true }),
  callback = function()
    local has_float_win, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
    if not has_float_win then
      require "user.winbar".get_winbar()
    end
  end,
})

autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("_packer_user_config", { clear = true }),
  pattern = "*/packer.lua",
  callback = function()
    vim.cmd "source <afile>"
    require("packer").compile()

    vim.notify(
      " Plugins file update & compiled !", "Info", {
        title = "Packer",
      })
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_markdown", { clear = true }),
  pattern = { "*.markdown", "*.mdown", "*.mkd", "*.mkdn", "*.md" },
  callback = function()
    vim.opt_local.filetype = "markdown"
  end,
})

-- Java
autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

-- SQL
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_sql", { clear = true }),
  pattern = "*.psql*",
  callback = function()
    vim.opt_local.filetype = "sql"
  end,
})

-- HACK: temporary disabled for `Noice` plugin
-- auto_resize
-- autocmd({ "VimResized" }, {
--   group = augroup("_auto_resize", { clear = true }),
--   pattern = "*",
--   callback = function() vim.cmd "tabdo wincmd" end,
-- })

-- Scratch
local Scratch = function()
  vim.api.nvim_command "new"
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end

command("Scratch", Scratch, { desc = "Create a Scratch buffer" })

-- Note
local Note = function()
  vim.api.nvim_command "new"
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "hide"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Note"
end

command("Note", Note, { desc = "Create a Note buffer" })

command("RemoveTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

local DeleteCurrentBuffer = function()
  local cBuf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo({buflisted = true})
  if #bufs == 0 then return end

  for idx, b in ipairs(bufs) do
    if b.bufnr == cBuf then
      if idx == #bufs then
        vim.cmd "bprevious"
      else
        vim.cmd "bnext"
      end
      break
    end
  end
  vim.cmd("bdelete "..cBuf)
end

command("DeleteCurrentBuffer", DeleteCurrentBuffer, { desc = "Close current buffer and go to next" })

