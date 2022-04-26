-----------------------------------
--	File: icons.lua
--	Description: K Neovim all icons
--	Author: Kevin
--	Last Modified: 21/03/2022 - 17:52
-----------------------------------

-- Font: SauceCodePro Nerd Font Mono

return {
  kind = {
    Text = "",
    AltText = "",
    AltMethod = "",
    Function = "",
    Constructor = "",
    Method = "",
    AltFunction = "",
    AltConstructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
  },
  type = {
    Array = "",
    Number = "",
    String = "",
    Boolean = "蘒",
    Object = "",
  },
  documents = {
    File = "",
    Files = "",
    Folder = "",
    OpenFolder = "",
    FolderEmpty = "ﰊ",
    default = "*",
  },
  git = {
    -- Change Type
    -- deleted   = "✖",
    -- renamed   = "",
    Add = "",
    Mod = "",
    Ignore = "",
    Remove = "",
    Rename = "➜",
    Diff = "",
    Repo = "",
    -- Status Type
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    untracked = "★",
    conflict  = "",
    -- untracked = "",
    -- ignored   = "",
    -- unstaged  = "",
    -- staged    = "",

  },
  ui = {
    Lock = "",
    Circle = "",
    BigCircle = "",
    BigUnfilledCircle = "",
    Close = "",
    NewFile = "",
    Search = "",
    Lightbulb = "",
    Project = "",
    Dashboard = "",
    History = "",
    Comment = "",
    Bug = "",
    Code = "",
    Telescope = "",
    Gear = "",
    Package = "",
    List = "",
    SignIn = "",
    Check = "",
    Fire = "",
    Note = "",
    BookMark = "",
    Pencil = "",
    ChevronRight = "",
    ChevronLeft = "",
    BoldChevronRight = "",
    BoldChevronLeft = "",
    SlChevronRight = "⟩",
    SlChevronLeft = "⟨",
    SlArrowRight = "",
    AltSlArrowRight = "",
    SlArrowLeft = "",
    AltSlArrowLeft = "",
    Table = "",
    Calendar = "",
    Download = "",
    Plugin = "",
    Packer = "﬘",
    Uni = "",
    Health = "♥️",
    Git = "",
    AppleSym = "",
    Version = "",
  },
  diagnostics = {
    Error = "",
    Warning = "",
    Information = "",
    Question = "",
    Hint = "",
  },
  misc = {
    Robot = "ﮧ",
    Squirrel = "",
    Tag = "",
    Watch = "",
  },
  bufferline = {
    modified_icon = "●",
    close = "",
    buffer_close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
  },
  packer = {
    working_sym = '⟳',
    error_sym = '✗',
    done_sym = '✓',
    removed_sym = '-',
    moved_sym = '→',
    header_sym = '━',
  },
  lsp = {
    nvim_lsp = "[  ]",
    nvim_lua = "[  ]",
    luasnip = "[  ]",
    buffer = "[  ]",
    path = "[  ]",
    treesitter = "[  ]",
    latex_symbols = "[ α ]",
    emoji = "[  ]",
    calc = "[  ]",
  }
}
