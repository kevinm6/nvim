-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 05 Dec 2023, 17:38
-----------------------------------------

local M = {
  session_name = ""
}

---Table of preset width used to avoid display some elements
---if window width is not enough.
local preset_width = setmetatable({
  filename = 60,
  git_branch = 60,
  git_status_full = 110,
  diagnostic = 128,
  row_onTot = 100,
  lsp_info = 100,
}, {
    __index = function()
      return 80
    end
  })


---Set highlight groups for StatusLine and relative colors.
---This is useful on first start, otherwise they are not overriden.
local function set_color_groups()
  vim.g.statusline_color = true

  local hls = {
    -- StatusLine
    StatusLine              = { fg = "#626262", bg = "#1c1c1c" },
    StatusLineNC            = { fg = "#868686", bg = "#1c1c1c" },
    StatusLineTerm          = { fg = "#626262", bg = "NONE" },
    StatusLineTermNC        = { fg = "#A9A9A9", bg = "#2c2c2c" },
    StatusLineMode          = { fg = "#158C8A" },
    StatusLineGit           = { fg = "#af8700", bg = "#2c2c2c" },
    StatusLineFileName      = { fg = "#36FF5A", bg = "#2c2c2c" },
    StatusLineLspActive     = { fg = "#4c4c4c", bg = "#2c2c2c" },
    StatusLineLspNotActive  = { fg = "#3c3c3c", bg = "#2c2c2c" },
    StatusLineFileEncoding  = { fg = "#86868B", bg = "#2c2c2c" },
    StatusLineFileType      = { fg = "#158C8A", bg = "#2c2c2c" },
    StatusLineFileFormatLocation = { fg = "#86868B", bg = "#2c2c2c" },
    StatusLineGpsDiagnostic = { fg = "#3c3c3c", bg = "#262626" },
    StatusLineInverted      = { fg = "#1c1c1c", bg = "#2c2c2c" },
    StatusLineEmptyspace    = { fg = "#3c3c3c", bg = "#262626" },
    StatusLineLite          = { fg = "#dcdcdc", bg = "#1c1c1c" },
    StatusLineInactive      = { fg = "#5c5c5c", bg = "#2c2c2c" },
    StatuslineSymbols       = { fg = "#2c2c2c", bg = "#262626" },
    SLDiagnosticError       = { fg = "#f44757", bg = "#2c2c2c" },
    SLDiagnosticWarn        = { fg = "#ff8800", bg = "#2c2c2c" },
    SLDiagnosticHint        = { fg = "#4fc1ff", bg = "#2c2c2c" },
    SLDiagnosticInfo        = { fg = "#00ffaa", bg = "#2c2c2c" },
  }

  for group, settings in pairs(hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end


local colors = {
  inactive    = "%#StatusLineInactive#",
  mode        = "%#StatusLineMode#",
  git         = "%#StatusLineGit#",
  diag        = "%#StatusLineGpsDiagnostic#",
  diagError   = "%#SLDiagnosticError#",
  diagWarn    = "%#SLDiagnosticWarn#",
  diagInfo    = "%#SLDiagnosticInfo#",
  diagHint    = "%#SLDiagnosticHint#",
  lspactive   = "%#StatusLineLspActive#",
  lspnoactive = "%#StatusLineLspNotActive#",
  ftype       = "%#StatusLineFileType#",
  empty       = "%#StatusLineEmptyspace#",
  lite        = "%#StatusLineLite#",
  name        = "%#StatusLineFileName#",
  encoding    = "%#StatusLineFileEncoding#",
  fformatloc  = "%#StatusLineFileFormatLocation#",
  session     = "%#StatusLineSession#",
  inverted    = "%#StatusLineInverted#",
  symbols     = "%#StatuslineSymbols#",
  Nmode       = "%#Nmode#",
  Vmode       = "%#Vmode#",
  Imode       = "%#Imode#",
  Cmode       = "%#Cmode#",
  Tmode       = "%#Tmode#",
  ShellMode   = "%#Tmode#",
}


local function get_mode()
  local nmode = colors.Nmode
  local vmode = colors.Vmode
  local cmode = colors.Cmode
  local tmode = colors.Tmode
  local imode = colors.Imode

  local mode = {
    ['n']      = nmode..'N',
    ['no']     = nmode..'O·P',
    ['nov']    = nmode..'O·P',
    ['noV']    = nmode..'O·P',
    ['no\22']  = nmode..'O·P',
    ['niI']    = nmode..'N',
    ['niR']    = nmode..'N',
    ['niV']    = nmode..'N',
    ['nt']     = nmode..'N',
    ['ntT']    = nmode..'N',
    ['v']      = vmode..'V',
    ['vs']     = vmode..'V',
    ['V']      = vmode..'V·L',
    ['Vs']     = vmode..'V·L',
    ['\22']    = vmode..'V·B',
    ['\22s']   = vmode..'V·B',
    ['s']      = vmode..'S',
    ['S']      = vmode..'S·L',
    ['\19']    = vmode..'S·B',
    ['i']      = imode..'I',
    ['ic']     = imode..'I',
    ['ix']     = imode..'I',
    ['R']      = cmode..'R',
    ['Rc']     = cmode..'R',
    ['Rx']     = cmode..'R',
    ['Rv']     = cmode..'V·R',
    ['Rvc']    = cmode..'V·R',
    ['Rvx']    = cmode..'V·R',
    ['c']      = cmode..'C',
    ['cv']     = cmode..'EX',
    ['ce']     = cmode..'EX',
    ['r']      = tmode..'R',
    ['rm']     = nmode..'M',
    ['r?']     = nmode..'C',
    ['!']      = colors.ShellMode..'S',
    ['t']      = tmode..'T',
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
local function get_line_onTot()
  return win_is_smaller(preset_width.row_onTot) and string.format(" %s%%l%s+%%L ", colors.git, colors.fformatloc)
    or colors.fformatloc .. " row " .. colors.git .. "%l" .. colors.fformatloc .. "÷%L "
end

---Get file name
local function get_filename()
  local cols = vim.o.columns
  local fname = tostring(vim.fn.expand "%f ")
  local to_trunc = #fname >= preset_width.filename or #fname >= (cols * 0.26)
  local truncated_name = "..." .. string.sub(fname, #fname - (cols * 0.20), -1)

  return to_trunc and truncated_name or fname
end


---Get lsp diagnostics data
local function get_lsp_diagnostic()
  local do_not_show_diag = win_is_smaller(80)

  local diagnostics, errors, warns, infos, hints = nil, 0, 0, 0, 0
  local status_ok = false

  -- remove check when has nvim-0.10
  if vim.diagnostic.count ~= nil then
    diagnostics = vim.diagnostic.count(0)
    errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
    warns  = diagnostics[vim.diagnostic.severity.WARN] or 0
    infos  = diagnostics[vim.diagnostic.severity.INFO] or 0
    hints  = diagnostics[vim.diagnostic.severity.HINT] or 0
    status_ok = #diagnostics == 0
  else
    -- assign to relative vars the count of diagnostics
    errors = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.ERROR }})
    warns  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.WARN }})
    infos  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.INFO }})
    hints  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.HINT }})
    status_ok = (errors + warns + infos + hints) == 0
  end

  local icons = require "lib.icons"

  -- display values only if there are any
  return status_ok and colors.diag .. icons.diagnostics.status_ok or
    do_not_show_diag and colors.diag .. icons.diagnostics.status_not_ok or
    string.format(
      "%s%s%s:%d %s%s:%d %s%s:%d %s%s:%d",
      colors.diag,
      colors.diagError, icons.diagnostics.Error, errors,
      colors.diagWarn, icons.diagnostics.Warning, warns,
      colors.diagInfo, icons.diagnostics.Information, infos,
      colors.diagHint, icons.diagnostics.Hint, hints
    )
end

---Get git status with gitsigns
local function get_git_status()
  local signs = vim.b['gitsigns_status_dict'] or nil
  if not signs then return "" end

  local add, change, remove = signs.added or 0, signs.changed or 0, signs.removed or 0

  local no_changes = (add + change + remove) == 0

  -- display based on size of window
  --  if no changes, display only head (if available)
  if signs.head ~= nil then
    local head = signs.head

    if win_is_smaller(preset_width.git_branch) then
      return "• "
    elseif win_is_smaller(preset_width.git_branch, preset_width.git_status_full) or no_changes then
      return string.format(" %s ", head)
    else
      return string.format("+%s ~%s -%s |  %s ", add, change, remove, head)
    end
  else
    return "•"
  end
end

---Get filetype with icon if available
local function get_filetype()
  local file_name, file_ext = vim.fn.expand "%:t", vim.fn.expand "%:e"
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  local icons, icon = require "lib.icons", ""

  if has_devicons ~= nil then
    icon = devicons.get_icon(file_name, file_ext)
  end
  local file_type = vim.bo.filetype

  return file_type and has_devicons and { icon = icon, name = file_type }
    or { name = file_type }
    or icons.diagnostics.Error
end

---Get file encoding
local function get_fencoding()
  return not win_is_smaller(76) and " %{&fileencoding?&fileencoding:&encoding} " or ""
end

---Get file format
local function get_fformat()
  return not win_is_smaller(76) and "%{&ff}" or ""
end

---Get session name if active
local function session_name()
  return M.session_name ~= "" and string.format("Session: %s%s", colors.session, M.session_name) or ""
end

---Get python virtual-env if is active and in python file
local function get_python_env()
  -- if vim.bo.filetype == "python" then
  if not win_is_smaller(preset_width.git_branch) then
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
local function get_lsp_info()
  -- TODO: remove when update to nvim-0.10
  local buf_clients = vim.fn.has("nvim-0.10") == 1 and vim.lsp.get_clients() or
  vim.lsp.get_active_clients { bufnr = 0 }

  return #buf_clients ~= 0 and
    string.format("%s• ", colors.name) or
    string.format("%s• ", colors.lspnoactive)
end

---Check if current filetype match the filetype to exclude
---@return boolean
local function to_exclude()
  local special_ft = {
    alpha           = true,
    dashboard       = true,
    NvimTree        = true,
    lspinfo         = true,
    TelescopePrompt = true,
    qf              = true,
    toggleterm      = true,
    lazy            = true,
    mason           = true,
    Outline         = true,
    noice           = true,
    checkhealth     = true,
    WhichKey        = true,
    query           = true,
    dbui            = true,
    oil             = true
  }

  return special_ft[vim.bo.filetype]
end


---Statusline disabled that display only filetype and current mode
---@return string simple_statusline
M.off = function()
  local ftype_name = string.format("%s %s", "", vim.bo.filetype)
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"

  local icons = require "lib.icons"

  local special_filetypes = {
    dashboard       = icons.ui.Plugin .. " Dashboard",
    alpha           = icons.ui.Plugin .. " Dashboard",
    oil             = icons.documents.OpenFolder .. " File Explorer",
    lazy            = icons.ui.PluginManager .. " Plugin Manager",
    lspinfo         = icons.ui.Health .. " LSP Status",
    TelescopePrompt = icons.ui.Telescope .. " Telescope",
    qf              = icons.ui.Gear .. " QuickFix",
    toggleterm      = icons.misc.Robot ..  "Terminal",
    mason           = icons.ui.List .. " Package Manager",
    Outline         = icons.ui.Table .. " Symbols Outline",
    noice           = icons.ui.List .. " Notifications",
    checkhealth     = icons.ui.Health .. " Health",
    WhichKey        = icons.ui.Search .. " WhichKey",
    query           = icons.ui.Query .. " Query",
    dbui            = icons.ui.Db .. " Database",
  }
  local custom_ft = special_filetypes[vim.bo.filetype]

  return table.concat({
    colors.mode,
    get_mode(),
    modifiedReadOnlyFlags,
    colors.inverted,
    icons.ui.SlArrowRight,
    sideSep,
    colors.inactive,
    custom_ft or ftype_name,
    sideSep
  })
end


---Statusline enabled with all items
---@return string statusline
M.on = function()
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"
  local space = " "

  local icons = require "lib.icons"

  local sl = {
    -- LeftSide
    colors.mode, get_mode(),
    colors.inverted, icons.ui.SlArrowRight,
    modifiedReadOnlyFlags, space,
    colors.git, get_git_status(),
    colors.name, get_filename(),
    colors.symbols, icons.ui.SlArrowRight,
    colors.empty,
    session_name(),
    get_python_env(),

    -- Middle
    sideSep,
    get_lsp_diagnostic(),
    space,

    -- Right Side
    colors.symbols, icons.ui.SlArrowLeft, get_lsp_info(),
    colors.ftype, get_filetype().icon or "",
    space,
    get_filetype().name,
    colors.encoding, get_fencoding(),
    colors.fformatloc, get_fformat(),
    get_line_onTot(),
    colors.inverted, icons.ui.SlArrowLeft
  }

  return table.concat(sl)
end

---Set statusline based on filetype of current buffer
M.set = function()
  if not vim.g.statusline_color then set_color_groups() end
  if not to_exclude() then
    vim.wo.statusline = M.on()
  else
    vim.wo.statusline = M.off()
  end
end


M.toggle = function()
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
    }, {
        group = vim.api.nvim_create_augroup("_statusline", { clear = true }),
        callback = function(cb)
          if vim.g.statusline ~= nil then
            vim.api.nvim_eval_statusline(
              "%!v:lua.require'config.statusline'.set()", {})
          else
            vim.g.statusline = cb.id
          end
        end
      })
  end
end

vim.api.nvim_create_user_command("ToggleStatusline", function()
  M.toggle()
end, { desc = "Toggle StatuLine" })

return M