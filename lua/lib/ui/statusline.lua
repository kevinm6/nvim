-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 06/07/2025, 11:45
-----------------------------------------

local M = {
  ---name of the session
  session_name = "",
  ---filetypes to exclude
  to_exclude = {
    alpha = true,
    lspinfo = true,
    -- snacks_dashboard = true,
    snacks_picker_input = true,
    snacks_picker_list = true,
    snacks_picker_preview = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    noice = true,
    terminal = true,
    checkhealth = true,
    WhichKey = true,
    query = true,
    oil = true,
    httpResult = true,
  },
  ---width values used to display info if win-size is between
  preset_width = setmetatable({
    filename = 60,
    git_branch = 60,
    git_status_full = 110,
    diagnostic = 128,
    row_onTot = 100,
    lsp_info = 60,
  }, {
    __index = function()
      return 80
    end,
  }),
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
    default = "",
    gradle = "",
  }, {
    __index = function(t, k)
      local has_icons, icons = pcall(require, "mini.icons")
      if not has_icons then
        return ""
      else
        local icon = icons.get("filetype", k)
        -- vim.print(icon)
        t[k] = icon
        return icon
      end
    end,
  }),
}

---Lazy load colors if not added to table
local function load_colors()
  if not M.colors then
    ---highlights value
    M.colors = {
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
    }
  end
end

---Set highlight groups for StatusLine and relative colors.
---This is useful on first start, otherwise they are not overriden.
local function set_color_groups()
  load_colors()
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
  local nmode = M.colors.Nmode
  local vmode = M.colors.Vmode
  local cmode = M.colors.Cmode
  local tmode = M.colors.Tmode
  local imode = M.colors.Imode

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
    ["!"] = M.colors.ShellMode .. "S",
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
  return win_is_smaller(M.preset_width.row_onTot) and string.format(" %s%%l%s/%%L ", M.colors.git, M.colors.fformatloc)
    or string.format(" %s%%l%s/%%L|%%P", M.colors.git, M.colors.fformatloc)
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
  return status_ok and M.colors.diag .. M.icons.status_ok
    or do_not_show_diag and M.colors.diag .. M.icons.status_not_ok
    or string.format(
      "%s%s%s %d %s%s %d %s%s %d %s%s %d",
      M.colors.diag,
      M.colors.diagError,
      M.icons.error,
      errors,
      M.colors.diagWarn,
      M.icons.warning,
      warns,
      M.colors.diagInfo,
      M.icons.information,
      infos,
      M.colors.diagHint,
      M.icons.hint,
      hints
    )
end

---Get lsp progress, trying to remove Noice and mini-view
---@return string progress formatted progress
function M.get_lsp_progress()
  local lsp = vim.lsp.status()
  if lsp then
    local idx = lsp:find(",")
    lsp = vim.trim(lsp:sub(0, idx and idx-1 or nil))
    return (#lsp > M.preset_width.lsp_info) and lsp:sub(1, M.preset_width.lsp_info) .. "…" or lsp
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

    if win_is_smaller(M.preset_width.git_branch) then
      return "• "
    elseif win_is_smaller(M.preset_width.git_branch, M.preset_width.git_status_full) or no_changes then
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
  local icon = M.icons.default
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
  return M.session_name ~= "" and " Session: " .. M.session_name .. " " or ""
end

---Get python virtual-env if is active and in python file
---@return string env_name name of python env or empty string
local function get_python_env()
  -- if vim.bo.filetype == "python" then
  if not win_is_smaller(M.preset_width.git_branch) then
    local venv = os.getenv "VIRTUAL_ENV"
    if venv then
      if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
          final_venv = w
        end
        venv = final_venv
      end
      local kernels = ""
      if vim.bo.filetype == "quarto" and vim.endswith(get_filename(), "ipynb") then
        kernels = require("molten.status").kernels()
      end
      return kernels ~= "" and string.format(" 󰌠 (%s) [%s] ", venv, kernels) or string.format(" 󰌠 (%s) ", venv)
    end
  end
  -- end
  return ""
end

---Get lsp status and if active get names of server running
---@return string lsp_status
local function get_lsp_info()
  return #vim.lsp.get_clients { bufnr = 0 } ~= 0 and string.format("%s• ", M.colors.name)
    or string.format("%s• ", M.colors.lspnoactive)
end

---Statusline disabled that display only filetype and current mode
---@return string simple_statusline
local function disabled_statusline()
  local ftype_name = string.format("%s %s", "", vim.bo.filetype)
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"

  local special_filetypes = {
    -- snacks_dashboard = M.icons.dashboard .. " Dashboard",
    oil = M.icons.folder .. " File Explorer",
    lazy = M.icons.table .. " Plugin Manager",
    lspinfo = M.icons.lsp_info .. " LSP Status",
    snacks_picker_input = M.icons.search .. " Picker•Input",
    snacks_picker_list = M.icons.list .. " Picker•List",
    snacks_picker_preview = M.icons.default .. " Picker•Preview",
    qf = M.icons.config .. " QuickFix",
    terminal = M.icons.robots .. "Terminal",
    mason = M.icons.list .. " Package Manager",
    Outline = M.icons.table .. " Symbols Outline",
    noice = M.icons.list .. " Notifications",
    checkhealth = M.icons.checkhealth .. " Health",
    query = M.icons.query .. " Query",
    dbui = M.icons.db .. " Database",
    httpResult = M.icons.web .. " Http",
    dapui_hover = M.icons.dapui_hover .. " DapUI•Hover",
    dapui_watches = M.icons.dapui_watches .. " DapUI•Watches",
    dapui_stacks = M.icons.dapui_stacks .. " DapUI•Stacks",
    dapui_console = M.icons.dapui_console .. " DapUI•Console",
    dapui_scopes = M.icons.dapui_scopes .. " DapUI•Scopes",
    dapui_breakpoints = M.icons.dapui_breakpoints .. " DapUI•Breakpoints",
    ["dap-float"] = M.icons.dapui_watches .. " DapUI•Hover",
    ["dap-repl"] = M.icons.robots .. " DapUI•Repl",
  }
  local custom_ft = special_filetypes[vim.bo.filetype]

  return table.concat {
    M.colors.mode,
    get_mode(),
    modifiedReadOnlyFlags,
    M.colors.inverted,
    "",
    sideSep,
    M.colors.inactive,
    custom_ft or ftype_name,
    sideSep,
  }
end

---Statusline enabled with all items
---@return string statusline
local function enabled_statusline()
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"
  local space = " "

  M.cached = {
    -- LeftSide
    M.colors.mode,
    get_mode(),
    M.colors.inverted,
    "",
    modifiedReadOnlyFlags,
    space,
    M.colors.git,
    "%<" .. get_git_status(),
    M.colors.name,
    get_filename(),
    M.colors.symbols,
    "",
    M.colors.empty,
    session_name(),
    get_python_env(),
    space,
    [[%{luaeval("require'lib.ui.statusline'.get_lsp_progress()")}]],
    space,
    -- get_lsp_progress(),

    -- Middle
    sideSep,
    get_lsp_diagnostic(),
    space,

    -- Right Side
    M.colors.symbols,
    "",
    get_lsp_info(),
    M.colors.ftype,
    get_filetype_and_icon(),
    M.colors.encoding,
    get_fencoding(),
    M.colors.fformatloc,
    get_fformat(),
    get_line_onTot(),
    M.colors.inverted,
    "",
  }

  return table.concat(M.cached)
end

---Set statusline based on filetype of current buffer
function M.set()
  if not vim.g.statusline_color then
    set_color_groups()
  end
  if not M.to_exclude[vim.bo.filetype] then
    vim.wo.statusline = enabled_statusline()
  else
    vim.wo.statusline = disabled_statusline()
  end
end

---Define autocmds for load winbar module and initialize
function M.toggle()
  if vim.g.statusline ~= nil then
    vim.api.nvim_del_autocmd(vim.g.statusline)
    vim.wo.statusline = ""
    vim.g.statusline = nil
    vim.g.statusline_color = nil
  else
    vim.api.nvim_create_autocmd({
      "BufNewFile",
      "CursorMoved",
      "ModeChanged",
      "VimResized",
      "FileType",
      "FileChangedShellPost",
      "DiagnosticChanged",
      "LspProgress",
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

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      if vim.g.statusline ~= nil then
        set_color_groups()
      end
    end,
  })
end

vim.api.nvim_create_user_command("ToggleStatusline", M.toggle, { desc = "Toggle Statusline" })

return M