-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 28 Jan 2026, 13:49
-----------------------------------------

local M = {}

local icons = require "lib.ui.icons"
local lib_activity = require "lib.activity"

local state = {}

----------------
---Utilities
----------------

---Sanitize string for statusline
---@param str string?
local function sanitize_stl(str)
  return (str or ""):gsub("%%", "%%%%")
end

---Check window size compared to args.
---if 2 args are passed checks if win_width is between or equal to lower and upper,
---otherwise check if win_width is bigger than single value passed.
---@param win_width number current window width
---@param lower number lower bound or minimum width allowed
---@param upper number? upper bound, if passed
---@return boolean win_is_smaller true if window width is smaller than passed args or
---between if 2 args are passed
local function win_is_smaller(win_width, lower, upper)
  upper = upper or nil
  return upper ~= nil and (win_width >= lower and win_width <= upper) or win_width < lower
end


----------------
---Icons & presets
----------------

M.to_exclude = {
  [""] = true,
  lspinfo = true,
  snacks_terminal = true,
  snacks_picker_input = true,
  snacks_picker_list = true,
  snacks_picker_preview = true,
  qf = true,
  toggleterm = true,
  mason = true,
  terminal = true,
  checkhealth = true,
  query = true,
  oil = true,
  httpResult = true,
  minifiles = true,
  gradle_output = true,
  ["nvim-pack"] = true,
}

M.preset_width = setmetatable({
  filename = 60,
  git_branch = 50,
  git_status_full = 110,
  diagnostic = 128,
  row_onTot = 100,
  lsp_info = 60,
}, {
  __index = function() return 80 end,
})

----------------
---Colors
----------------

---Lazy load colors if not added to table
local function load_colors()
  if state.colors then return end
  ---highlights value
  state.colors = {
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

----------------
---Mode
----------------

---Set active Nvim mode and the highlight group
local function set_mode()
  if state.mode then return end

  local nmode = state.colors.Nmode
  local vmode = state.colors.Vmode
  local cmode = state.colors.Cmode
  local tmode = state.colors.Tmode
  local imode = state.colors.Imode

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
    ["!"] = state.colors.ShellMode .. "S",
    ["t"] = tmode .. "T",
  }

  local mode_code = vim.api.nvim_get_mode().mode
  state.mode = mode[mode_code] or mode_code
end

---Set highlight groups for StatusLine and relative colors.
---This is useful on first start, otherwise they are not overriden.
local function set_color_groups()
  if state.colors then return end
  load_colors()

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

----------------
---Segments
----------------

---Set file name
local function set_filename()
  if state.filename then return end
  local fname = sanitize_stl(vim.fn.expand "%:f")
  local win_width = vim.api.nvim_win_get_width(0)
  local to_trunc = #fname >= (win_width * 0.26)
  state.filename = to_trunc and sanitize_stl(vim.fn.expand "%:t") or fname
end

---Set git status with `minidiff` plugin
---and display data depending on available window width
local function set_git_status()
  if state.git and state.git ~= "" then return end

  local win_width = vim.api.nvim_win_get_width(0)
  local signs = vim.b["minidiff_summary"] or nil
  if not signs then
    state.git = ""
    return
  end

  local add, change, delete = signs.add or 0, signs.change or 0, signs.delete or 0

  local no_changes = (add + change + delete) == 0

  if signs.source_name == "git" then
    local head = M.branch

    if no_changes or (win_is_smaller(win_width, M.preset_width.git_branch) or win_is_smaller(win_width, M.preset_width.git_branch, M.preset_width.git_status_full)) then
      state.git = (" %s "):format(head)
    else
      state.git = ("+%s ~%s -%s |  %s "):format(add, change, delete, head)
    end
  else
    state.git = ("+%s ~%s -%s "):format(add, change, delete)
  end
end

---Set lsp diagnostics data
local function set_lsp_diagnostic()
  if state.diagnostic then return end
  local win_width = vim.api.nvim_win_get_width(0)

  local do_not_show_diag = win_is_smaller(win_width, 80)

  local diags = vim.diagnostic.count(0)
  local errors, warns, infos, hints = 0, 0, 0, 0
  local status_ok = false

  errors = diags[vim.diagnostic.severity.ERROR] or 0
  warns = diags[vim.diagnostic.severity.WARN] or 0
  infos = diags[vim.diagnostic.severity.INFO] or 0
  hints = diags[vim.diagnostic.severity.HINT] or 0
  status_ok = #diags == 0

  -- display values only if there are any
  state.diagnostic = status_ok and state.colors.diag .. icons.status_ok
      or do_not_show_diag and state.colors.diag .. icons.status_not_ok
      or ("%s%s%s %d %s%s %d %s%s %d %s%s %d"):format(
        state.colors.diag,
        state.colors.diagError,
        icons.error,
        errors,
        state.colors.diagWarn,
        icons.warning,
        warns,
        state.colors.diagInfo,
        icons.information,
        infos,
        state.colors.diagHint,
        icons.hint,
        hints
      )
end

---Set lsp status and if active get names of server running
local function set_lsp_info()
  if state.lsp_info then return end
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    state.lsp_info = state.colors.lspnoactive .. "• "
    return
  end
  local lsp_activity_or_status = lib_activity.status() ~= "" and lib_activity.status() or "• "
  state.lsp_info = state.colors.name .. lsp_activity_or_status
end

----------------
---LSP Progress
----------------

---Get lsp progress, trying to remove Noice and mini-view
---@param data? table lsp progress data table
local function set_lsp_progress(data)
  if not data or state.lsp_progress then return end
  local progress_data = ("(%d%%) %s: %s"):format(data.percentage or 0, data.title or "",
    data.message or "")
  state.lsp_progress = sanitize_stl(progress_data)
end

----------------
---Git Branch (async)
----------------

---Get git Branch and cache it
---@param buf number the id of the buffer
local function get_git_branch(buf)
  local root = vim.fs.root(buf, ".git")
  if not root then return end
  state.git = ""

  local cmd = { "git", "rev-parse", "--abbrev-ref", "HEAD" }
  vim.system(cmd, { text = true, cwd = root }, function(obj)
    if obj.stdout then
      local branch = obj.stdout:sub(1, -2) -- remove null terminator
      M.branch = sanitize_stl(branch)
      vim.schedule(function()
        set_git_status()
        M.set()
      end)
    end
  end)
end


----------------
---Session
----------------

---Set session name if active
local function set_session_name()
  if state.session_name and state.session_name ~= "" then return end
  state.session_name = M.session_name ~= "" and " [" .. sanitize_stl(M.session_name) .. "] " or ""
end

----------------
---Other Segments
----------------

---Set location in current buffer (current row on total rows)
local function set_line_on_tot()
  if state.clocation then return end

  local win_width = vim.api.nvim_win_get_width(0)
  state.clocation = win_is_smaller(win_width, M.preset_width.row_onTot) and
      (" %s%%l%s/%%L "):format(state.colors.git, state.colors.fformatloc)
      or (" %s%%l%s/%%L|%%P"):format(state.colors.git, state.colors.fformatloc)
end

---Set filetype with icon if available
local function set_filetype_and_icon()
  if state.ft_and_icon then return end

  local file_ext = vim.bo.filetype or vim.fn.expand "%:e"
  local icon = icons[file_ext]

  state.ft_and_icon = icon .. " " .. file_ext
end

---Set file encoding
local function set_fencoding()
  if state.fencoding then return end

  local win_width = vim.api.nvim_win_get_width(0)
  state.fencoding = not win_is_smaller(win_width, 76) and " %{&fileencoding?&fileencoding:&encoding} " or ""
end

---Set file format
local function set_fformat()
  if state.fformat then return end

  local win_width = vim.api.nvim_win_get_width(0)
  state.fformat = not win_is_smaller(win_width, 76) and "%{&ff}" or ""
end

----------------
---Python venv
----------------

---Set python state from virtual-env if is active and in python file
local function set_python_env()
  if state.pyvenv then return end
  state.pyvenv = ""
  local win_width = vim.api.nvim_win_get_width(0)
  if not win_is_smaller(win_width, M.preset_width.git_branch) then
    local venv = os.getenv "VIRTUAL_ENV"
    if venv then
      if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
          final_venv = w
        end
        venv = sanitize_stl(final_venv)
      end
      local kernels = ""
      if vim.bo.filetype == "quarto" and vim.endswith(vim.api.nvim_buf_get_name(0), "ipynb") then
        kernels = sanitize_stl(require("molten.status").kernels())
      end
      state.pyvenv = kernels ~= "" and " 󰌠 (" .. venv .. ") [" .. kernels .. "] " or " 󰌠 (" .. venv .. ") "
    end
  end
end

----------------
---State invalidation
----------------

---Invalidate state of key[s] passed
---`nil` is considered invalid state, while empty string `""` is terminal but valid
---@param ... table|string key of state to invalidate
local function invalidate_state(...)
  for _, key in ipairs({ ... }) do
    state[key] = nil
  end
end

----------------
---StatusLine Builder
----------------

---Statusline disabled that display only filetype and current mode
---@return string simple_statusline
local function disabled_statusline()
  local ftype_name = " " .. vim.bo.filetype
  local sideSep = "%="
  local modifiedReadOnlyFlags = "%m%r"
  set_mode()

  local special_filetypes = {
    [""] = icons.neovim .. " Neovim",
    ["nvim-pack"] = icons.table .. " Plugin Manager",
    lspinfo = icons.lsp_info .. " LSP Status",
    snacks_terminal = icons.robots .. " Terminal",
    snacks_picker_input = icons.search .. " Picker❭ Input",
    snacks_picker_list = icons.list .. " Picker❭ List",
    snacks_picker_preview = icons.default .. " Picker❭ Preview",
    qf = icons.config .. " QuickFix",
    terminal = icons.robots .. "Terminal",
    mason = icons.list .. " Package Manager",
    Outline = icons.table .. " Symbols Outline",
    checkhealth = icons.checkhealth .. " Health",
    query = icons.query .. " Query",
    dbui = icons.db .. " Database",
    httpResult = icons.web .. " Http",
    ["dap-float"] = icons.dapui_watches .. " DapUI❭ Hover",
    ["dap-repl"] = icons.robots .. " DapUI❭ Repl",
    ["dap-view"] = icons.dapui_watches .. " DapUI",
  }
  local custom_ft = special_filetypes[vim.bo.filetype]

  return table.concat {
    state.colors.mode,
    state.mode,
    modifiedReadOnlyFlags,
    state.colors.inverted,
    "",
    sideSep,
    state.colors.inactive,
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
  -- lazy recomputation, cache otherwise
  set_mode()
  set_session_name()
  set_filename()
  set_git_status()
  set_lsp_diagnostic()
  set_lsp_info()
  set_line_on_tot()
  set_filetype_and_icon()
  set_fencoding()
  set_fformat()
  set_python_env()

  return table.concat {
    -- LeftSide
    state.colors.mode,
    state.mode,
    state.colors.inverted,
    "",
    modifiedReadOnlyFlags,
    space,
    state.colors.git,
    "%<" .. (state.git or ""),
    state.colors.name,
    state.filename,
    state.colors.symbols,
    "",
    state.colors.empty,
    state.session_name or "",
    state.pyvenv or "",
    space,
    state.lsp_progress or "",
    space,

    -- Middle
    sideSep,
    state.diagnostic,
    space,

    -- Right Side
    state.colors.symbols,
    "",
    state.lsp_info,
    state.colors.ftype,
    state.ft_and_icon,
    state.colors.encoding,
    state.fencoding,
    state.colors.fformatloc,
    state.fformat,
    state.clocation or "",
    state.colors.inverted,
    "",
  }
end

---Render enabled or disabled statusline
---@param enabled boolean enabled statusline
local function render(enabled)
  return enabled and enabled_statusline() or disabled_statusline()
end

----------------
---API
----------------

---Set statusline based on filetype of current buffer
local function set()
  vim.wo.statusline = M.to_exclude[vim.bo.filetype] and render(false) or render(true)
end

M.set = set

----------------
---Setup
----------------

function setup()
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup("_statusline", { clear = true })

  M.session_name = ""

  autocmd("VimResized", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      invalidate_state("fencoding", "fformat", "filename", "pyvenv", "clocation")
      set()
    end
  })

  autocmd("ModeChanged", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      invalidate_state("mode")
      set()
    end
  })

  autocmd("DiagnosticChanged", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      invalidate_state("diagnostic")
      set()
    end
  })

  autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      invalidate_state("lsp_info")
      set()
    end
  })

  autocmd("LspDetach", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      invalidate_state("lsp_info")
      set()
    end
  })

  autocmd("LspProgress", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      local value = ev.data.params.value
      if not value then return end
      lib_activity.start("LSP")
      if value.kind == "report" then
        invalidate_state("lsp_progress", "lsp_info")
        set_lsp_progress(value)
      elseif value.kind == "end" then
        state.lsp_progress = ""
        invalidate_state("lsp_info")
        lib_activity.stop("LSP")
      end
      set()
    end
  })

  autocmd({ "BufEnter", "BufNewFile" }, {
    group = augroup,
    callback = function(ev)
      if (ev.event == "BufNew" and ev.file == "") then return end
      invalidate_state(
        "diagnostic", "ft_and_icon", "fencoding",
        "fformat", "filename", "lsp_info", "pyvenv", "clocation"
      )
      set()
    end
  })

  autocmd("DirChanged", {
    group = augroup,
    callback = function(ev)
      if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
      get_git_branch(ev.buf)
    end
  })

  autocmd("SessionLoadPost", {
    group = augroup,
    callback = function()
      invalidate_state("session_name")
      set()
    end
  })

  autocmd("User", {
    group = augroup,
    pattern = "MiniDiffUpdated",
    callback = function(ev)
      state.git = ""
      get_git_branch(ev.buf)
    end
  })

  autocmd("ColorScheme", {
    callback = function()
      if vim.g.statusline then
        invalidate_state("colors")
        set_color_groups()
      end
    end,
  })

  get_git_branch(0)

  set_color_groups()
  vim.g.statusline = true
  vim.o.statusline = "%!v:lua.require'lib.ui.statusline'.set()"
  vim.cmd.redrawstatus()
end

----------------
---Toggle
----------------

function M.toggle()
  if vim.g.statusline then
    vim.api.nvim_del_augroup_by_name("_statusline")
    vim.wo.statusline = ""
    vim.g.statusline = nil
    vim.cmd.redrawstatus()
  else
    setup()
  end
end

vim.api.nvim_create_user_command("ToggleStatusline", M.toggle, { desc = "Toggle Statusline" })

return M