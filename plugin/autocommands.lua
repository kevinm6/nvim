-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 18 Jul 2024, 09:57
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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
  ["dap-float"] = true,
  dapui_hover = true,
}

--------------------------------
------- Auto-Commands ---------
--------------------------------

---Statusline&Winbar
-- if not vim.g.vscode then
--   autocmd("VimEnter", {
--     group = augroup("_statusline_and_winbar", { clear = true }),
--     callback = function()
--       require("lib.ui.statusline").toggle()
--       require("lib.ui.winbar").toggle()
--     end,
--     -- once = true
--   })
-- end

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
    "dap-float",
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

autocmd("FileType", {
  group = augroup("_autocmd_statuscolumn", { clear = true }),
  callback = function(ev)
    if not filetypes_to_exclude[ev.match] then
      vim.opt_local.statuscolumn = "%s%{v:relnum?v:relnum:v:lnum}%=%C "
    else
      vim.opt_local.statuscolumn = ""
    end
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
-- autocmd("FileType", {
--   group = augroup("_set_makefile", { clear = true }),
--   pattern = "*",
--   callback = function(ev)
--     local lib_compiler = require "lib.compiler"
--     if ev.match and lib_compiler.set_keywordprg(ev.match) then
--       vim.opt_local.keywordprg = lib_compiler.set_keywordprg(ev.match)
--     end
--     if ev.match and not filetypes_to_exclude[ev.match] then
--       lib_compiler.set_compiler(ev)
--     end
--   end,
-- })

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
  callback = function()
    vim.cmd.startinsert()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
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

---Start postgresql service on sql files
-- autocmd("FileType", {
--   group = augroup("_postres_service", { clear = true }),
--   pattern = { "sql" },
--   once = true, -- don't run again on other sql files
--   callback = function()
--     require("lib").run_brew_service("postgresql@14", false)
--   end,
-- })

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

---Templates
autocmd("BufNewFile", {
  group = augroup("templates", { clear = true }),
  desc = "Load template file",
  pattern = { "pom.xml", "*.md", "*.sh" },
  callback = function(args)
    local path = vim.fn.stdpath "config"
    local fname = vim.fn.fnamemodify(args.file, ":t")
    local ext = vim.fn.fnamemodify(args.file, ":e")
    local candidates = { fname, ext }
    local uv = vim.uv
    -- vim.print(candidates)
    for _, candidate in ipairs(candidates) do
      local tmpl = table.concat { path, "/templates/", candidate, ".tpl" }
      if uv.fs_stat(tmpl) then
        vim.cmd("0r " .. tmpl)
        return
      end
    end
    for _, candidate in ipairs(candidates) do
      local tmpl = table.concat { path, "/templates/", candidate, ".stpl" }
      local f = io.open(tmpl, "r")
      if f then
        local content = f:read "*a"
        -- NOTE: the schedule avoid running earlier and mess with outher autocommands
        vim.schedule(function()
          vim.snippet.expand(content)
        end)
        return
      end
    end
  end,
})

---Lsp progress
autocmd("LspProgress", {
  group = augroup("_lsp_progress", { clear = true }),
  callback = function()
    local lsp = vim.lsp.status()
    if lsp then
      print(lsp)
    end
  end,
})
