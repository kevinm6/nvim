-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 13 May 2024, 12:08
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
  cmp_menu = true,
  vim = true,
  oil = true,
  help = true,
  query = true,
  man = true,
  lazy_backdrop = true,
  cmp_docs = true,
}

--------------------------------
------- Auto-Commands ---------
--------------------------------

---Hightlight on yank
autocmd("TextYankPost", {
  group = augroup("_highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" then
      vim.highlight.on_yank { higroup = "TextYankPost", timeout = 80, on_macro = true }
      require("lib").shift_reg { val = vim.fn.getreg "0", typ = vim.fn.getregtype "0" }
    end
  end,
})

---Exit on q for some filetypes
autocmd("FileType", {
  group = augroup("_ft_quit_on_q", { clear = true }),
  pattern = {
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
    vim.bo[ev.buf].buflisted = false
    if ev.match ~= "man" and ev.match ~= "diff" then
      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
      vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
    else -- man and diff, quit NeoVim (useful when looking for man page from CLI)
      vim.keymap.set("n", "q", function()
        vim.cmd.quit { bang = true }
      end, { buffer = ev.buf, silent = true })
      vim.keymap.set("n", "<esc>", function()
        vim.cmd.quit { bang = true }
      end, { buffer = ev.buf, silent = true })
    end
  end,
})

---QuickFixList keymaps
autocmd("FileType", {
  group = augroup("_maps_qf_ft", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<C-l>", "<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "q", function()
      vim.cmd.quit { bang = true }
    end, { buffer = true, silent = true })
    vim.keymap.set("n", "<esc>", function()
      vim.cmd.quit { bang = true }
    end, { buffer = true, silent = true })
  end,
})

---Autocmd for `NNN` cli tools useful
--- to quit buffer used by it for help and similar things
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_ft_nnn_quit_on_q", { clear = true }),
  pattern = "/tmp/.nnn*",
  callback = function()
    vim.keymap.set("n", "q", function()
      vim.cmd.quit { bang = true }
    end, { buffer = true, silent = true })
    vim.keymap.set("n", "<esc>", function()
      vim.cmd.quit { bang = true }
    end, { buffer = true })
  end,
})

---Check if want to install Treesitter parser for current
---filetype if missing
autocmd("FileType", {
  group = augroup("_check_ft_ts_parser", { clear = true }),
  pattern = "*",
  callback = function(ev)
    if not filetypes_to_exclude[ev.match] then
      local has_ts, ts_parsers = pcall(require, "nvim-treesitter.parsers")
      if not has_ts then
        return
      end

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
  end,
})

---Set makeprg and keywordprg for filetype (using default compiler when available)
autocmd("FileType", {
  group = augroup("_set_makefile", { clear = true }),
  pattern = "*",
  callback = function(ev)
    local lib_compiler = require "lib.compiler"
    if ev.match and lib_compiler.set_keywordprg(ev.match) then
      vim.opt_local.keywordprg = lib_compiler.set_keywordprg(ev.match)
    end
    if ev.match and not filetypes_to_exclude[ev.match] then
      lib_compiler.set_compiler(ev)
    end
  end,
})

---Jump to last < cursor-pos > in file
autocmd("BufRead", {
  group = augroup("_buf_last_cursor_pos", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

---Insert mode on builtin Neovim terminal
autocmd("TermOpen", {
  group = augroup("_startinsert_term_open", { clear = true }),
  command = "startinsert",
})

---Start in insert mode in Git and toggleterm files
autocmd({ "FileType", "BufNewFile" }, {
  group = augroup("_startinsert_git_files", { clear = true }),
  pattern = { "gitcommit", "gitrebase", "toggleterm" },
  command = "startinsert",
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
    PNG = "image_nvim",
    JPG = "image_nvim",
    JPEG = "image_nvim",
    GIF = "image_nvim",
    WEBP = "image_nvim",
    -- md = "quarto",
    ipynb = "jupyter_notebook",
    dat = "xxd",
  },
  pattern = {
    ["*.python"] = "python",
    ["*.psql*"] = "sql",
    ["*.plist*"] = "xml",
    ["README.(a+)$"] = function(_, _, ext)
      return (ext == "md") and "markdown" or (ext == "rst") and "rst" or "text"
    end,
  },
}

---Kitty conf files
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("_kitty", { clear = true }),
  pattern = { "*/kitty/*.conf" },
  callback = function()
    vim.api.nvim_set_option_value("filetype", "kitty", { buf = 0 })
    vim.api.nvim_set_option_value("comments", ":#,:#\\:", { buf = 0 })
    vim.api.nvim_set_option_value("commentstring", "# %s", { buf = 0 })
  end,
})

---Read PDF into neovim, using pdftotext binary
autocmd("FileType", {
  group = augroup("_pdf_reader", { clear = true }),
  pattern = { "pdf", "PDF" },
  callback = function(ev)
    vim.api.nvim_set_option_value("readonly", true, { buf = ev.buf })
    if not vim.fn.executable "pdftotext" then
      vim.notify("vim-pdf: pdftotext is not found.\nStop converting...", vim.log.levels.ERROR)
      return
    end
    require("lib.pdf").load_pdf(ev.file)
  end,
})

---Hex
autocmd("FileType", {
  group = augroup("_hex_files", { clear = true }),
  pattern = { "xxd", "stata", "bin" },
  callback = function()
    require("lib.hex").setup()
  end,
})

--------------------------------
------- User-Commands ---------
--------------------------------

---Create NewFile
user_command("NewFile", function(args)
  require("lib").new_file(args)
end, {
  desc = "Create new File",
  nargs = "?",
  complete = "filetype",
})

---Create NewTempFile
user_command("NewTempFile", function(args)
  require("lib").new_tmp_file(args)
end, {
  desc = "Create new temp File",
  nargs = "?",
  complete = "filetype",
})

---Scratch
user_command("Scratch", function()
  vim.cmd.new()
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end, { desc = "Create a Scratch buffer" })

---Update `Last Modified` date if found in first 10 row of file
user_command("ToggleAutoTimeStamp", function()
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

  vim.notify(msg, vim.log.levels[log_level], {
    render = "wrapped-compact",
    title = "Auto Update TimeStamp",
  })
end, { desc = "Update TimeStamp on save" })

---Trim extra trailing spaces in current buffer
user_command("TrimTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

---User command to toggle auto trim trailing space on save
user_command("ToggleAutoTrimTrailingSpaces", function()
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

  vim.notify(msg, vim.log.levels[log_level], {
    render = "wrapped-compact",
    title = "Auto Remove trailing spaces",
  })
end, { desc = "Remove extra trailing white spaces" })

---Query CheatSH and get output in window
user_command("CheatSH", function(args)
  require("lib.cheat_sheet").run(args)
end, {
  nargs = "?",
  desc = "Cheat-Sheet",
  complete = "filetype",
})

---Wipe all Registers
user_command("WipeReg", function()
  local regs = vim.fn.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', "\\zs") or {}
  for _, v in pairs(regs) do
    vim.call("setreg", v, "")
  end
  vim.notify("All Registers wiped", vim.log.levels.INFO, { title = "Registers" })
end, { desc = "Wipe all Registers" })

---Sessions
user_command("Session", function(arg)
  require("lib.session").select(arg.args)
end, {
  nargs = 1,
  desc = "Session Manager",
  complete = "custom,v:lua.require'lib.session'.usercmd_session_completion",
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

---University
user_command("Notes", function()
  require("lib.notes").open_note()
end, { desc = "Open notes" })

---Export to PDF
user_command("TOpdf", function()
  require("lib.pdf").convert_md_to_pdf()
end, { desc = "Export markdown to pdf" })