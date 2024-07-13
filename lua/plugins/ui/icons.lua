-----------------------------------
--	File: icons.lua
--	Description: icons plugin and custom set
--	Author: Kevin
--	Last Modified: 01 May 2024, 12:33
--  NOTE
--    Font    : Fira Code : 12.5 v|i 92, n/n 90
--    Fallback: Source Code Pro : 13 v|i 92, n/n 90
--    Symbols : Symbols (Only) Nerd Font
-----------------------------------

return {
  "echasnovski/mini.icons",
  version = false,
  event = "VeryLazy",
  config = function(_, o)
    local icons = require "mini.icons"
    o.filetype = {
      telescope = { glyph = " " },
      dashboard = { glyph = "" },
      list = { glyph = "" },
      table = { glyph = "" },
      search = { glyph = " " },
      error = { glyph = "" },
      warning = { glyph = "" },
      information = { glyph = "" },
      question = { glyph = "" },
      hint = { glyph = "󱧢" },
      status_ok = { glyph = "" },
      status_not_ok = { glyph = "" },
      term = { glyph = " " },
      notification = { glyph = " " },
    }
    o.file = {
      files = { glyph = "" },
      run = { glyph = "" },
      continue = { glyph = " " },
      reload_continue = { glyph = " " },
      pause = { glyph = "" },
      stop = { glyph = " " },
      breakpoint = { glyph = "" },
      restart = { glyph = " " },
      disconnect = { glyph = " " },
      into = { glyph = "" },
      over = { glyph = " " },
      out = { glyph = "󰆸" },
      repl = { glyph = " " },
      rerun = { glyph = " " },
      eval = { glyph = " " },
      working_sym = { glyph = "⟳" },
      error_sym = { glyph = "✗" },
      done_sym = { glyph = "✓" },
      removed_sym = { glyph = "-" },
      moved_sym = { glyph = "→" },
      header_sym = { glyph = "━" },
    }
    o.directory = {
      branch = { glyph = " " },
      -- Change Type
      add = { glyph = "" },
      mod = { glyph = "" },
      ignore = { glyph = "" },
      remove = { glyph = "" },
      rename = { glyph = "" },
      diff = { glyph = "" },
      repo = { glyph = "" },
      -- Status Type
      unstaged = { glyph = "*" },
      staged = { glyph = "" },
      unmerged = { glyph = "" },
      untracked = { glyph = "" },
      conflict = { glyph = "" },
      ignored = { glyph = "" },
      deleted = { glyph = "✗" },
    }
    o.lsp = {
      nvim_lsp = { glyph = "" },
      nvim_lua = { glyph = "" },
      snippet = { glyph = "󰘦" },
      buffer = { glyph = "" },
      path = { glyph = "" },
      treesitter = { glyph = "" },
      latex_symbols = { glyph = "α" },
      emoji = { glyph = "" },
      calc = { glyph = "" },
      otter = { glyph = "⎆" },
    }

    icons.setup(o)
    icons.mock_nvim_web_devicons()
  end,
}

-- local icons = setmetatable({
--   kind = {
--     Text = '',
--     Function = '󰊕',
--     Constructor = '',
--     Method = '',
--     Field = '',
--     Variable = '',
--     Class = '',
--     Interface = '',
--     Module = '',
--     Property = '',
--     Unit = '',
--     Value = '',
--     Enum = '',
--     Keyword = '',
--     Snippet = '',
--     Color = '',
--     File = '',
--     Reference = '',
--     Folder = '',
--     EnumMember = '',
--     Constant = '',
--     Struct = '',
--     Event = '',
--     Operator = '',
--     Null = '󰟢',
--     TypeParameter = '',
--     Namespace = '',
--   },
--   type = {
--     Array = '',
--     Number = '',
--     String = '',
--     Boolean = '',
--     Object = '',
--   },
--   bufferline = {
--     modified_icon = '●',
--     close = '',
--     buffer_close_icon = '󰅙',
--     left_trunc_marker = '',
--     right_trunc_marker = '',
--   },
--   package_manager = {
--   },
--   debug = {
--     run = '',
--     continue = ' ',
--     reload_continue = ' ',
--     pause = '',
--     stop = ' ',
--     breakpoint = '',
--     restart = ' ',
--     disconnect = ' ',
--     into = '',
--     over = ' ',
--     out = '󰆸',
--     repl = ' ',
--     rerun = ' ',
--     eval = ' '
--   },
-- ui = {
--   proc = { glyph = ' ' },
--   term = { glyph = ' ' },
--   disk = { glyph = '󰋊' },
--   Copy = { glyph = ' ' },
--   db = { glyph = '' },
--   lock = { glyph = '' },
--   circle = { glyph = '' },
--   smallCircle = { glyph = '' },
--   circleEmpty = { glyph = '○' },
--   bigCircle = { glyph = '' },
--   bigUnfilledCircle = { glyph = '' },
--   Close = { glyph = '' },
--   quit = { glyph = '󰿅 ' },
--   newFile = { glyph = '' },
--   lightbulb = { glyph = '' },
--   project = { glyph = '' },
--   save = { glyph = ' ' },
--   history = { glyph = '' },
--   comment = { glyph = '' },
--   bug = { glyph = '' },
--   code = { glyph = '' },
--   telescope = { glyph = ' ' },
--   gear = { glyph = '' },
--   package = { glyph = '' },
--   signIn = { glyph = '' },
--   check = { glyph = '' },
--   checkbox = { glyph = '󰱑 ' },
--   fire = { glyph = '' },
--   note = { glyph = '' },
--   bookMark = { glyph = '' },
--   pencil = { glyph = '' },
--   chevronRightMedium = { glyph = '❭' },
--   chevronLeftMedium = { glyph = '❭' },
--   chevronRight = { glyph = '' },
--   chevronLeft = { glyph = '' },
--   rightTriangle = { glyph = '▶' },
--   leftTriangle = { glyph = '◀' },
--   upTriangle = { glyph = '▲' },
--   downTriangle = { glyph = '▼' },
--   boldChevronRight = { glyph = '' },
--   boldChevronLeft = { glyph = '' },
--   slChevronRight = { glyph = '⟩' },
--   slChevronLeft = { glyph = '⟨' },
--   slArrowRight = { glyph = '' },
--   altSlArrowRight = { glyph = '►' },
--   slArrowLeft = { glyph = '' },
--   altSlArrowLeft = { glyph = '◄' },
--   slCircleRight = { glyph = '' },
--   slCircleLeft = { glyph = '' },
--   slEndLeft = { glyph = ' ' },
--   slEndRight = { glyph = '' },
--   calendar = { glyph = '' },
--   download = { glyph = '' },
--   plugin = { glyph = '󰀻' },
--   pluginManager = { glyph = '' },
--   uni = { glyph = '' },
--   health = { glyph = '♥' },
--   git = { glyph = '' },
--   appleSym = { glyph = '' },
--   version = { glyph = '' },
--   plus = { glyph = '' },
--   dev = { glyph = '󰾰' },
--   whichKeyChevron = { glyph = '❯' },
--   whichKeySep = { glyph = '→' },
--   orgmode = { glyph = '' },
--   query = { glyph = '󱩾' },
--   web = { glyph = '󰖟' },
--   bell = { glyph = ' ' },
--   messages = { glyph = '󰍡 ' }
-- }
-- o.misc = {
--   robot = { glyph = '󰚩' },
--   squirrel = { glyph = '' },
--   tag = { glyph = '' },
--   watch = { glyph = '' },
--   gitHub = { glyph = '' },
-- }
-- o.documents = {
--   file = { glyph = '' },
--   files = { glyph = '' },
--   folder = { glyph = '' },
--   openFolder = { glyph = '' },
--   folderEmpty = { glyph = '' },
--   default = { glyph = '*' },
-- }
-- }, {
--     __index = function()
--       return ' '
--     end
--   })
--
-- return icons
--
--