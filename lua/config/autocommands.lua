-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 03 Dec 2023, 10:45
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

---General
---local _general_settings = augroup("_general_settings", { clear = true })

---FileTypes to exclude
---@param filetype string filetype to be matched
---@return boolean
local function filetypes_to_exclude(filetype)
  local special_ft = {
    alpha = true,
    WhichKey = true,
    NvimTree = true,
    lspinfo = true,
    TelescopePrompt = true,
    TelescopeResults = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    Outline = true,
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

  return special_ft[filetype]
end

---Set 'keywordprg' based on filetype
---@return string | nil
local function set_keywordprg(filetype)
  local custom_keywordprg = {
    python = 'python3 -m pydoc',
    vim = ':help',
    html = "open https://developer.mozilla.org/search?topic=api&topic=html&q=",
    css = "open https://developer.mozilla.org/search?topic=api&topic=css&q=",
    javascript = "open https://developer.mozilla.org/search?topic=api&topic=js&q="
  }

  return custom_keywordprg[filetype]
end


---Hightlight on yank
autocmd({ "TextYankPost" }, {
  -- group = augroup("_highlight_yank", { clear = true }),
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
  pattern = "*",
  callback = function(ev)

    if not filetypes_to_exclude(ev.match) then
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
    if ev.match and set_keywordprg(ev.match) then
      vim.opt_local.keywordprg = set_keywordprg(ev.match)
    end
    if ev.match and not filetypes_to_exclude(ev.match) then
      require("lib.compilers").set_compiler(ev)
    end
  end
})


---Jump to last < cursor-pos > in file
autocmd({ "BufRead" }, {
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
  command = 'startinsert'
})

---Start in insert mode in Git and toggleterm files
autocmd({ "FileType", "BufNewFile" }, {
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
    vim.api.nvim_buf_set_option(0, "filetype", "kitty")
    vim.api.nvim_buf_set_option(0, "comments", ":#,:#\\:")
    vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
  end
})

---Read PDF into neovim, using pdftotext binary
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

    require("lib.pdf").load_pdf(ev.file)
  end
})

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
local function scratch()
  vim.cmd.new()
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end

user_command("Scratch", function() scratch() end, { desc = "Create a Scratch buffer" })


---If buffer modified, update any 'Last modified: ' in the first 10 lines.
---Restores cursor and window position using save_cursor variable.
local function auto_timestamp()
  local autocmd_id = autocmd({ "BufWritePre" }, {
    pattern = "*",
    callback = function()
      if vim.opt_local.modified:get() == true then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)

        vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
        vim.fn.histdel("search", -1)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
    end
  })
  vim.g.auto_timestamp = autocmd_id
end

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

    auto_timestamp()
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

---Auto Remove trailing spaces before saving current buffer
local function auto_remove_trailing_spaces()
  local autocmd_id = autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd [[%s/\s\+$//e]]
      end
    end
  })
  vim.g.auto_remove_trail_spaces = autocmd_id
end

---User command to toggle auto trim trailing space on save
user_command("AutoTrimTrailingSpaces", function()
  local msg, log_level = nil, nil

  if vim.g.auto_remove_trail_spaces then
    vim.api.nvim_del_autocmd(vim.g.auto_remove_trail_spaces)
    vim.g.auto_remove_trail_spaces = nil

    msg = "  OFF"
    log_level = "WARN"
  else
    auto_remove_trailing_spaces()

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


---Delete Current Buffer (helper function for autocmd)
user_command("DeleteCurrentBuffer", function()
  local cBuf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo({ buflisted = true })
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
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\\zs')
  for _, v in pairs(regs) do
    vim.call('setreg', v, '')
  end
  vim.notify("All Registers wiped", vim.log.levels.INFO, { title = "Registers" })
end, { desc = "Wipe all Registers" })


-- Config File
user_command("NvimConfig", function()
  local has_telescope, telescope = pcall(require, "telescope")
  if not has_telescope then
    vim.cmd.edit "$NVIMDOTDIR"
  else
    telescope.extensions.file_browser.file_browser { cwd = "$NVIMDOTDIR" }
  end
end, { desc = "Neovim Config" })