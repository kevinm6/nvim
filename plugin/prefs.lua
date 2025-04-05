------------------------------------
-- File         : prefs.lua
-- Description  : NeoVim & VimR preferences
-- Author       : Kevin
-- Last Modified: 05 Apr 2025, 20:36
-------------------------------------

local settings = {
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
  showmatch = true,
  signcolumn = "yes",
  cmdheight = 1,
  pumheight = 16,
  pumblend = 2,
  splitbelow = true,
  splitright = true,
  updatetime = 100,
  updatecount = 0,
  listchars = { tab = "⇥ ", eol = "↲", trail = "~", space = "_", nbsp = "␣" },
  fillchars = [[eob: ,fold:󰇘,foldopen:,foldsep: ,foldclose:]],
  timeoutlen = 350,
  ttimeoutlen = 100,
  completeopt = { "menuone", "noselect", "popup", "fuzzy" },
  matchpairs = vim.opt.matchpairs:append "<:>",
  wildignore = {
    "*.DS_Store",
    "*.bak",
    "*.gif",
    -- "*.jpeg",
    -- "*.jpg",
    -- "*.png",
    "*.swp",
    "*.zip",
    "*/.git/*",
    "*templates/*",
  },
  shortmess = vim.opt.shortmess:append "c",

  -- INDENTATION
  tabstop = 2,
  softtabstop = 2,
  expandtab = true,
  shiftwidth = 2,

  -- FOLDING
  -- wrap = false,
  -- linebreak = true,
  -- foldenable = true,
  -- foldmethod = "expr",
  -- foldexpr = "nvim_treesitter#foldexpr()",
  -- foldtext = '',

  diffopt = { "internal", "filler", "closeoff", "vertical", "iwhiteeol", "followwrap" },

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
  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",

  -- SPELL
  spelllang = "it,en_us",
  spelloptions = "camel",
}

for k, o in pairs(settings) do
  vim.opt[k] = o
end

---Custom diagnostic config
local icon_err, icon_warn, icon_info, icon_hint = "", "", "", "󱧢"

local signs = {
  {
    name = "DiagnosticSignError",
    text = icon_err,
    numhl = "ErrorMsg",
  },
  {
    name = "DiagnosticSignWarn",
    text = icon_warn,
    numhl = "WarningMsg",
  },
  { name = "DiagnosticSignHint", text = icon_hint },
  { name = "DiagnosticSignInfo", text = icon_info },
}

for _, sign in pairs(signs) do
  vim.fn.sign_define(sign.name, {
    texthl = sign.name,
    text = sign.text,
    numhl = sign.numhl or nil,
  })
end

---LSP•Diagnostic
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icon_err,
      [vim.diagnostic.severity.WARN] = icon_warn,
      [vim.diagnostic.severity.INFO] = icon_info,
      [vim.diagnostic.severity.HINT] = icon_hint,
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
