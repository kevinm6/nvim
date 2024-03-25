-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 25 Mar 2024, 13:04
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

---General
---local _general_settings = augroup("_general_settings", { clear = true })

---FileTypes to exclude
local filetypes_to_exclude = {
  alpha = true,
  WhichKey = true,
  lspinfo = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  qf = true,
  toggleterm = true,
  lazy = true,
  mason = true,
  noice = true,
  checkhealth = true,
  notify = true,
  cmpmenu = true,
  vim = true,
  oil = true,
  help = true,
  query = true,
  man = true
}

--------------------------------
------- Auto-Commands ---------
--------------------------------

---Hightlight on yank
autocmd({ "TextYankPost" }, {
  group = augroup("_highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "TextYankPost", timeout = 80, on_macro = true }
  end
})


if not vim.g.vscode then
  ---Statusline
  require "config.statusline".toggle()

  ---WinBar
  require "config.winbar".toggle()
end


---Exit on q for some filetypes
autocmd("FileType", {
  group = augroup("_ft_quit_on_q", { clear = true }),
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
  callback = function(ev)
    if ev.match ~= "man" and ev.match ~= "diff" then -- for man and diff exit on 'q'
      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
      vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { buffer = true, silent = true })
    else
      vim.keymap.set("n", "q", function()
        vim.cmd.quit { bang = true }
      end, { buffer = true, silent = true })
      vim.keymap.set("n", "<esc>", function()
        vim.cmd.quit { bang = true }
      end, { buffer = true, silent = true })
    end
  end
})


---Check if want to install Treesitter parser for current
---filetype if missing
autocmd({ "FileType" }, {
  group = augroup("_check_ft_ts_parser", { clear = true }),
  pattern = "*",
  callback = function(ev)
    if not filetypes_to_exclude[ev.match] then
      local has_ts, ts_parsers = pcall(require, "nvim-treesitter.parsers")
      if not has_ts then return end

      local lang = ts_parsers.get_buf_lang()
      local donot_ask_install = vim.g.dont_ask_install or {}
      if
          ts_parsers.get_parser_configs()[lang]
          and not ts_parsers.has_parser(lang)
          and not donot_ask_install[lang] == true
      then
        vim.schedule_wrap(function()
          local msg = string.format("Install missing TS parser for < %s >?", lang)
          local choice = vim.fn.confirm(msg, "&Yes\n&No")

          if choice == 1 then
            vim.cmd.TSInstall(lang)
          else
            donot_ask_install[lang] = true
            vim.g.dont_ask_install = donot_ask_install
          end
        end)()
      end
    end
  end
})


---Set makeprg and keywordprg for filetype (using default compiler when available)
autocmd({ "FileType" }, {
  group = augroup("_set_makefile", { clear = true }),
  pattern = "*",
  callback = function(ev)
    local lib_utils = require "lib.utils"
    if ev.match and lib_utils.set_keywordprg(ev.match) then
      vim.opt_local.keywordprg = lib_utils.set_keywordprg(ev.match)
    end
    if ev.match and not filetypes_to_exclude[ev.match] then
      require("lib.compiler").set_compiler(ev)
    end
  end
})


---Jump to last < cursor-pos > in file
autocmd({ "BufRead" }, {
  group = augroup("_buf_last_cursor_pos", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end
})


---Insert mode on builtin Neovim terminal
autocmd({ "TermOpen" }, {
  group = augroup("_startinsert_term_open", { clear = true }),
  command = 'startinsert'
})

---Start in insert mode in Git and toggleterm files
autocmd({ "FileType", "BufNewFile" }, {
  group = augroup("_startinsert_git_files", { clear = true }),
  pattern = { "gitcommit", "gitrebase", "toggleterm" },
  command = 'startinsert'
})

---Match FileTypes
vim.filetype.add {
  extension = {
    conf = "config",
    png = "image_nvim",
    jpg = "image_nvim",
    jpeg = "image_nvim",
    gif = "image_nvim",
    webp = "image_nvim",
    -- md = "quarto",
    ipynb = "jupyter_notebook",
    dat = "xxd"
  },
  pattern = {
    ["*.python"] = "python",
    ["*.mdown"] = "markdown",
    ["*.mkd"] = "markdown",
    ["*.mkdn"] = "markdown",
    ["*.md"] = "markdown",
    ["*.psql*"] = "sql",
    ["*.plist*"] = "xml",
    ["README.(a+)$"] = function(_, _, ext)
      return (ext == "md") and "markdown"
          or (ext == "rst") and "rst" or "text"
    end
  }
}

---Kitty conf files
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("_kitty", { clear = true }),
  pattern = { "kitty.conf", "*/kitty/*.conf", "*/kitty/*.session" },
  callback = function()
    vim.api.nvim_set_option_value("filetype", "kitty", { buf = 0 })
    vim.api.nvim_set_option_value("comments", ":#,:#\\:", { buf = 0 })
    vim.api.nvim_set_option_value("commentstring", "# %s", { buf = 0 })
  end
})

---Read PDF into neovim, using pdftotext binary
autocmd({ "FileType" }, {
  group = augroup("_pdf_reader", { clear = true }),
  pattern = { "pdf", "PDF" },
  callback = function(ev)
    vim.api.nvim_set_option_value("readonly", true, { buf = ev.buf })
    if not vim.fn.executable "pdftotext" then
      vim.notify(
        "vim-pdf: pdftotext is not found.\nStop converting...",
        vim.log.levels.ERROR
      )
      return
    end
    require("lib.pdf").load_pdf(ev.file)
  end
})


--------------------------------
------- User-Commands ---------
--------------------------------

---Create NewFile
user_command("NewFile", function(args) require("lib.utils").new_file(args) end, {
  desc = "Create new File",
  nargs = "?",
  complete = "filetype",
})

---Create NewTempFile
user_command("NewTempFile", function(args) require("lib.utils").new_tmp_file(args) end, {
  desc = "Create new temp File",
  nargs = "?",
  complete = "filetype",
})


---Scratch
user_command("Scratch", function ()
  vim.cmd.new()
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end, { desc = "Create a Scratch buffer" })


user_command("AutoTimeStamp", function()
  local msg, log_level = nil, nil

  if vim.g.auto_timestamp then
    vim.api.nvim_del_autocmd(vim.g.auto_timestamp)
    vim.g.auto_timestamp = nil

    msg = "  OFF"
    log_level = "WARN"
  else
    msg = "  ON"
    log_level = "INFO"

    require("lib.automation").auto_timestamp()
  end

  vim.notify(
    msg,
    vim.log.levels[log_level],
    {
      render = "wrapped-compact",
      title = "Auto Update TimeStamp"
    }
  )
end, { desc = "Update TimeStamp on save" })

---Trim extra trailing spaces in current buffer
user_command("TrimTrailingSpaces",
  [[%s/\s\+$//e]]
  , { desc = "Remove extra trailing white spaces" })

---User command to toggle auto trim trailing space on save
user_command("AutoTrimTrailingSpaces", function()
  local msg, log_level = nil, nil

  if vim.g.auto_remove_trail_spaces then
    vim.api.nvim_del_autocmd(vim.g.auto_remove_trail_spaces)
    vim.g.auto_remove_trail_spaces = nil

    msg = "  OFF"
    log_level = "WARN"
  else
    require("lib.automation").auto_remove_trailing_spaces()

    msg = "  ON"
    log_level = "INFO"
  end

  vim.notify(
    msg,
    vim.log.levels[log_level],
    {
      render = "wrapped-compact",
      title = "Auto Remove trailing spaces"
    }
  )
end, { desc = "Remove extra trailing white spaces" })

---Query CheatSH and get output in window
user_command("CheatSH", function(args)
  require("lib.cheat_sheet").run(args)
end, {
  nargs = "?",
  desc = "Cheat-Sheet",
  complete = "filetype",
})

---Compare changes in the current buffer with a related file on your disk,
--- before it will be saved, if Git does not track this file yet
---@see help | :h usr_05.txt |
user_command("DiffOrig", function()
  ---Get start buffer
  local start = vim.api.nvim_get_current_buf()

  ---`vnew` - Create empty vertical split window
  ---`set buftype=nofile` - Buffer is not related to a file, will not be written
  ---`0d_` - Remove an extra empty start row
  ---`diffthis` - Set diff mode to a new vertical split
  vim.cmd "vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis"

  ---Get scratch buffer
  local scratch_buf = vim.api.nvim_get_current_buf()

  ---`wincmd p` - Go to the start window
  ---`diffthis` - Set diff mode to a start window
  vim.cmd "wincmd p | diffthis"

  ---Map `q` for both buffers to exit diff view and delete scratch buffer
  for _, buf in ipairs { scratch_buf, start } do
    vim.keymap.set("n", "q", function()
      vim.api.nvim_buf_delete(scratch_buf, { force = true })
      vim.keymap.del("n", "q", { buffer = start })
    end, { buffer = buf })
  end
end, {})

---Hex Dump
user_command("HexToggle", function()
  require "lib.hex".setup()
end, {})

autocmd({ "FileType" }, {
  group = augroup("_hex_files", { clear = true }),
  pattern = "xxd",
  callback = function()
    require "lib.hex".setup()
  end
})

---Wipe all Registers
user_command("WipeReg", function()
  local regs = vim.fn.split(
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\\zs') or {}
  for _, v in pairs(regs) do
    vim.call('setreg', v, '')
  end
  vim.notify("All Registers wiped", vim.log.levels.INFO, { title = "Registers" })
end, { desc = "Wipe all Registers" })


---Sessions
user_command("Session", function(arg)
  require "lib.session".select(arg.args)
end, {
  nargs = 1,
  desc = "Session Manager",
  complete = "custom,v:lua.require'lib.session'.usercmd_session_completion"
})


---Config File
user_command("NvimConfig", function()
  local has_telescope, tele_builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    vim.cmd.edit "$NVIMDOTDIR"
  else
    tele_builtin.find_files { cwd = "$NVIMDOTDIR" }
  end
end, { desc = "Neovim Config" })

---Dotfiles
user_command("Dotfiles", function()
  local has_oil, oil = pcall(require, "oil")
  local dotfiles_dir = vim.env.DOTFILES or vim.fn.expand "~/.MacDotfiles"
  if not has_oil then
    vim.cmd.edit(dotfiles_dir)
  else
    oil.open_float(dotfiles_dir)
  end
end, { desc = "Open Dotfiles dir" })

---University
user_command("University", function()
  local has_oil, oil = pcall(require, "oil")
  local university_dir = vim.env.CS or vim.fn.expand "~/Informatica/"
  if not has_oil then
    vim.cmd.edit(university_dir)
  else
    oil.open_float(university_dir)
  end
end, { desc = "Open Dotfiles dir" })