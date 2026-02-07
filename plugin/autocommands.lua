-------------------------------------
-- title: autocommands.lua
-- abstract: Autocommands config
-- author: Kevin
-- date: 31 Dec 2025, 09:17
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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

---Autocmd for jupyter-notebook
autocmd("BufReadCmd", {
  group = augroup("jupytext-nvim", { clear = true }),
  pattern = { "*.ipynb" },
  callback = function(ev)
    require("lib.jupytext").start(ev)
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

---Equalize windows on resizing
autocmd("VimResized", {
  group = augroup("_vim_w_resizing", { clear = true }),
  command = "wincmd =",
})


---Enable auto-timestamp by default on defined filetypes
autocmd("VimEnter", {
  once = true,
  callback = function()
    require("lib.automation").auto_timestamp()
  end
})

---Insert mode on builtin Neovim terminal
-- autocmd("TermOpen", {
--   group = augroup("_startinsert_term_open", { clear = true }),
--   callback = function(ev)
--     vim.cmd.startinsert()
--     vim.bo[ev.buf].filetype = "terminal"
--   end,
-- })

---Start in insert mode in Git and toggleterm files
autocmd({ "FileType", "BufNewFile" }, {
  group = augroup("_startinsert_git_files", { clear = true }),
  pattern = { "gitcommit", "gitrebase" },
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
    ipynb = "jupyter_notebook",
    dat = "xxd",
    nl = "neverlang",
    ftl = "freemarker"
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

---Gradle
---setup gradle tasks cmd
autocmd("VimEnter", {
  group = augroup("_gradle_setup_autocmd", { clear = true }),
  callback = function()
    local root_dir = vim.fs.root(0, { "build.gradle", "gradlew", ".gradlew", "gradle/" })
    if root_dir then
      require("lib.gradle").setup { root_dir = root_dir }
    end
  end
})