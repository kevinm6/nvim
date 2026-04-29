------------------------------------
-- title: prefs.lua
-- abstract: NeoVim & VimR preferences
-- author: Kevin
-- date: 29 Apr 2026, 20:42
-------------------------------------

local settings = {
  path = "**",
  -- CURSOR
  guicursor = {
    "n-v-c:block",
    "i-ci-ve:ver25",
    "r-cr:hor20,o:hor50",
  },

  -- MOUSE
  mouse = "vnc",
  fileencoding = "utf-8",

  -- GRAPHIC
  termguicolors = true,
  laststatus = 3,
  guifont = "Fira Code:h12.5,Symbols Nerd Font Mono:13",
  number = true,
  relativenumber = true,
  showmode = false,
  scrolloff = 4,
  sidescrolloff = 10,
  matchtime = 2,
  visualbell = false,
  cursorline = true,
  showtabline = 1,
  tabclose = "uselast",
  showmatch = true,
  signcolumn = "yes",
  cmdheight = 1,
  pumheight = 10,
  pumblend = 2,
  pummaxwidth = 80,
  splitbelow = true,
  splitright = true,
  updatetime = 100,
  updatecount = 0,
  listchars = { tab = "⇥ ", eol = "↲", trail = "~", space = "_", nbsp = "␣" },
  fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "❭", diff = " " },
  timeoutlen = 350,
  ttimeoutlen = 100,
  -- autocomplete = true, -- NOTE: till nvim supports custom snippets, can't use it
  complete = { "o", ".", "w", "b", "u" },
  completeopt = { "fuzzy", "menuone", "noselect", "popup" },
  matchpairs = vim.opt.matchpairs:append "<:>",
  wildignore = vim.opt.wildignore:append {
    "*.DS_Store",
    "*.bak",
    "*.swp",
    "*.zip",
    "*/.git/*",
    "*.class",
    "*.bin"
  },
  shortmess = vim.opt.shortmess:prepend "c",

  -- INDENTATION
  tabstop = 2,
  softtabstop = 2,
  expandtab = true,
  shiftwidth = 2,

  -- FOLDING
  -- wrap = false,
  -- linebreak = true,
  -- foldenable = true,
  foldlevel = 99,
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldtext = "v:lua.require'lib.folds'.fold_text()",

  diffopt = vim.opt.diffopt:append { "context:3", "algorithm:histogram", "linematch:60" },

  colorcolumn = "90",

  -- FILE_MANAGEMENT
  autowrite = true,
  autowriteall = true,
  undofile = true,
  backup = false,
  swapfile = false,

  -- SEARCH
  smartcase = true,
  ignorecase = true,

  inccommand = "split",

  whichwrap = vim.opt.whichwrap:append "<,>,[,],h,l",

  -- SESSION
  sessionoptions = "buffers,curdir,folds,options,help,tabpages,winsize,winpos,terminal",

  -- SPELL
  spelllang = "it,en_us",
  spelloptions = "camel",
}

for k, o in pairs(settings) do
  vim.opt[k] = o
end

---LSP•Diagnostic
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󱧢 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
  virtual_text = { current_line = true },
  underline = false,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    title = "LSP • Diagnostic",
    prefix = "",
    winblend = 8,
  },
}