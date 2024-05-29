------------------------------------
-- File         : prefs.lua
-- Description  : NeoVim & VimR preferences
-- Author       : Kevin
-- Last Modified: 09 May 2024, 10:24
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
  guifont = "Fira Code:h12.5",
  relativenumber = true,
  number = true,
  showmode = false,
  scrolloff = 6,
  sidescrolloff = 6,
  matchtime = 2,
  visualbell = false,
  cursorline = true,
  showtabline = 1,
  showmatch = true,
  signcolumn = 'yes',
  cmdheight = 1,
  pumheight = 16,
  pumblend = 8,
  splitbelow = true,
  splitright = true,
  updatetime = 100,
  updatecount = 0,
  listchars = { tab = "⇥ ", eol = "↲", trail = "~", space = "_", nbsp = "␣" },
  fillchars = [[eob: ,fold:󰇘,foldopen:,foldsep: ,foldclose:]],
  timeoutlen = 350,
  ttimeoutlen = 100,
  completeopt = { 'menu', 'menuone', 'noselect' },
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
  },
  shortmess = vim.opt.shortmess:append "c",

  -- INDENTATION
  smartindent = true,
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

  diffopt = { 'internal', 'filler', 'closeoff', 'vertical' },

  colorcolumn = '90',

  -- FILE_MANAGEMENT
  autowrite = true,
  autowriteall = true,
  undofile = true,
  backup = false,
  swapfile = false,
  undodir = vim.fn.stdpath 'cache' .. "/undo",

  -- SEARCH
  smartcase = true,
  ignorecase = true,

  inccommand = 'split',

  whichwrap = vim.opt.whichwrap:append "<,>,[,],h,l",

  -- SESSION
  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",

  -- SPELL
  spelllang = "en,uk,it",
  spelloptions = "camel"
}

for k, o in pairs(settings) do
  vim.opt[k] = o
end