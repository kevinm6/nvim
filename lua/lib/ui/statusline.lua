-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 26 Dec 2024, 11:00
-----------------------------------------

local sl = {
  ---name of the session
  session_name = "",
  ---filetypes to exclude
  to_exclude = {
    alpha = true,
    dashboard = true,
    lspinfo = true,
    TelescopePrompt = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    noice = true,

    checkhealth = true,
    WhichKey = true,
    query = true,
    oil = true,
    httpResult = true,
    dapui_hover = true,
    ["dap-float"] = true,
  },
  ---width values used to display info if win-size is between
  preset_width = setmetatable({
    filename = 60,
    git_branch = 60,
    git_status_full = 110,
    diagnostic = 128,
    row_onTot = 100,
    lsp_info = 100,
  }, {
    __index = function()
      return 80
    end,
  }),
  ---highlights value
  colors = {
    inactive = "%#StatusLineInactive#",
    mode = "%#StatusLineMode#",
    git = "%#StatusLineGit#",
    diag = "%#StatusLineGpsDiagnostic#",
    diagError = "%#SLDiagnosticError#",
    diagWarn = "%#SLDiagnosticWarn#",
    diagInfo = "%#SLDiagnosticInfo#",
    diagHint = "%#SLDiagnosticHint#",
    lspactive = "%#StatusLineLspActive#",
    lspnoactive = "%#StatusLineLspNotActive#",
    ftype = "%#StatusLineFileType#",
    empty = "%#StatusLineEmptyspace#",
    lite = "%#StatusLineLite#",
    name = "%#StatusLineFileName#",
    encoding = "%#StatusLineFileEncoding#",
    fformatloc = "%#StatusLineFileFormatLocation#",
    session = "%#StatusLineSession#",
    inverted = "%#StatusLineInverted#",
    symbols = "%#StatuslineSymbols#",
    Nmode = "%#Nmode#",
    Vmode = "%#Vmode#",
    Imode = "%#Imode#",
    Cmode = "%#Cmode#",
    Tmode = "%#Tmode#",
    ShellMode = "%#Tmode#",
  },
  icons = setmetatable({
    error = "",
    warning = "",
    information = "",
    hint = "󱧢",
    status_ok = "",
    status_not_ok = "",
    dashboard = "",
    folder = "",
    lsp_info = "󰒓",
    telescope = "",
    config = "󰒓",
    robots = "󰚩",
    table = "",
    list = "",
    checkhealth = "♥",
    search = "",
    query = "󱩾",
    web = "󰖟",
    db = "󰆼",
    dapui_hover = "󰃤",
    dapui_watches = "󰃤",
    default = "",
  }, {
    __index = function(t, k)
      local has_icons, icons = pcall(require, "mini.icons")
      if not has_icons then
        return ""
      else
        local icon = icons.get("filetype", k)
        vim.print(icon)
        t[k] = icon
        return icon
      end
    end,
  }),
}

---Set highlight groups for StatusLine and relative colors.
---This is useful on first start, otherwise they are not overriden.
local function set_color_groups()
  vim.g.statusline_color = true

  local hls = {
    -- StatusLine
    StatusLine = { fg = "#626262", bg = "#1c1c1c" },
    StatusLineNC = { fg = "#868686", bg = "#1c1c1c" },
    StatusLineTerm = { fg = "#626262", bg = "NONE" },
    StatusLineTermNC = { fg = "#A9A9A9", bg = "#2c2c2c" },
    StatusLineMode = { fg = "#158C8A" },
    StatusLineGit = { fg = "#af8700", bg = "#2c2c2c" },
    StatusLineFileName = { fg = "#36FF5A", bg = "#2c2c2c" },
    StatusLineLspActive = { fg = "#4c4c4c", bg = "#2c2c2c" },
    StatusLineLspNotActive = { fg = "#3c3c3c", bg = "#2c2c2c" },
    StatusLineFileEncoding = { fg = "#86868B", bg = "#2c2c2c" },
    StatusLineFileType = { fg = "#158C8A", bg = "#2c2c2c" },
    StatusLineFileFormatLocation = { fg = "#86868B", bg = "#2c2c2c" },
    StatusLineGpsDiagnostic = { fg = "#3c3c3c", bg = "#262626" },
    StatusLineInverted = { fg = "#1c1c1c", bg = "#2c2c2c" },
    StatusLineEmptyspace = { fg = "#3c3c3c", bg = "#262626" },
    StatusLineLite = { fg = "#dcdcdc", bg = "#1c1c1c" },
    StatusLineInactive = { fg = "#5c5c5c", bg = "#2c2c2c" },
    StatuslineSymbols = { fg = "#2c2c2c", bg = "#262626" },
    SLDiagnosticError = { fg = "#f44757", bg = "#262626" },
    SLDiagnosticWarn = { fg = "#ff8800", bg = "#262626" },
    SLDiagnosticHint = { fg = "#4fc1ff", bg = "#262626" },
    SLDiagnosticInfo = { fg = "#00ffaa", bg = "#262626" },
  }

  for group, settings in pairs(hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

---Get active Nvim mode and the highlight group
---@return string mode colorful mode or mode_code
local function get_mode()
  local nmode = sl.colors.Nmode
  local vmode = sl.colors.Vmode
  local cmode = sl.colors.Cmode
  local tmode = sl.colors.Tmode
  local imode = sl.colors.Imode

  local mode = {
    ["n"] = nmode .. "N",
    ["no"] = nmode .. "O·P",
    ["nov"] = nmode .. "O·P",
    ["noV"] = nmode .. "O·P",
    ["no\22"] = nmode .. "O·P",
    ["niI"] = nmode .. "N",
    ["niR"] = nmode .. "N",
    ["niV"] = nmode .. "N",
    ["nt"] = nmode .. "N",
    ["ntT"] = nmode .. "N",
    ["v"] = vmode .. "V",
    ["vs"] = vmode .. "V",
    ["V"] = vmode .. "V·L",
    ["Vs"] = vmode .. "V·L",
    ["\22"] = vmode .. "V·B",
    ["\22s"] = vmode .. "V·B",
    ["s"] = vmode .. "S",
    ["S"] = vmode .. "S·L",
    ["\19"] = vmode .. "S·B",
    ["i"] = imode .. "I",
    ["ic"] = imode .. "I",
    ["ix"] = imode .. "I",
    ["R"] = cmode .. "R",
    ["Rc"] = cmode .. "R",
    ["Rx"] = cmode .. "R",
    ["Rv"] = cmode .. "V·R",
    ["Rvc"] = cmode .. "V·R",
    ["Rvx"] = cmode .. "V·R",
    ["c"] = cmode .. "C",
    ["cv"] = cmode .. "EX",
    ["ce"] = cmode .. "EX",
    ["r"] = tmode .. "R",
    ["rm"] = nmode .. "M",
    ["r?"] = nmode .. "C",
    ["!"] = sl.colors.ShellMode .. "S",
    ["t"] = tmode .. "T",
  }

  local mode_code = vim.api.nvim_get_mode().mode
  return mode[mode_code] or mode_code
end

---Check window size compared to args.
---if 2 args are passed checks if win_width is between or equal to lower and upper,
---otherwise check if win_width is bigger than single value passed.
---@param lower number lower bound or minimum width allowed
---@param upper number? upper bound, if passed
---@return boolean win_is_smaller true if window width is smaller than passed args or
---between if 2 args are passed
local function win_is_smaller(lower, upper)
  upper = upper or nil
  local win_size = vim.api.nvim_win_get_width(0)
  return upper ~= nil and (win_size >= lower and win_size <= upper) or win_size < lower
end

---Get location in current buffer (current row on total rows)
---@return string line number on total number
local function get_line_onTot()
  return win_is_smaller(sl.preset_width.row_onTot)
      and string.format(" %s%%l%s/%%L ", sl.colors.git, sl.colors.fformatloc)
    or string.format(" %s%%l%s/%%L|%%P", sl.colors.git, sl.colors.fformatloc)
end

---Get file name
---@return string filename name of the current file
local function get_filename()
  local cols = vim.o.columns
  local fname = vim.fn.expand "%:f"
  local to_trunc = #fname >= (cols * 0.26)
  local truncated_name = vim.fn.expand "%:t"
  return to_trunc and truncated_name or fname
end

---Get lsp diagnostics data
---@return string diagnostic diagnostic formatted data
local function get_lsp_diagnostic()
  local do_not_show_diag = win_is_smaller(80)

  local diagnostics = nil
  local errors, warns, infos, hints = 0, 0, 0, 0
  local status_ok = false

  diagnostics = vim.diagnostic.count(0)
  errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
  warns = diagnostics[vim.diagnostic.severity.WARN] or 0
  infos = diagnostics[vim.diagnostic.severity.INFO] or 0
  hints = diagnostics[vim.diagnostic.severity.HINT] or 0
  status_ok = #diagnostics == 0

  -- display values only if there are any
  return status_ok and sl.colors.diag .. sl.icons.status_ok
    or do_not_show_diag and sl.colors.diag .. sl.icons.status_not_ok
    or string.format(
      "%s%s%s %d %s%s %d %s%s %d %s%s %d",
      sl.colors.diag,
      sl.colors.diagError,
      sl.icons.error,
      errors,
      sl.colors.diagWarn,
      sl.icons.warning,
      warns,
      sl.colors.diagInfo,
      sl.icons.information,
      infos,
      sl.colors.diagHint,
      sl.icons.hint,
      hints
    )
end

---Get lsp progress, trying to remove Noice and mini-view
---@return string progress formatted progress
local function get_lsp_progress()
  local lsp = vim.lsp.status()
  if lsp then
    vim.print(lsp)
    -- sanitize percentage
    lsp = vim.fn.fnameescape(lsp)
    -- lsp = lsp:gsub(":", " "):gsub("(%d+%%)", "%1%%"):gsub("%s+", " ")

    return (#lsp > 40) and string.sub(lsp, 1, 38) .. "…" or lsp
  end

  return ""
end

---Get git status with `gitsigns` plugin
---and display data depending on available window width
---@return string git_status git formatted data
local function get_git_status()
  local signs = vim.b["gitsigns_status_dict"] or nil
  if not signs then
    return ""
  end

  local add, change, remove = signs.added or 0, signs.changed or 0, signs.removed or 0

  local no_changes = (add + change + remove) == 0

  -- display based on size of window
  --  if no changes, display only head (if available)
  if signs.head ~= nil then
    local head = signs.head

    if win_is_smaller(sl.preset_width.git_branch) then
      return "• "
    elseif win_is_smaller(sl.preset_width.git_branch, sl.preset_width.git_status_full) or no_changes then
      return string.format(" %s ", head)
    else
      return string.format("+%s ~%s -%s |  %s ", add, change, remove, head)
    end
  else
    return "•"
  end
end

---Get filetype with icon if available
---@return string filetype icon? and filetype
local function get_filetype_and_icon()
  local file_ext = vim.bo.filetype or vim.fn.expand "%:e"

  local has_icons, icons = pcall(require, "mini.icons")
  local icon = sl.icons.default
  if has_icons then
    icon = icons.get("filetype", file_ext)
  end
  local file_type = vim.bo.filetype

  return string.format("%s %s", icon, file_type)
end

---Get file encoding
---@return string file_encoding current buf file-encoding or empty string
local function get_fencoding()
  return not win_is_smaller(76) and " %{&fileencoding?&fileencoding:&encoding} " or ""
end

---Get file format
---@return string file_format current buf file-format or empty string
local function get_fformat()
  return not win_is_smaller(76) and "%{&ff}" or ""
end

---Get session name if active
---@return string session_name name of the active session or empty string
local function session_name()
  return sl.session_name ~= "" and " Session: " .. sl.session_name or ""
end

---Get python virtual-env if is active and in python file
---@return string env_name name of python env or empty string
local function get_python_env()
  -- if vim.bo.filetype == "python" then
  if not win_is_smaller(sl.preset_width.git_branch) then
    local venv = os.getenv "VIRTUAL_ENV"
    if venv then
      if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
          final_venv = w
        end
        venv = final_venv
      end
      return string.format(" 󰌠 (%s)", venv)
    end
  end
  -- end
  return ""
end

---Get lsp status and if active get names of server running
---@return string lsp_status
local function get_lsp_info()
  return #vim.lsp.get_clients() ~= 0 and string.format("%s• ", sl.colors.name)
    or string.format("%s• ", sl.colors.lspnoactive)
end

---Statusline disabled that display only filetype and current mode
---@return string simple_statusline
local function disable_statusline()
  local ftype_name = string.format("%s %s", "", vim.bo.filetype)
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"

  local special_filetypes = {
    dashboard = sl.icons.dashboard .. " Dashboard",
    alpha = sl.icons.dashboard .. " Dashboard",
    oil = sl.icons.folder .. " File Explorer",
    lazy = sl.icons.checkhealth .. " Plugin Manager",
    lspinfo = sl.icons.lsp_info .. " LSP Status",
    TelescopePrompt = sl.icons.telescope .. " Telescope",
    qf = sl.icons.config .. " QuickFix",
    toggleterm = sl.icons.robots .. "Terminal",
    mason = sl.icons.list .. " Package Manager",
    Outline = sl.icons.table .. " Symbols Outline",
    noice = sl.icons.list .. " Notifications",
    checkhealth = sl.icons.checkhealth .. " Health",
    WhichKey = sl.icons.search .. " WhichKey",
    query = sl.icons.query .. " Query",
    dbui = sl.icons.db .. " Database",
    httpResult = sl.icons.web .. " Http",
    dapui_hover = sl.icons.dapui_hover .. " DapUI•Hover",
    ["dap-float"] = sl.icons.dapui_watches .. " DapUI•Hover",
  }
  local custom_ft = special_filetypes[vim.bo.filetype]

  return table.concat {
    sl.colors.mode,
    get_mode(),
    modifiedReadOnlyFlags,
    sl.colors.inverted,
    "",
    sideSep,
    sl.colors.inactive,
    custom_ft or ftype_name,
    sideSep,
  }
end

---Statusline enabled with all items
---@return string statusline
local function enable_statusline()
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"
  local space = " "

  sl.cached = {
    -- LeftSide
    sl.colors.mode,
    get_mode(),
    sl.colors.inverted,
    "",
    modifiedReadOnlyFlags,
    space,
    sl.colors.git,
    get_git_status(),
    sl.colors.name,
    "%<" .. get_filename(),
    sl.colors.symbols,
    "",
    sl.colors.empty,
    session_name(),
    -- get_lsp_progress(),
    get_python_env(),

    -- Middle
    sideSep,
    get_lsp_diagnostic(),
    space,

    -- Right Side
    sl.colors.symbols,
    "",
    get_lsp_info(),
    sl.colors.ftype,
    get_filetype_and_icon(),
    sl.colors.encoding,
    get_fencoding(),
    sl.colors.fformatloc,
    get_fformat(),
    get_line_onTot(),
    sl.colors.inverted,
    "",
  }

  return table.concat(sl.cached)
end

---Set statusline based on filetype of current buffer
function sl.set()
  if not vim.g.statusline_color then
    set_color_groups()
  end
  if not sl.to_exclude[vim.bo.filetype] then
    vim.wo.statusline = enable_statusline()
  else
    vim.wo.statusline = disable_statusline()
  end
end

---Define autocmds for load winbar module and initialize
function sl.toggle()
  if vim.g.statusline ~= nil then
    vim.api.nvim_del_autocmd(vim.g.statusline)
    vim.wo.statusline = ""
    vim.g.statusline = nil
  else
    vim.api.nvim_create_autocmd({
      "BufNewFile",
      "CursorMoved",
      "ModeChanged",
      "VimResized",
      "FileType",
      "FileChangedShellPost",
      "DiagnosticChanged",
      -- "LspProgress",
    }, {
      group = vim.api.nvim_create_augroup("_statusline", { clear = true }),
      callback = function(cb)
        if vim.g.statusline ~= nil then
          vim.api.nvim_eval_statusline("%!v:lua.require'lib.ui.statusline'.set()", {})
        else
          vim.g.statusline = cb.id
        end
      end,
    })
    vim.api.nvim_eval_statusline("%!v:lua.require'lib.ui.statusline'.set()", {})
  end
end

vim.api.nvim_create_user_command("ToggleStatusline", sl.toggle, { desc = "Toggle Statusline" })

return sl
