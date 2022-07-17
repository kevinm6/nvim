-------------------------------------
--  File         : plugins.lua
--  Description  : 3rd part plugins palette
--  Author       : Kevin
--  Last Modified: 16 Jul 2022, 14:56
-------------------------------------

local base = require "user.k_theme.base"
-- local colors = require("user.k_theme.colors")

local plugins = {
  -- Alpha
  AlphaHeader = { fg = "#74D15C" },
  AlphaButtons = { link = "Keyword" },
  AlphaFooter = { link = "Comment" },
  -- Nvim-Tree
  NvimTreeSymlink = { link = "Function" },
  NvimTreeFolderName = { link = "Normal" },
  NvimTreeRootFolder = { link = "Type" },
  NvimTreeFolderIcon = { fg = "#00afd7" },
  NvimTreeFileIcon = { link = "Type" },
  NvimTreeEmptyFolderName = { link = "Comment" },
  NvimTreeOpenedFolderName = { link = "Directory" },
  NvimTreeExecFile = { link = "Underlined" },
  NvimTreeOpenedFile = { bold = true, underline = true },
  NvimTreeSpecialFile = { fg = "#afaf00", bold = true, italic = true },
  NvimTreeImageFile = { link = "Label" },
  NvimTreeIndentMarker = { link = "Comment" },
  -- nvim-treesitter
  TSNone = {},
  TSError = {},
  TSTitle = base.Title,
  TSLiteral = base.String,
  TSURI = base.Underlined,
  TSVariable = base.k_themeFg1,
  TSPunctDelimiter = base.Delimiter,
  TSPunctBracket = base.Delimiter,
  TSPunctSpecial = base.Delimiter,
  TSConstant = base.Constant,
  TSConstBuiltin = base.Special,
  TSConstMacro = base.Define,
  TSString = base.String,
  TSStringRegex = base.String,
  TSStringEscape = base.SpecialChar,
  TSCharacter = base.Character,
  TSNumber = base.Number,
  TSBoolean = base.Boolean,
  TSFloat = base.Float,
  TSFunction = base.Function,
  TSFuncBuiltin = base.Special,
  TSFuncMacro = base.Macro,
  TSParameter = base.Identifier,
  TSParameterReference = { link = "TSParameter" },
  TSMethod = base.Function,
  TSField = base.Identifier,
  TSProperty = base.Identifier,
  TSConstructor = base.Special,
  TSAnnotation = base.PreProc,
  TSAttribute = base.PreProc,
  TSNamespace = base.Include,
  TSConditional = base.Conditional,
  TSRepeat = base.Repeat,
  TSLabel = base.Label,
  TSOperator = base.Operator,
  TSKeyword = base.Keyword,
  TSKeywordFunction = base.Keyword,
  TSKeywordOperator = base.k_themeRed,
  TSException = base.Exception,
  TSType = base.Type,
  TSTypeBuiltin = base.Type,
  TSInclude = base.Include,
  TSVariableBuiltin = base.Special,
  TSText = { link = "TSNone" },
  TSStrong = { bold = true },
  TSEmphasis = { italic = true },
  TSUnderline = { underline = true },
  TSComment = base.Comment,
  TSStructure = base.k_themeOrange,
  TSTag = base.k_themeOrange,
  TSTagDelimiter = base.k_themeGreen,
  TSCodeSpan = { bg = "#3c3c3c", fg = "#DCDCDC"},
  TSCodeBlock = {},

  -- telescope.nvim
  TelescopeSelection = base.k_themeOrangeBold,
  TelescopeSlectionCaret = base.k_themeRed,
  TelescopeMultiSelection = base.k_themeGray,
  TelescopeNormal = base.k_themeFg1,
  TelescopeBorder = { link = "TelescopeNormal" },
  TelescopePromptBorder = { link = "TelescopeNormal" },
  TelescopeResultsBorder = { link = "TelescopeNormal" },
  TelescopePreviewBorder = { link = "TelescopeNormal" },
  TelescopeMatching = base.k_themeBlue,
  TelescopePromptPrefix = base.k_themeRed,
  TelescopePrompt = { link = "TelescopeNormal" },
  -- gitsigns.nvim
  GitSignsAdd = base.k_themeGreenSign,
  GitSignsChange = base.k_themeAquaSign,
  GitSignsDelete = base.k_themeRedSign,
  GitSignsCurrentLineBlame = base.NonText,
  -- nvim-cmp
  CmpItemAbbr = { fg = "#DCDCDC" },
  CmpItemKind = { link = "Type" },
  CmpItemAbbrMatch = { fg = "#40CC7C" },
  CmpItemMenu = { link = "Special" },
  CmpItemAbbrDeprecated = base.k_themeFg0,
  CmpItemAbbrMatchFuzzy = { fg = base.aqua },
  CmpItemKindClass = base.k_themeGreen,
  CmpItemKindConstructor = base.k_themeGreen,
  CmpItemKindField = base.k_themeAqua,
  CmpItemKindFile = base.k_themeOrange,
  CmpItemKindFolder = base.k_themeOrange,
  CmpItemKindFunction = base.k_themePurple,
  CmpItemKindMethod = { link = "Function" },
  CmpItemKindInterface = base.k_themeGreen,
  CmpItemKindKeyword = base.Keyword,
  CmpItemKindSnippet = base.k_themeYellow,
  CmpItemKindText = base.k_themeFg0,
  CmpItemKindValue = base.k_themeOrange,
  CmpItemKindVariable = base.k_themeBlue,
  LuasnipChoiceNode = { fg = "#ff8800", bg = "grey15" },
  LuasnipInsertNode = { fg = "#4fc1ff", bg = "grey15" },
  -- LSP
  LspCodeLens = base.k_themeGray,
  LspReferenceText = { bg = "#3c3c3c" },
  LspReferenceWrite = { fg = "#F1F1F1", bg = "#015A60" },
  LspReferenceRead = { bg = "#3c3c3c" },
  FloatBorder = { fg = "#3D3D40", bg = "#2c2c2c" },
  -- Diagnostic
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
  DiagnosticSignError = base.k_themeRedSign,
  DiagnosticUnderlineError = base.k_themeRedUnderline,
  DiagnosticWarn = base.k_themeYellow,
  DiagnosticSignWarn = base.k_themeYellowSign,
  DiagnosticUnderlineWarn = base.k_themeYellowUnderline,
  DiagnosticInfo = base.k_themeBlue,
  DiagnosticSignInfo = base.k_themeBlueSign,
  DiagnosticUnderlineInfo = base.k_themeBlueUnderline,
  DiagnosticHint = base.k_themeAqua,
  DiagnosticSignHint = base.k_themeAquaSign,
  DiagnosticUnderlineHint = base.k_themeAquaUnderline,
  DiagnosticFloatingError = base.k_themeRed,
  DiagnosticFloatingWarn = base.k_themeOrange,
  DiagnosticFloatingInfo = base.k_themeBlue,
  DiagnosticFloatingHint = base.k_themeAqua,
  DiagnosticVirtualTextError = base.k_themeRed,
  DiagnosticVirtualTextWarn = base.k_themeYellow,
  DiagnosticVirtualTextInfo = base.k_themeBlue,
  DiagnosticVirtualTextHint = base.k_themeAqua,
  -- WhichKey
  WhichKey = { link = "Function" },
  WhichKeyGroup = { link = "Type" },
  WhichKeySeparator = { link = "DiffAdded" },
  WhichKeyDesc = { link = "Identifier" },
  WhichKeyFloat = { bg = "#2c2c2c" },
  WhichKeyValue = { link = "Comment" },
  -- Navic
  NavicIconsFile = { link = "CmpItemKindFile" },
  NavicIconsModule = { link = "CmpItemKindClass" },
  NavicIconsNamespace = { link = "CmpItemKindClass" },
  NavicIconsPackage = { link = "CmpItemKindProperty" },
  NavicIconsClass = { link = "CmpItemKindClass" },
  NavicIconsMethod = { link = "CmpItemKindMethod" },
  NavicIconsProperty = { link = "CmpItemKindProperty" },
  NavicIconsField = { link = "CmpItemKindField" },
  NavicIconsConstructor = { link = "CmpItemKindConstructor" },
  NavicIconsEnum = { link = "CmpItemKindValue" },
  NavicIconsInterface = { link = "CmpItemKindInterface" },
  NavicIconsFunction = { link = "CmpItemKindFunction" },
  NavicIconsVariable = { default = true, link = "CmpItemKindVariable" },
  NavicIconsConstant = { link = "CmpItemKindVariable" },
  NavicIconsString = { link = "CmpItemKindText" },
  NavicIconsNumber = { link = "CmpItemKindValue" },
  NavicIconsBoolean = { link = "CmpItemKindValue" },
  NavicIconsArray = { link = "CmpItemKindVariable" },
  NavicIconsObject = { link = "CmpItemKindVariable" },
  NavicIconsKey = { link = "CmpItemKindKeyword" },
  NavicIconsNull = { link = "TSNone" },
  NavicIconsEnumMember = { link = "CmpItemKindVariable" },
  NavicIconsStruct = { link = "CmpItemKindStruct" },
  NavicIconsEvent = { link = "CmpItemKindEvent" },
  NavicIconsOperator = { link = "CmpItemKindOperator" },
  NavicIconsTypeParameter = { link = "CmpItemKindTypeParameter" },
  NavicIconsText = { link = "CmpItemKindText" },
  NavicIconsSeparator = { link = "Comment" },
  -- Fidget
  FidgetTitle = { link = "Title" },
}

return plugins
