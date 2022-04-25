-------------------------------------
--  File         : base.lua
--  Description  : base colors palette
--  Author       : Kevin
--  Last Modified: 20/04/2022 - 11:56
-------------------------------------


local colors = require("user.k_theme.colors")
-- local utils = require("user.k_theme.utils")

-- reset colors
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end


-- options (dark mode by default)
local bg0 = colors.dark0
local bg1 = colors.dark1
local bg2 = colors.dark2
local bg3 = colors.dark3
local bg4 = colors.dark4

local fg0 = colors.light0
local fg1 = colors.light1
local fg2 = colors.light2
local fg3 = colors.light3
local fg4 = colors.light4

local red = colors.bright_red
local green = colors.bright_green
local yellow = colors.bright_yellow
local blue = colors.bright_blue
local purple = colors.bright_purple
local aqua = colors.bright_aqua
local orange = colors.bright_orange
local gray = colors.gray

local bg = vim.opt.background:get()
if bg == nil then
  bg = "dark"
  vim.o.background = bg
end

-- extending colors table with basic names for easy customization in g:k_theme_* options
colors.bg0 = bg0
colors.bg1 = bg1
colors.bg2 = bg2
colors.bg3 = bg3
colors.bg4 = bg4
colors.fg0 = fg0
colors.fg1 = fg1
colors.fg2 = fg2
colors.fg3 = fg3
colors.fg4 = fg4
colors.red = red
colors.green = green
colors.yellow = yellow
colors.blue = blue
colors.purple = purple
colors.aqua = aqua
colors.orange = orange


-- neovim terminal mode colors
vim.g.terminal_color_0 = bg0
vim.g.terminal_color_8 = gray
vim.g.terminal_color_1 = colors.neutral_red
vim.g.terminal_color_9 = red
vim.g.terminal_color_2 = colors.neutral_green
vim.g.terminal_color_10 = green
vim.g.terminal_color_3 = colors.neutral_yellow
vim.g.terminal_color_11 = yellow
vim.g.terminal_color_4 = colors.neutral_blue
vim.g.terminal_color_12 = blue
vim.g.terminal_color_5 = colors.neutral_purple
vim.g.terminal_color_13 = purple
vim.g.terminal_color_6 = colors.neutral_aqua
vim.g.terminal_color_14 = aqua
vim.g.terminal_color_7 = fg4
vim.g.terminal_color_15 = fg1

vim.g.colors_name = "k_theme"

local base_group = {

  -- Modes
  Normal = { fg = '#D0D0D0', bg = bg0 },
  Visual = { reverse = true },
  -- Selection Not-Owned by Vim
  VisualNOS = { fg = '#244E7A' },

  WinSeparator = {},

  ModeMsg = { fg = 'DeepSkyBlue3' },
  MoreMsg = { fg = 'DeepSkyBlue3' },

  colorColumn =  { bg = bg0 },

  -- Cursor
  Cursor = { reverse = true },
  LineNr = { fg = '#626262', bg = bg0 },
  Cursorline = { bg = 'grey15' },
  CursorLineNr = { fg = green,  bold = true },
  lCursor = { link = "Cursor" },
  iCursor = { link = "Cursor" },
  vCursor = { link = "Cursor" },
  CursorIM = { link = "Cursor" },
  CursorColumn = { link = "CursorLine" },

  TextYankPost = { reverse = true },

  -- Split
  VertSplit = { bg = bg0, fg = fg0 },

  -- Folding
  Folded = { bg = 'grey19', fg = 'Grey40' },
  FoldColumn = { fg = fg0 },

  -- Search
  IncSearch = { fg = '#3a3a3a', bg = green, bold = true },
  Search = { reverse = true },
  QuickFixLine = { reverse = true },

  -- Debugging
  Debug = { fg = red },

  -- Status Line
  StatusLine = { fg = '#606060', bg = '#303030' },
  StatusLineNC = { fg = '#A9A9A9', bg = '#606060' },
  StatusLineTerm = { fg = '#606060', bg = '#303030' },
  StatusLineTermNC = { fg = '#A9A9A9', bg = '#606060' },

  -- TabLine
  TabLineSel = { fg = "#606060", bg = "#303030" },
  TabLine = { fg = "#A9A9A9", bg = "#606060" },

  -- StatusLine
  SlineMode = { fg = "#158C8A", bg = "grey19" },
  SlineGit = { fg = "#af8700", bg = "grey19" },
  SlineFileName = { fg = "#36FF5A", bg = "grey19" },
  SlineFFormatEncoding = { fg = "#86868B", bg = "grey19" },
  SLineEmptyspace = { fg = "grey19", bg = "#1c1c1c" },
  SlineGpsDiagnostic = { fg = "grey23", bg = "#1c1c1c" },
  SlineFileType = { fg = "#158C8A", bg = "grey19" },

  Title = { fg = 'Gold1' },
  Statement = { fg = '#00afff' },
  Directory = { fg = '#00af87' },

  String = { fg = '#FF7E80' },
  Number = { fg = '#00fff2' },
  Comment = { fg = '#626262' },
  Constant = { fg = '#D4FB79' },
  Boolean = { fg = '#FF5573' },
  Label = { fg = '#FF8AD8' },
  Conditional = { fg = '#00ff87' },
  Identifier = { fg = '#af5f5f' },
  Include = { fg = '#ff0000' },
  Operator = { fg = '#00ff87' },
  Define = { fg = '#afaf00' },
  Type = { fg = '#008080' },
  Function = { fg = '#00afd7' },
  Structure = { fg = '#5faf00' },
  Keyword = { fg = '#00ff87' },
  Exception = { fg = '#af0000' },
  Repeat = { fg = '#00ff87' },
  Underlined = { fg = '#00a0d0' },
  Question = { fg = '#00875f' },
  SpecialKey = { fg = '#ffafd7' },
  Special = { fg = '#ffff87' },
  SpecialChar = { fg = '#FFF000' },
  Macro = { fg = '#ff54ad' },
  PreProc = { fg = '#d75f00' },
  PreCondit = { fg = '#875f5f' },
  Tag = { fg = '#ff00ff' },
  Delimiter = { fg = '#d7d787' },
  SpecialComment = { fg = '#6C7986' },
  Todo = { bg = '#d7ff00', fg = '#ff5f00' },
  Character = { link = "k_themePurple" },
  Float = { link = "k_themePurple" },
  StorageClass = { link = "k_themeOrange" },
  Typedef = { link = "k_themeYellow" },

  Bold = { bold = true },
  Italic = { italic = true },

  -- End of buffer and non text
  NonText = {  fg = "#626262", bg = bg0 },
  EndOfBuffer = { fg = bg0, bg = bg0 },

  Ignore = { fg = "#5f5faf", bold = true },

  -- Menu
  WildMenu = { fg = "#161616", bg = "#808000" },

  -- Diff
  MatchParen = { fg = "#ff00ff", bold = true },

  DiffAdd = { fg = "#005fff" },
  DiffChange = { fg = "#808000" },
  DiffDelete = { fg = "#d70000" },
  DiffText = { fg = "#ff00ff" },
  SignColumn = { fg = "#626262", bg = bg0 },

  -- Errors
  Error = { bg = "#ffffff", fg = "#ff0000", bold = true, },
  ErrorMsg = { bg = "#ff0000", fg = "#ffffff" },
  SpellErrors = { fg = "#ff005f" },
  WarningMsg = { fg = "#ff5f00" },

  -- Popup Menu
  Pmenu = { fg = "#DCDCDC", bg = "#303030" },
  PmenuSel = { fg = "#36FF5A", bg = "#444444", bold = true },
  PmenuSbar = { bg = "#262626" },
  PmenuThumb = { bg = "#585858" },

  Conceal = { fg = blue },
  SpellRare = { link = "k_themePurpleUnderline" },
  SpellBad = { link = "k_themeRedUnderline" },
  SpellLocal = { link = "k_themeAquaUnderline" },
  SpellCap = vim.g.k_theme_improved_warnings and {
    fg = green,
    bold = vim.g.k_theme_bold,
    italic = vim.g.k_theme_italic,
  } or { link = "k_themeBlueUnderline" },
  TabLineFill = { fg = bg4, bg = bg1, reverse = vim.g.k_theme_invert_tabline },
  diffAdded = { link = "k_themeGreen" },
  diffRemoved = { link = "k_themeRed" },
  diffChanged = { link = "k_themeAqua" },
  diffFile = { link = "k_themeOrange" },
  diffNewFile = { link = "k_themeYellow" },
  diffLine = { link = "k_themeBlue" },

  -- signature
  SignatureMarkText = { link = "k_themeBlueSign" },
  SignatureMarkerText = { link = "k_themePurpleSign" },

  -- gitcommit
  gitcommitSelectedFile = { link = "k_themeGreen" },
  gitcommitDiscardedFile = { link = "k_themeRed" },

  -- checkhealth
  healthError = { fg = bg0, bg = red },
  healthSuccess = { fg = bg0, bg = green },
  healthWarning = { fg = bg0, bg = yellow },
}

return base_group
