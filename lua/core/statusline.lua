-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 07 Jul 2023, 11:50
-----------------------------------------

local S = {
   "~/.config/nvim/lua/core/statusline.lua",
}

local icons = require "user_lib.icons"

local diag_cached = ""

S.session_name = ""

local preset_width = setmetatable({
   filename = 60,
   git_branch = 60,
   git_status_full = 110,
   diagnostic = 128,
   row_onTot = 100,
}, {
   __index = function()
      return 80
   end,
})

local set_color_groups = function()
   vim.g.statusline_color = true

   local hls = {
      -- StatusLine
      StatusLine              = { fg = "#626262", bg = "NONE" },
      StatusLineNC            = { fg = "#868686", bg = "NONE" },
      StatusLineTerm          = { fg = "#626262", bg = "NONE" },
      StatusLineTermNC        = { fg = "#A9A9A9", bg = "#2c2c2c" },
      StatusLineMode          = { fg = "#158C8A" },
      StatusLineGit           = { fg = "#af8700", bg = "#2c2c2c" },
      StatusLineFileName      = { fg = "#36FF5A", bg = "#2c2c2c" },
      StatusLineLspActive     = { fg = "#4c4c4c", bg = "#2c2c2c" },
      StatusLineLspNotActive  = { fg = "#3c3c3c", bg = "#2c2c2c" },
      StatusLineFileEncoding  = { fg = "#86868B", bg = "#2c2c2c" },
      StatusLineFileType      = { fg = "#158C8A", bg = "#2c2c2c" },
      StatusLineFileFormat    = { fg = "#86868B", bg = "#2c2c2c" },
      StatusLineLocation      = { fg = "#86868B", bg = "#2c2c2c" },
      StatusLineGpsDiagnostic = { fg = "#3c3c3c", bg = "NONE" },
      StatusLineInverted      = { fg = "#1c1c1c", bg = "#2c2c2c" },
      StatusLineEmptyspace    = { fg = "#2c2c2c", bg = "NONE" },
      StatusLineLite          = { fg = "#dcdcdc", bg = "#262626" },
      StatusLineInactive      = { fg = "#5c5c5c", bg = "#2c2c2c" },
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
   lspactive   = "%#StatusLineLspActive#",
   lspnoactive = "%#StatusLineLspNotActive#",
   ftype       = "%#StatusLineFileType#",
   empty       = "%#StatusLineEmptyspace#",
   lite        = "%#StatusLineLite#",
   name        = "%#StatusLineFileName#",
   encoding    = "%#StatusLineFileEncoding#",
   fformat     = "%#StatusLineFileFormat#",
   location    = "%#StatusLineLocation#",
   session     = "%#StatusLineSession#",
   inverted    = "%#StatusLineInverted#",
   Nmode       = "%#Nmode#",
   Vmode       = "%#Vmode#",
   Imode       = "%#Imode#",
   Cmode       = "%#Cmode#",
   Tmode       = "%#Tmode#",
   ShellMode   = "%#Tmode#",
}

local map = {
   ["n"]     = colors.Nmode .. "NORMAL",
   ["no"]    = colors.Nmode .. "O-PENDING",
   ["nov"]   = colors.Nmode .. "O-PENDING",
   ["noV"]   = colors.Nmode .. "O-PENDING",
   ["no\22"] = colors.Nmode .. "O-PENDING",
   ["niI"]   = colors.Nmode .. "NORMAL",
   ["niR"]   = colors.Nmode .. "NORMAL",
   ["niV"]   = colors.Nmode .. "NORMAL",
   ["nt"]    = colors.Nmode .. "NORMAL",
   ["v"]     = colors.Vmode .. "VISUAL",
   ["vs"]    = colors.Vmode .. "VISUAL",
   ["V"]     = colors.Vmode .. "V-LINE",
   ["Vs"]    = colors.Vmode .. "V-LINE",
   ["\22"]   = colors.Vmode .. "V-BLOCK",
   ["\22s"]  = colors.Vmode .. "V-BLOCK",
   ["s"]     = colors.Vmode .. "SELECT",
   ["S"]     = colors.Vmode .. "S-LINE",
   ["\19"]   = colors.Vmode .. "S-BLOCK",
   ["i"]     = colors.Imode .. "INSERT",
   ["ic"]    = colors.Imode .. "INSERT",
   ["ix"]    = colors.Imode .. "INSERT",
   ["R"]     = colors.Tmode .. "REPLACE",
   ["Rc"]    = colors.Tmode .. "REPLACE",
   ["Rx"]    = colors.Tmode .. "REPLACE",
   ["Rv"]    = colors.Tmode .. "V-REPLACE",
   ["Rvc"]   = colors.Tmode .. "V-REPLACE",
   ["Rvx"]   = colors.Tmode .. "V-REPLACE",
   ["c"]     = colors.Cmode .. "COMMAND",
   ["cv"]    = colors.Cmode .. "EX",
   ["ce"]    = colors.Cmode .. "EX",
   ["r"]     = colors.Tmode .. "REPLACE",
   ["rm"]    = colors.Nmode .. "MORE",
   ["r?"]    = colors.Nmode .. "CONFIRM",
   ["!"]     = colors.ShellMode .. "SHELL",
   ["t"]     = colors.Tmode .. "TERMINAL",
}

local function get_mode()
   local mode_code = vim.api.nvim_get_mode().mode
   return map[mode_code] or mode_code
end

-- Helper function to check window size
-- if 2 values are passed as args, returns true
--  if win_size is between or equal to one of the limits
-- (in lua, only nil and false are "FALSY", 0 and '' are true)
local function win_is_smaller(lower, upper)
   local win_size = vim.api.nvim_win_get_width(0)
   return upper and (win_size >= lower and win_size <= upper) or win_size < lower
end

-- TODO: improve truncation
-- filename for statusline
local function get_filename()
   local cols = vim.o.columns
   local fname = vim.fn.expand "%f "
   local len_fname = string.len(fname)
   local to_trunc = len_fname >= preset_width.filename or len_fname >= (cols * 0.3)
   local truncated_name = "..." .. string.sub(fname, len_fname - (cols * 0.25), -1)

   return to_trunc and truncated_name or fname
end

-- location function (current row on total rows)
local function get_line_onTot()
   return win_is_smaller(preset_width.row_onTot) and " " .. colors.git .. "%l" .. colors.location .. "÷%L "
      or colors.location .. " row " .. colors.git .. "%l" .. colors.location .. "÷%L "
end

-- function lsp diagnostic
-- display diagnostic if enough space is available
-- based on win_size
local function get_lsp_diagnostic()
   local do_not_show_diag = win_is_smaller(preset_width.diagnostic) or win_is_smaller(90)

   local diagnostics = vim.diagnostic
   -- assign to relative vars the count of diagnostics
   local errors = #diagnostics.get(0, { severity = diagnostics.severity.ERROR })
   local warns = #diagnostics.get(0, { severity = diagnostics.severity.WARN })
   local infos = #diagnostics.get(0, { severity = diagnostics.severity.INFO })
   local hints = #diagnostics.get(0, { severity = diagnostics.severity.HINT })

   local status_ok = (errors == 0) and (warns == 0) and (infos == 0) and (hints == 0) or false

   local diag = string.format(
      "%s:%d %s:%d %s:%d %s:%d",
      icons.diagnostics.Error,
      errors,
      icons.diagnostics.Warning,
      warns,
      icons.diagnostics.Information,
      infos,
      icons.diagnostics.Hint,
      hints
   )

   if diag_cached ~= diag then
      diag_cached = diag
   end

   -- display values only if there are any
   return status_ok and colors.diag .. icons.diagnostics.status_ok
      or do_not_show_diag and colors.diag .. icons.diagnostics.status_not_ok
      or colors.diag .. diag_cached
end

-- Function of git status with gitsigns
local function get_git_status()
   local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
   local no_changes = (not signs.added) and not signs.changed and not signs.removed

   -- display based on size of window
   --  if no changes, display only head (if available)
   if win_is_smaller(preset_width.git_branch) then
      return ""
   elseif win_is_smaller(preset_width.git_branch, preset_width.git_status_full) then
      return signs.head and string.format("  %s ", signs.head) or ""
   else
      return signs.head and no_changes and string.format("  %s ", signs.head)
         or signs.head
            and string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
   end
end

-- Function return filetype with icon if available
local function get_filetype()
   local file_name, file_ext = vim.fn.expand "%:t", vim.fn.expand "%:e"
   local has_devicons, devicons = pcall(require, "nvim-web-devicons")
   local icon = ""

   if has_devicons then
      icon = devicons.get_icon(file_name, file_ext)
   end
   local file_type = vim.bo.filetype

   return file_type and has_devicons and { icon = icon, name = file_type }
      or { name = file_type }
      or icons.diagnostics.Error
end

local function get_fencoding()
   return " %{&fileencoding?&fileencoding:&encoding} "
end

local function session_name()
   return S.session_name ~= "" and "Session: " .. colors.session .. S.session_name or ""
end

local function get_python_env()
   if not win_is_smaller(preset_width.git_branch) then
      if vim.bo.filetype == "python" then
         local venv = os.getenv "VIRTUAL_ENV"
         if venv then
            if string.find(venv, "/") then
               local final_venv = venv
               for w in venv:gmatch "([^/]+)" do
                  final_venv = w
               end
               venv = final_venv
            end
            local dev_icons = require "nvim-web-devicons"
            local py_icon, _ = dev_icons.get_icon ".py"
            return ("%s (%s)"):format(py_icon, venv)
         end
      end
   end
   return ""
end

local function get_lsp_info()
   local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
   if #buf_clients == 0 then
      return ("%s%s LSP Inactive "):format(colors.lspnoactive, icons.ui.CircleEmpty)
   end
   local buf_client_names = ("%s%s%s["):format(colors.name, icons.ui.SmallCircle, colors.lspactive)
   -- add client
   for idx, client in pairs(buf_clients) do
      if idx > 1 then
         buf_client_names = buf_client_names .. ","
      end
      buf_client_names = buf_client_names .. client.name
   end
   return buf_client_names .. "] "
end

--- Check if matching filetype exists and exclude
--- @return boolean
local to_exclude = function()
   local special_ft = {
      alpha           = true,
      NvimTree        = true,
      lspinfo         = true,
      TelescopePrompt = true,
      Trouble         = true,
      qf              = true,
      toggleterm      = true,
      lazy            = true,
      crunner         = true,
      mason           = true,
      Outline         = true,
      noice           = true,
      checkhealth     = true,
      org             = true,
      orgagenda       = true,
   }

   return special_ft[vim.bo.filetype]
end


-- Statusline disabled
-- display only filetype and current mode
S.off = function(name)
   local ftype_name = vim.bo.filetype

   local special_filetypes = {
      alpha           = icons.ui.Plugin .. " Dashboard",
      oil             = icons.documents.OpenFolder .. " File Explorer",
      lazy            = icons.ui.PluginManager .. " Plugin Manager",
      lspinfo         = icons.ui.Health .. " LSP Status",
      TelescopePrompt = icons.ui.Telescope .. " Telescope",
      qf              = icons.ui.Gear .. " QuickFix",
      toggleterm      = icons.misc.Robot .. " Terminal",
      crunner         = icons.ui.AltSlArrowRight .. " CodeRunner",
      mason           = icons.ui.List .. " Package Manager",
      Outline         = icons.ui.Table .. " Symbols Outline",
      noice           = icons.ui.List .. " Notifications",
      checkhealth     = icons.ui.Health .. " Health",
      org             = icons.ui.Orgmode .. " Orgmode",
      orgagenda       = icons.ui.Calendar .. " OrgAgenda"
   }
   local custom_ft = special_filetypes[ftype_name]
   return ("%s%s %%= %s%%="):format(get_mode(), colors.inactive, name or custom_ft or ftype_name)
end


S.on = function()
   local sideSep = "%="
   local currMode = "%m%r"
   local fformat = "%{&ff}"
   local space = " "

   local sl = {
      -- LeftSide
      colors.mode, currMode, get_mode(),
      colors.inverted, icons.ui.SlArrowRight,
      colors.git, get_git_status(),
      colors.name, get_filename(),
      colors.empty, icons.ui.SlArrowRight,
      session_name(),
      get_python_env(),

      -- Middle
      sideSep,
      get_lsp_diagnostic(),

      -- Right Side
      colors.empty, icons.ui.SlArrowLeft, get_lsp_info(),
      colors.ftype, get_filetype().icon or "",
      space,
      get_filetype().name,
      colors.encoding, get_fencoding(),
      colors.fformat, fformat,
      get_line_onTot(),
      colors.inverted, icons.ui.SlArrowLeft
   }

   return table.concat(sl)
end




S.get_statusline = function()
   if not vim.g.statusline_color then set_color_groups() end
   if not to_exclude() then
      vim.wo.statusline = S.on()
   else
      vim.wo.statusline = S.off()
   end
end

return S
