-------------------------------------
--- File         : kurayami.lua
--- Description  : color palette for kurayami colorscheme
--- Author       : Kevin
--- Last Modified: 26/04/2025, 20:25
-------------------------------------

vim.cmd.hi 'clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd.syntax 'reset'
end
vim.g.colors_name = 'kurayami'

-- neovim terminal mode colors
vim.opt.termguicolors = true
vim.g.terminal_color_0  = "#1c1c1c" -- black
vim.g.terminal_color_8  = "#626262" -- gray
vim.g.terminal_color_1  = "#bf616a" -- red
vim.g.terminal_color_9  = "#b2201f" -- bright-red
vim.g.terminal_color_2  = "#00af87" -- green
vim.g.terminal_color_10 = "#36f57a" -- bright-green
vim.g.terminal_color_3  = "#cecb00" -- yellow
vim.g.terminal_color_11 = "#fffd00" -- bright-yellow
vim.g.terminal_color_4  = "#158C8A" -- blue
vim.g.terminal_color_12 = "#1a8fff" -- bright-blue
vim.g.terminal_color_5  = "#B48EAD" -- purple
vim.g.terminal_color_13 = "#cb1ed1" -- bright-purple
vim.g.terminal_color_6  = "#1a8fff" -- cyan
vim.g.terminal_color_14 = "#14ffff" -- bright-cyan
vim.g.terminal_color_7  = "#dcdcdc" -- white
vim.g.terminal_color_15 = "#ffffff" -- bright-white

local default = setmetatable({
	red = "#fb4934",
	green = "#36f57a",
	yellow = "#fabd2f",
	blue = "#83a598",
	purple = "#d3869b",
	aqua = "#9ec0cc",
	orange = "#fe8019",
}, {
	__index = function()
		return "#bbbbbb"
	end,
})

local groups = {
	---Modes
	Normal = { fg = "#D0D0D0", bg = "#1c1c1c" },
	Visual = { reverse = true },
	--Selection Not-Owned by Vim
	VisualNOS = { fg = "#244E7A" },

	WinSeparator = { fg = "#3D3D40" },
	NormalFloat = { bg = "#1f1f1f" },
	FloatBorder = { fg = "#3D3D40", bg = "#1e1e1e" },

	TabLine = { bg = "#2c2c2c" },
	TabLineSel = { fg = "#dcdcdc", bg = "#1e1e1e", bold = true, italic = true },
	TabLineFill = { bg = "#1c1c1c" },

	ModeMsg = {},
	MoreMsg = {},
	MsgArea = { fg = "#626262" },

	ColorColumn = { bg = "#202020" },

	---Cursor
	Cursor = { reverse = true },
	LineNr = { fg = "#626262", bg = "#1c1c1c" },
	Cursorline = { bg = "grey15" },
	CursorLineNr = { fg = default.green, bold = true },
	lCursor = { fg = default.default.red },
	iCursor = { fg = default.default.aqua },
	vCursor = { link = "Cursor" },
	CursorIM = { link = "Cursor" },
	CursorColumn = { link = "CursorLine" },

	TextYankPost = { reverse = true },

	---Split
	VertSplit = { bg = "#1c1c1c", fg = "#fbf1c7" },

	---Folding
	Folded = { bg = "grey13", fg = "Grey40" },
	FoldColumn = { link = "Comment" },
	Conceal = { fg = default.blue },

	---Search
	IncSearch = { fg = "#3a3a3a", bg = default.green, bold = true },
	Search = { reverse = true },
	QuickFixLine = { bg = "grey15" },

	---Debugging
	Debug = { fg = default.red },

	---StatusLine
	StatusLine = { fg = "#626262", bg = "#1c1c1c" },
	StatusLineNC = { fg = "#868686", bg = "#1c1c1c" },
	WinBar = { fg = "#6c6c6c", bg = "#1c1c1c", bold = false },
	WinBarNC = { fg = "#3c3c3c", bg = "#1c1c1c", italic = true },

	---Nvim Modes
	Nmode = { fg = "#158C8A" },
	Vmode = { fg = "Gold1" },
	Imode = { fg = "#00afff" },
	Cmode = { fg = "#af0000" },
	Tmode = { fg = "#FF5573" },
	ShellMode = { fg = "#ffff87" },

	---Syntax
	Title = { fg = "Gold1" },
	Statement = { fg = "#00ff87" },
	Directory = { fg = "#00af87" },

	String = { fg = "#FF7E80" },
	Number = { fg = "#00fff2" },
	Comment = { fg = "#626262" },
	Constant = { fg = "#D4FB79" },
	Boolean = { fg = "#FF5573" },
	Label = { fg = "#FF8AD8" },
	Conditional = { fg = "#00ff87" },
	Identifier = { fg = "#507d8b" },
	Include = { fg = "#ff0000" },
	Operator = { fg = "#00ff87" },
	Define = { fg = "#afaf00" },
	Type = { fg = "#008080" },
	Function = { fg = "#00afd7" },
	Structure = { fg = "#5faf00" },
	Keyword = { fg = "#00ff87" },
	Exception = { fg = "#af0000" },
	Repeat = { fg = "#00ff87" },
	Underlined = { underline = true },
	Question = { fg = "#00875f" },
	SpecialKey = { fg = "#ffafd7" },
	Special = { fg = "#D4FB79" },
	SpecialChar = { fg = "#FFF000" },
	Macro = { fg = "#ff54ad" },
	PreProc = { fg = "#d75f00" },
	PreCondit = { fg = "#875f5f" },
	Tag = { fg = "#569CD6" },
	Delimiter = { fg = "#aaaaaa" },
	SpecialComment = { fg = "#6C7986" },
	Todo = { bg = "#4FC1FF" },
	Character = { fg = "#acacac" },
	Float = { fg = "#00ccaa" },
	StorageClass = { fg = "#ffaf16" },
	Typedef = { fg = "#009090" },

	---Font enhance
	Bold = { bold = true },
	Italic = { italic = true },

	---End of buffer and non-text
	NonText = { fg = "#626262", bg = "#1c1c1c" },
	EndOfBuffer = { fg = "#1c1c1c", bg = "#1c1c1c" },

	Ignore = { fg = "#5f5faf", bold = true },
	MatchParen = { fg = "#09ddd0" },

	---Menu
	WildMenu = { fg = "#161616", bg = "#808000" },

	---Diff
	DiffAdd = { fg = "#014fff" },
	DiffChange = { bg = "#2c2c2c" },
	DiffDelete = { fg = "#ff8080" },
	DiffText = { fg = "gold" },
	-- diffAdded = { fg = default.green },
	-- diffRemoved = { fg = default.red },
	-- diffChanged = { fg = default.aqua },
	-- diffFile = { fg = orange },
	-- diffNewFile = { fg = default.yellow },
	-- diffLine = { fg = default.blue },

	SignColumn = { fg = "#626262", bg = "#1c1c1c" },

	---Errors
	Error = { fg = "#DC2626", underline = true },
	ErrorMsg = { fg = "#DC2626" },
	SpellErrors = { fg = "#ff005f", undercurl = true },
	WarningMsg = { fg = "#ff5f00" },

	---Popup Menu
	Pmenu = { fg = "#A1A1A1", bg = "#202020" },
	PmenuSel = { fg = "#F1F1F1", bg = "#015A60" },
	PmenuSbar = { bg = "#262626" },
	PmenuThumb = { bg = "NONE" },
	PmenuMatch = { fg = "#40CC7C" },
	PmenuMatchSel = { fg = default.yellow },
	PmenuKind = { link = "Type" },

	---Snippet
	SnippetTabstop = { italic = true, underline = true },

	---Spell
	SpellRare = { fg = default.purple, underline = true },
	SpellBad = { fg = default.red, underline = true },
	SpellLocal = { fg = default.aqua, underline = true },
	SpellCap = vim.g.k_theme_improved_warnings and {
		fg = default.green,
		bold = true,
		italic = true,
	} or { fg = default.blue, underline = true },

	---signature
	SignatureMarkText = { fg = default.blue },
	SignatureMarkerText = { fg = default.purple },

	---gitcommit
	gitcommitSelectedFile = { fg = default.green },
	gitcommitDiscardedFile = { fg = default.red },

	---checkhealth
	healthError = { bg = "#1c1c1c", fg = default.red },
	healthSuccess = { bg = "#1c1c1c", fg = default.green },
	healthWarning = { bg = "#1c1c1c", fg = default.yellow },

	---Diagnostic
	DiagnosticError = { fg = "#f44747" },
	DiagnosticInfo = { fg = "#00ffaa" },
	DiagnosticWarn = { fg = "#ff8800" },
	DiagnosticWarning = { fg = "#ff8800" },
	DiagnosticInformation = { fg = "#ffcc66" },
	DiagnosticHint = { fg = "#4fc1ff" },
	DiagnosticSignError = { fg = "#f44747" },
	DiagnosticSignWarning = { fg = "#ff8800" },
	DiagnosticSignInformation = { fg = "#ffcc66" },
	DiagnosticSignHint = { fg = "#4fc1ff" },
	DiagnosticVirtualTextError = { fg = "#f44747" },
	DiagnosticVirtualTextWarning = { fg = "#ff8800" },
	DiagnosticVirtualTextInformation = { fg = "#ffcc66" },
	DiagnosticVirtualTextWarn = { link = "DiagnosticWarning" },
	DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" },
	DiagnosticVirtualTextHint = { link = "DiagnosticHint" },
	DiagnosticSignInfo = { link = "DiagnosticInfo" },
	DiagnosticSignWarn = { link = "DiagnosticWarn" },
	DiagnosticSignOther = { link = "DiagnosticOther" },
	DiagnosticFloatingHint = { link = "DiagnosticHint" },
	DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
	DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
	DiagnosticFloatingError = { link = "DiagnosticError" },
	DiagnosticUnderlineHint = { fg = "NONE", bg = "NONE", sp = "#ff8800", undercurl = true },
	DiagnosticUnderlineInfo = { fg = "NONE", bg = "NONE", sp = "#ff8800", undercurl = true },
	DiagnosticUnderlineWarn = { fg = "NONE", bg = "NONE", sp = "#ff8800", undercurl = true },
	DiagnosticUnderlineError = { fg = "NONE", bg = "NONE", sp = "#f44747", undercurl = true },

	---LSP
	---@url https://github.com/neovim/nvim-lspconfig
	LspCodeLens = { fg = "#6D7986" },
	LspReferenceText = { bg = "#3c3c3c" },
	LspCodeLensSeparator = { link = "@comment" },
	LspReferenceWrite = { fg = "#F1F1F1", bg = "#015A60" },
	LspReferenceRead = { bg = "#3c3c3c" },

	LspInfoFiletype = { link = "Type" },
	LspInfoTitle = { fg = "Gold1", bold = true },
	LspInfoList = { link = "Function" },
	LspInfoBorder = { fg = "#3D3D40" },
	LspInfoTip = { link = "Comment" },
	LspSignatureActiveParameter = { reverse = true, underline = true },
	LspDiagnosticsError = { fg = "#f44747", bg = "NONE" },
	LspDiagnosticsWarning = { fg = "#ff8800", bg = "NONE" },
	LspDiagnosticsInfo = { fg = "#ff8800", bg = "NONE" },
	LspDiagnosticsInformation = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsHint = { fg = "#ff8800", bg = "NONE" },
	LspDiagnosticsDefaultError = { link = "LspDiagnosticsError" },
	LspDiagnosticsDefaultWarning = { link = "LspDiagnosticsWarning" },
	LspDiagnosticsDefaultInformation = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsDefaultInfo = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsDefaultHint = { link = "LspDiagnosticsHint" },
	LspDiagnosticsVirtualTextError = { link = "DiagnosticVirtualTextError" },
	LspDiagnosticsVirtualTextWarning = { link = "DiagnosticVirtualTextWarn" },
	LspDiagnosticsVirtualTextInformation = { link = "DiagnosticVirtualTextInfo" },
	LspDiagnosticsVirtualTextInfo = { link = "DiagnosticVirtualTextInfo" },
	LspDiagnosticsVirtualTextHint = { link = "DiagnosticVirtualTextHint" },
	LspDiagnosticsFloatingError = { link = "LspDiagnosticsError" },
	LspDiagnosticsFloatingWarning = { link = "LspDiagnosticsWarning" },
	LspDiagnosticsFloatingInformation = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsFloatingInfo = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsFloatingHint = { link = "LspDiagnosticsHint" },
	LspDiagnosticsSignError = { link = "LspDiagnosticsError" },
	LspDiagnosticsSignWarning = { link = "LspDiagnosticsWarning" },
	LspDiagnosticsSignInformation = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsSignInfo = { link = "LspDiagnosticsInfo" },
	LspDiagnosticsSignHint = { link = "LspDiagnosticsHint" },
	LspDiagnosticsUnderlineError = { link = "DiagnosticUnderlineError" },
	LspDiagnosticsUnderlineWarning = { link = "DiagnosticUnderlineWarn" },
	LspDiagnosticsUnderlineInformation = { link = "DiagnosticUnderlineInfo" },
	LspDiagnosticsUnderlineInfo = { link = "DiagnosticUnderlineInfo" },
	LspDiagnosticsUnderlineHint = { link = "DiagnosticUnderlineHint" },

	---Blink.Cmp
	---@url https://github.com/Saghen/blink.cmp
	BlinkCmpMenu = { bg = "#242424" },
	BlinkCmpMenuBorder = { bg = "#242424" },
	BlinkCmpDoc = { bg = "#242424" },
	BlinkCmpDocBorder = { bg = "#242424" },
	BlinkCmpLabel = { fg = "#A1A1A1" },
	BlinkCmpLabelMatch = { fg = "#40CC7C" },
	BlinkCmpLabelDetail = { link = "Special" },
	BlinkCmpLabelDescription = { fg = "#626262", bg = "#202020" },
	BlinkCmpLabelDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
	BlinkCmpKind = { link = "Type" },
	BlinkCmpKindClass = { link = "SpecialChar" },
	BlinkCmpKindConstructor = { link = "Label" },
	BlinkCmpKindField = { link = "Constant" },
	BlinkCmpKindFile = { link = "Directory" },
	BlinkCmpKindFolder = { link = "Directory" },
	BlinkCmpKindFunction = { link = "Function" },
	BlinkCmpKindMethod = { link = "Function" },
	BlinkCmpKindInterface = { link = "Identifier" },
	BlinkCmpKindKeyword = { link = "Keyword" },
	BlinkCmpKindSnippet = { link = "ShellMode" },
	BlinkCmpKindText = { link = "String" },
	BlinkCmpKindValue = { link = "Value" },
	BlinkCmpKindVariable = { link = "Type" },
	BlinkCmpKindProperty = { link = "Define" },
	BlinkCmpKindEvent = { link = "Ignore" },
	BlinkCmpKindEnum = { link = "Float" },
	BlinkCmpKindConstant = { link = "Constant" },
	BlinkCmpKindReference = { link = "Identifier" },
	BlinkCmpKindStruct = { link = "Structure" },
	BlinkCmpKindModule = { link = "Statement" },
	BlinkCmpKindOperator = { link = "Operator" },
	BlinkCmpKindUnit = { link = "Tag" },
	BlinkCmpKindEnumMember = { link = "Type" },
	BlinkCmpKindColor = { link = "Constant" },
	BlinkCmpKindTypeParameter = { link = "Type" },

	---Lazy (Package Manager)
	---@url https://github.com/folke/lazy.nvim
	LazyButton = { link = "CursorLine" },
	LazyButtonActive = { link = "Visual" },
	LazyComment = { link = "Comment" },
	LazyCommit = { link = "Special" },
	LazyCommitIssue = { link = "Number" },
	LazyCommitScope = { link = "Italic" },
	LazyCommitType = { link = "Title" },
	LazyDir = { link = "Directory" },
	LazyH1 = { link = "IncSearch" },
	LazyH2 = { link = "Bold" },
	LazyNoCond = { link = "DiagnosticWarn" },
	LazyNormal = { link = "NormalFloat" },
	LazyProgressDone = { link = "Constant" },
	LazyProgressTodo = { link = "LineNr" },
	LazyProp = { link = "Conceal" },
	LazyReasonCmd = { link = "Operator" },
	LazyReasonEvent = { link = "Constant" },
	LazyReasonFt = { link = "Comment" },
	LazyReasonKeys = { link = "Type" },
	LazyReasonPlugin = { link = "Special" },
	LazyReasonRuntime = { link = "@macro" },
	LazyReasonSource = { link = "Character" },
	LazyReasonStart = { link = "@field" },
	LazySpecial = { link = "@punctuation.special" },
	LazyTaskError = { link = "ErrorMsg" },
	LazyTaskOutput = { link = "MsgArea" },
	LazyUrl = { link = "@text.reference" },
	LazyValue = { link = "@string" },

	---Snacks
	---@url https://github.com/folke/snacks.nvim
	SnacksDashboardHeader = { link = "Type" },
	SnacksDashboardFooter = { link = "Comment" },
	SnacksDashboardTitle = { link = "Type" },
	SnacksDashboardIcon = { link = "Function" },
	SnacksDashboardDesc = { link = "SnacksDashboardNormal" },
  SnacksPickerMatch = { fg = default.orange, bold = true },

	---TreeSitter
	---@url https://github.com/nvim-treesitter/nvim-treesitter
	["@none"] = { default = true },
	["@error"] = {},
	["@text"] = { default = true },
	["@text.title"] = { link = "Title" },
	["@text.literal"] = { link = "String" },
	["@text.math"] = { link = "String" },
	["@text.reference"] = { link = "Define" },
	["@text.environment"] = { link = "Typedef" },
	["@text.environment.name"] = { link = "Type" },
	["@text.uri"] = { fg = "#00fff2" },
	["@text.strong"] = { bold = true },
	["@text.emphasis"] = { italic = true },
	["@text.underline"] = { underline = true },
	["@text.todo"] = { fg = "#1c1c1c", bg = "#4FC1FF" },
	["@text.note"] = { fg = "#1c1c1c", bg = "#ffcc66" },
	["@text.warning"] = { fg = "#1c1c1c", bg = "#ff8800" },
	["@text.danger"] = { fg = "#1c1c1c", bg = "#f44747" },
	["@comment.todo.comment"] = { link = "@text.todo" },
	["@comment.note.comment"] = { link = "@text.note" },
	["@comment.warning.comment"] = { link = "@text.warning" },
	["@comment.error.comment"] = { link = "@text.danger" },
	["@variable"] = { fg = "#2d5d79" },
	["@punctuation.delimiter"] = { link = "Delimiter" },
	["@punctuation.bracket"] = { link = "Delimiter" },
	["@punctuation.special"] = { link = "Delimiter" },
	["@constant"] = { link = "Constant" },
	["@constant.builtin"] = { link = "Special" },
	["@constant.macro"] = { link = "Define" },
	["@string"] = { link = "String" },
	["@string.regex"] = { link = "SpellRare" },
	["@string.escape"] = { fg = "#ff005f" },
	["@string.special"] = { link = "SpecialChar" },
	["@character"] = { link = "Character" },
	["@number"] = { link = "Number" },
	["@boolean"] = { link = "Boolean" },
	["@float"] = { link = "Float" },
	["@function"] = { link = "Function" },
	["@function.builtin"] = { link = "Special" },
	["@function.macro"] = { link = "Macro" },
	["@parameter"] = { link = "Identifier" },
	["@parameter.reference"] = { link = "Identifier" },
	["@method"] = { link = "Function" },
	["@field"] = { link = "Identifier" },
	["@property"] = { link = "Identifier" },
	["@constructor"] = { link = "Special" },
	["@annotation"] = { link = "PreProc" },
	["@attribute"] = { link = "PreProc" },
	["@namespace"] = { link = "Include" },
	["@conditional"] = { link = "Conditional" },
	["@repeat"] = { link = "Repeat" },
	["@label"] = { link = "Label" },
	["@operator"] = { link = "Operator" },
	["@keyword"] = { link = "Keyword" },
	["@keyword.function"] = { link = "Keyword" },
	["@keyword.operator"] = { link = "Operator" },
	["@exception"] = { link = "Exception" },
	["@type"] = { link = "Type" },
	["@type.builtin"] = { link = "Type" },
	["@include"] = { link = "Include" },
	["@variable.builtin"] = { fg = "#3d6d99" },
	["@comment"] = { link = "Comment" },
	["@structure"] = { link = "Gold1" },
	["@tag"] = { link = "Tag" },
	["@tag.delimiter"] = { link = "Delimiter" },
	["@tag.attribute"] = { link = "PreProc" },
	["@lsp.type.comment"] = { link = "Comment" },
	["@lsp.type.enum"] = { link = "Type" },
	["@lsp.type.interface"] = { link = "Identifier" },
	["@lsp.type.keyword"] = { link = "Keyword" },
	["@lsp.type.namespace"] = { link = "@namespace" },
	["@lsp.type.parameter"] = { link = "@parameter" },
	["@lsp.type.property"] = { link = "@property" },
	["@lsp.type.variable"] = { link = "@variable" },
	["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
	["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
	["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
	["@lsp.typemod.operator.injected"] = { link = "@operator" },
	["@lsp.typemod.string.injected"] = { link = "@string" },
	["@lsp.typemod.variable.injected"] = { link = "@variable" },

	["@codeSpan"] = { bg = "#3c3c3c", fg = "#DCDCDC" },
	["@codeBlock"] = {},
	["@todo"] = { link = "Todo" },
	-- ["@spell"] = { underline = true },

	---Clues
	---@url https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md
   MiniClueBorder = { link = "FloatBorder" },
   MiniClueDescGroup = { link = "Type" },
   -- MiniClueDescSingle = { link = "Identifier" },
   MiniClueNextKey = { },
   -- MiniClueNextKeyWithPostkeys = { },
   MiniClueSeparator = { link = "DiffAdded" },
   MiniClueTitle = { link = "Function" },
}

for group, opts in pairs(groups) do
  vim.api.nvim_set_hl(0, group, opts)
end