-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 12 Jun 2022, 16:04
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
	pattern = { "qf", "help", "man", "git", "lspinfo", "Scratch", "checkhealth", "sqls_output" },
	callback = function ()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
	end
})

autocmd({ "TextYankPost" }, {
	group = _general_settings,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 200, on_macro = true })
	end,
})

-- If buffer modified, update any 'Last modified: ' in the first 10 lines.
-- Restores cursor and window position using save_cursor variable.
autocmd({ "BufWritePre" }, {
  group = _general_settings,
  pattern = "*",
  callback = function()
    if vim.opt_local.modified._value == true then
      local cursor_pos = vim.api.nvim_win_get_cursor(0)

      vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
      vim.fn.histdel('search', -1)
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end,
})

local UpdateTimestamp = function()
  if vim.opt_local.modified._value == true then
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
    vim.fn.histdel('search', -1)
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end
command("UpdateTimestamp", UpdateTimestamp, { desc = "Update timestamp in file information" })

-- Autocommand for Statusline & WinBar
-- Using CursorMoved to nvim-gps
autocmd({ "CursorMoved", "BufWinEnter", "BufEnter" }, {
	group = augroup("Statusline", { clear = true, }),
	pattern = "*",
	callback = function()
    local special_ft = {
      ["alpha"] = true,
      ["NvimTree"] = true,
      ["packer"] = true,
      ["lsp-installer"] = true,
      ["lspinfo"] = true,
      ["Telescope"] = true,
      ["Trouble"] = true,
      ["qf"] = true,
      ["toggleterm"] = true,
    }
    if special_ft[vim.bo.filetype] then
      vim.wo.statusline = require("user.statusline").disabled()
      return
    end
		vim.wo.statusline = require("user.statusline").active()
	end,
})


-- TODO: Enable on NeoVim 0.8
-- autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost" }, {
--    callback = function()
--      local winbar_filetype_exclude = {
--        ["help"] = true,
--        ["dashboard"] = true,
--        ["packer"] = true,
--        ["NvimTree"] = true,
--        ["Trouble"] = true,
--        ["alpha"] = true,
--        ["Outline"] = true,
--        ["toggleterm"] = true,
--      }
--
--      if winbar_filetype_exclude[vim.bo.filetype] then
--        vim.opt_local.winbar = nil
--        return
--      end
--
--      vim.opt_local.winbar = require("user.winbar").gps() or require("user.winbar").filename() or nil
--
--    end,
--  })

autocmd("BufWritePost", {
 group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
 pattern = "*/nvim/lua/user/plugins.lua",
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

-- auto_resize
autocmd({ "VimResized" }, {
	group = augroup("_auto_resize", { clear = true }),
	pattern = "*",
	command = "tabdo wincmd",
})

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
