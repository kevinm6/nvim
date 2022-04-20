------------------------------------
-- File         : k_theme.lua
-- Description  : My personal colorscheme for NeoVim/VimR
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/colors/k_theme.lua
-- Last Modified: 17/04/2022 - 11:32
------------------------------------

local palette = require('palette')
local syntax = palette.syntax


local groups = {
  -- Modes
  Normal = { fg = '#D0D0D0', bg = palette.colors.bg },
  Visual = { reverse = true },
  -- Selection Not-Owned by Vim
  VisualNOS = { fg = '#244E7A' },

  WinSeparator = { },

  ModeMsg = { fg = 'DeepSkyBlue3' },
  MoreMsg = { fg = 'DeepSkyBlue3' },


  colorColumn =  { bg = palette.colors.bg },

  -- Cursor
  Cursor = { reverse = true },
  LineNr = { fg = '#626262', bg = palette.colors.bg },
  Cursorline = { bg = 'grey15' },
  CursorLineNr = { fg = palette.colors.green,  bold = true },

  TextYankPost = { reverse = true },

  -- Split
  VertSplit = { bg = palette.colors.bg, fg = palette.fg },

  -- Folding
  Folded = { bg = 'grey19', fg = 'Grey40' },
  FoldColumn = { fg = palette.colors.fg },

  -- Search
  IncSearch = { fg = '#3a3a3a', bg = palette.colors.green, bold = true },
  Search = { reverse = true },
  QuickFixLine = { reverse = true },

  -- Debugging
  Debug = { fg = palette.colors.red },

  -- Status Line
  StatusLine = { fg = '#606060', bg = '#303030' },
  StatusLineNC = { fg = '#A9A9A9', bg = '#606060' },
  StatusLineTerm = { fg = '#606060', bg = '#303030' },
  StatusLineTermNC = { fg = '#A9A9A9', bg = '#606060' },

  -- TabLine
  TabLineSel = { fg = "#606060", bg = "#303030" },
  TabLine = { fg = "#A9A9A9", bg = "#606060" },

  -- Users (StatusLine)
  User1 = { fg = "#158C8A", bg = "grey19" },
  User2 = { fg = "#af8700", bg = "grey19" },
  User3 = { fg = "#86868B", bg = "grey19" },
  User4 = { fg = "grey19", bg = "#1c1c1c" },
  User5 = { fg = "grey23", bg = "#1c1c1c" },
  User6 = { fg = "#36FF5A", bg = "grey19" },

  -- Syntax
  Title = { fg = syntax.Title.fg, bold = true, italic = true },
  Statement = { fg = syntax.Statement.fg },
  Directory = { fg = syntax.Directory.fg, bold = true },

  String = { fg = syntax.String.fg },
  Number = { fg = syntax.Number.fg },
  Comment = { fg = syntax.Comment.fg, italic = true },
  Constant = { fg = syntax.Constant.fg },
  Boolean = { fg = syntax.Boolean.fg, bold = true },
  Label = { fg = syntax.Boolean.fg },
  Conditional = { fg = syntax.Conditional.fg },
  Identifier = { fg = syntax.Identifier.fg },
  Include = { fg = syntax.Include.fg },
  Operator = { fg = syntax.Operator.fg },
  Define = { fg = syntax.Define.fg, bold = true },
  Type = { fg = syntax.Type.fg },
  Function = { fg = syntax.Function.fg },
  Structure = { fg = syntax.Structure.fg },
  Keyword = { fg = syntax.Keyword.fg },
  Exception = { fg = syntax.Exception.fg },
  Repeat = { fg = syntax.Repeat.fg },
  Underlined = { fg =syntax.Underlined.fg , underline = true },
  Question = { fg = syntax.Question.fg },
  SpecialKey = { fg = syntax.SpecialKey.fg },
  Special = { fg =syntax.Special.fg , bold = true },
  SpecialChar = { fg = syntax.SpecialChar.fg },
  Macro = { fg = syntax.Macro.fg },
  PreProc = { fg = syntax.PreProc.fg },
  PreCondit = { fg = syntax.PreCondit.fg },
  Tag = { fg = syntax.Tag.fg },
  Delimiter = { fg = syntax.Delimiter.fg },
  SpecialComment = { fg = syntax.SpecialComment.fg },
  Todo = { bg = syntax.Todo.bg , fg = syntax.Todo.fg, italic = true },

  -- End of buffer and non text
  NonText = {  fg = "#626262", bg = palette.colors.bg },
  EndOfBuffer = { fg = palette.colors.bg, bg = palette.bg },

  Ignore = { fg = "#5f5faf", bold = true },

  -- Menu
  WildMenu = { fg = "#161616", bg = "#808000" },

  -- Diff
  MatchParen = { fg = "#ff00ff", bold = true },

  DiffAdd = { fg = "#005fff" },
  DiffChange = { fg = "#808000" },
  DiffDelete = { fg = "#d70000" },
  DiffText = { fg = "#ff00ff" },
  SignColumn = { fg = "#626262", bg = palette.colors.bg },

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

  -- Nvim-Tree
  -- hi! link NvimTreeSymlink Function
  NvimTreeSymlink = { fg = "#00afd7" },
  -- hi! link NvimTreeFolderName Normal
  NvimTreeFolderName = { fg = "#d0d0d0", bg = "#1c1c1c" },
  -- hi! link NvimTreeRootFolder Type
  NvimTreeRootFolder = { fg = "#008080" },
  NvimTreeFolderIcon = { fg = "#00afd7" },
  -- hi NvimTreeFileIcon
  -- NvimTreeEmptyFolderName
  -- hi! link NvimTreeOpenedFolderName Directory
  NvimTreeOpenedFolderName = { fg = "#00af87", bold = true },
  -- hi! link NvimTreeExecFile Underlined
  NvimTreeExecFile = { fg = "#00a0d0", underline = true },
  NvimTreeOpenedFile = { bold = true, underline = true },
  NvimTreeSpecialFile = { fg = "#afaf00", bold = true, italic = true },
  -- hi! link NvimTreeImageFile Label
  NvimTreeImageFile = { fg = "#FF8AD8" },
  -- hi! link NvimTreeIndentMarker Comment
  NvimTreeIndentMarker = { fg = "#626262", italic = true },


  -- Cmp
  CmpItemAbbr = { fg = "#DCDCDC" },
  -- hi! link CmpItemKind Type
  CmpItemKind = { fg = "#008080" },
  -- hi! link CmpItemKindMethod Function
  CmpItemKindMethod = { fg = "#00afd7" },
  CmpItemAbbrMatch = { fg = "#00af87" },
  -- hi! link CmpItemMenu Special
  CmpItemMenu = { fg = "#ffff87", bold = true },

  -- Lsp
  FloatBorder = { bg = "grey15" },
  LspReferenceText = { bg = "grey27" },
  LspReferenceWrite = { bg = "grey42" },
  LspReferenceRead = { bg = "grey23" },

  -- Lsp Diagnostic
  DiagnosticError = { fg = "#f44747" },
  DiagnosticsWarning = { fg = "#ff8800" },
  DiagnosticsInformation = { fg = "#ffcc66" },
  DiagnosticsHint = { fg = "#4fc1ff" },
  DiagnosticsSignError = { fg = "#f44747" },
  DiagnosticsSignWarning = { fg = "#ff8800" },
  DiagnosticsSignInformation = { fg = "#ffcc66" },
  DiagnosticsSignHint = { fg = "#4fc1ff" },
  DiagnosticsVirtualTextError = { fg = "#f44747" },
  DiagnosticsVirtualTextWarning = { fg = "#ff8800" },
  DiagnosticsVirtualTextInformation = { fg = "#ffcc66" },
  DiagnosticsVirtualTextHint = { fg = "#4fc1ff" },

  -- Alpha
  AlphaHeader = { fg = "#74D15C" },
  -- hi! link AlphaButtons Keyword
  AlphaButtons = { fg = "#00ff87" },
  -- hi! link AlphaFooter Comment
  AlphaFooter = { fg = "#626262", italic = true },
}

for group, parameters in pairs(groups) do
  vim.api.nvim_set_hl(0, group, parameters)
end

