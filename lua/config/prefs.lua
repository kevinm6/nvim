-------------------------------------
-- File         : prefs.lua
-- Description  : NeoVim & VimR preferences
-- Author       : Kevin
-- Last Modified: 09 Jun 2023, 17:15
-------------------------------------

-- CURSOR {
vim.opt.guicursor = { -- cursor shape mode-based
   "n-v-c:block",
   "i-ci-ve:ver25",
   "r-cr:hor20,o:hor50",
}
-- }

local options = {
   -- shell = vim.fn.split(vim.fn.system "which zsh", "\n")[1],

   -- MOUSE:
   mouse = "vnc",
   fileencoding = "utf-8",

   -- GRAPHIC:
   termguicolors = true,
   laststatus = 3,
   guifont = "Source Code Pro:h13", -- font for gui-apps
   -- clipboard = vim.opt.clipboard:append "unnamedplus", -- allow neovim access to system clipboardpre
   relativenumber = true, -- Show line numbers - relativenumber from current
   number = true, -- relativenumber but show current line number
   showmode = false, -- show active mode in status line
   scrolloff = 6, -- # of line leave above and below cursor
   sidescrolloff = 6, -- # of columns on the sides
   mat = 2, -- tenths of second to blink during matching brackets
   visualbell = false, -- disable visual sounds
   cursorline = true, -- highlight cursor line
   showtabline = 0, -- show tabs if more than 1
   showmatch = true, -- Show matching brackets when over
   signcolumn = "yes", -- always show signcolumns
   cmdheight = 1, -- #lines for vim for commands/logs
   pumheight = 16, -- popup menu height
   pumblend = 8, -- popup menu transparency {0..100}
   splitbelow = true, -- split below in horizontal split
   splitright = true, -- split right in vertical split
   updatetime = 100, -- lower than default for faster completion
   updatecount = 0, -- do not create swap file
   listchars = { tab = "⇥ ", eol = "↲", trail = "~", space = "_" },
   fillchars = [[eob: ,fold:,foldopen:,foldsep:,foldclose:]],
   syntax = "off", -- using treesitter
   timeoutlen = 100,
   ttimeoutlen = 50,
   -- lazyredraw = true,
   completeopt = { "menu", "menuone", "noselect" },
   matchpairs = vim.opt.matchpairs:append "<:>",
   wildignore = {
      "*.DS_Store",
      "*.bak",
      "*.gif",
      "*.jpeg",
      "*.jpg",
      "*.png",
      "*.swp",
      "*.zip",
      "*/.git/*",
   },
   shortmess = vim.opt.shortmess:append "c", -- do not pass messages to ins-completion-menu

   -- INDENTATION:
   smartindent = true, -- enable smart indentation
   tabstop = 3, -- number of spaces of <Tab>
   softtabstop = 3, -- :h softtabstop
   expandtab = true, -- convert tabs to spaces
   shiftwidth = 3, -- number of spaces for indentation

   -- FOLDING:
   wrap = false, -- Wrap long lines showing a linebreak
   foldenable = true, -- enable code folding
   foldmethod = "expr", -- method used to generate folds
   foldexpr = "nvim_treesitter#foldexpr()", -- using treesitter to more folds
   diffopt = { "internal", "filler", "closeoff", "vertical" },
   -- FIX:
   -- disable til statuscolumn fixes: see https://github.com/kevinhwang91/nvim-ufo/issues/4
   -- and https://github.com/neovim/neovim/pull/17446
   -- it's overrided by nvim-ufo for now
   foldcolumn = "auto",
   colorcolumn = "90",

   -- FILE_MANAGEMENT:
   autowrite = true, -- write files
   autowriteall = true, -- write files on exit or other changes
   undofile = true, -- enable undo
   backup = false, -- disable backups
   swapfile = false, -- disable swaps
   undodir = vim.fn.expand "~/.cache/nvim/undo", -- path to undo directory

   -- SEARCH:
   smartcase = true, -- smart case for search
   ignorecase = true, -- case insensitive on search

   whichwrap = vim.opt.whichwrap:append "<,>,[,],h,l",

   -- SESSION: (managed by auto-session)
   sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",
}

-- Sets all options to desired value
for k, v in pairs(options) do
   vim.opt[k] = v
end
