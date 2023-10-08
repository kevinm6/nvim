-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 14 Oct 2023, 09:11
-----------------------------------------

local S = {
   dir = "~/.config/nvim/lua/core/statusline.lua",
}

local icons = require "user_lib.icons"

local diag_cached = ""

S.session_name = ""

-- TODO: adapt using priority

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
   diagError   = "%#DiagnosticError#",
   diagWarn    = "%#DiagnosticWarn#",
   diagInfo    = "%#DiagnosticInfo#",
   diagHint    = "%#DiagnosticHint#",
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


local function get_mode()
   local mode = {
      ["n"]     = colors.Nmode .. "N",
      ["no"]    = colors.Nmode .. "O-P",
      ["nov"]   = colors.Nmode .. "O-P",
      ["noV"]   = colors.Nmode .. "O-P",
      ["no\22"] = colors.Nmode .. "O-P",
      ["niI"]   = colors.Nmode .. "N",
      ["niR"]   = colors.Nmode .. "N",
      ["niV"]   = colors.Nmode .. "N",
      ["nt"]    = colors.Nmode .. "N",
      ["v"]     = colors.Vmode .. "V",
      ["vs"]    = colors.Vmode .. "V",
      ["V"]     = colors.Vmode .. "V-L",
      ["Vs"]    = colors.Vmode .. "V-L",
      ["\22"]   = colors.Vmode .. "V-B",
      ["\22s"]  = colors.Vmode .. "V-B",
      ["s"]     = colors.Vmode .. "S",
      ["S"]     = colors.Vmode .. "S-L",
      ["\19"]   = colors.Vmode .. "S-B",
      ["i"]     = colors.Imode .. "I",
      ["ic"]    = colors.Imode .. "I",
      ["ix"]    = colors.Imode .. "I",
      ["R"]     = colors.Tmode .. "R",
      ["Rc"]    = colors.Tmode .. "R",
      ["Rx"]    = colors.Tmode .. "R",
      ["Rv"]    = colors.Tmode .. "V-R",
      ["Rvc"]   = colors.Tmode .. "V-R",
      ["Rvx"]   = colors.Tmode .. "V-R",
      ["c"]     = colors.Cmode .. "C",
      ["cv"]    = colors.Cmode .. "EX",
      ["ce"]    = colors.Cmode .. "EX",
      ["r"]     = colors.Tmode .. "R",
      ["rm"]    = colors.Nmode .. "M",
      ["r?"]    = colors.Nmode .. "C",
      ["!"]     = colors.ShellMode .. "S",
      ["t"]     = colors.Tmode .. "T",
   }

   local mode_code = vim.api.nvim_get_mode().mode
   return mode[mode_code] or mode_code
end


---Check window size compared to args.
---if 2 args are passed checks if win_width is between or equal to lower and upper,
---otherwise check if win_width is bigger than single value passed.
---@param lower number lower bound or minimum width allowed
---@param upper number? upper bound, if passed
local function win_is_smaller(lower, upper)
   upper = upper or nil
   local win_size = vim.api.nvim_win_get_width(0)
   return upper and (win_size >= lower and win_size <= upper) or win_size < lower
end


-- location function (current row on total rows)
local function get_line_onTot()
   return win_is_smaller(preset_width.row_onTot) and " " .. colors.git .. "%l" .. colors.location .. "÷%L "
      or colors.location .. " row " .. colors.git .. "%l" .. colors.location .. "÷%L "
end


local function get_filename()
   local cols = vim.o.columns
   local fname = vim.fn.expand "%f "
   local to_trunc = #fname >= preset_width.filename or #fname >= (cols * 0.26)
   local truncated_name = "..." .. string.sub(fname, #fname - (cols * 0.20), -1)

   return to_trunc and truncated_name or fname
end


-- function lsp diagnostic
-- display diagnostic if enough space is available
-- based on win_size
local function get_lsp_diagnostic()
   local do_not_show_diag = win_is_smaller(80)

   -- assign to relative vars the count of diagnostics

   local errors = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.ERROR }})
   local warns  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.WARN }})
   local infos  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.INFO }})
   local hints  = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.HINT }})

   local status_ok = (errors == 0) and (warns == 0) and (infos == 0) and (hints == 0) or false

   local diag = string.format(
      "%s%s:%d %s%s:%d %s%s:%d %s%s:%d",
      colors.diagError, icons.diagnostics.Error, errors,
      colors.diagWarn, icons.diagnostics.Warning, warns,
      colors.diagInfo, icons.diagnostics.Information, infos,
      colors.diagHint, icons.diagnostics.Hint, hints
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
   return not win_is_smaller(76) and " %{&fileencoding?&fileencoding:&encoding} " or ""
end

local function get_fformat()
   return not win_is_smaller(76) and "%{&ff}" or ""
end

local function session_name()
   return S.session_name ~= "" and "Session: " .. colors.session .. S.session_name or ""
end

local function get_python_env()
   if vim.bo.filetype == "python" then
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
            local py_icon = '󰌠'
            return ("%s (%s)"):format(py_icon, venv)
         end
      end
   end
   return ""
end

---Get lsp status and if active get names of server running
local function get_lsp_info()
   -- TODO: remove when update to nvim-0.10
   local buf_clients = vim.fn.has("nvim-0.10") == 1 and vim.lsp.get_clients() or
      vim.lsp.get_active_clients { bufnr = 0 }

   return #buf_clients == 0 and
      ("%s%s "):format(colors.lspnoactive, icons.ui.SmallCircle) or
      ("%s%s "):format(colors.name, icons.ui.SmallCircle)
end

---Check if current filetype match the filetype to exclude
---@return boolean
local function to_exclude()
   local special_ft = {
      alpha           = true,
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
   }

   return special_ft[vim.bo.filetype]
end


---Statusline disabled that display only filetype and current mode
---@return string statusline
S.off = function(name)
   local ftype_name = vim.bo.filetype
   local sideSep = "%="

   local special_filetypes = {
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
   }
   local custom_ft = special_filetypes[ftype_name]
   return table.concat({
      colors.mode,
      get_mode(),
      colors.inverted,
      icons.ui.SlArrowRight,
      sideSep,
      colors.inactive,
      name or custom_ft or ftype_name,
      sideSep
   })
end


---Statusline enabled with all items
---@return string statusline
S.on = function()
   local sideSep = "%="
   -- local currMode = "%m%r"
   local space = " "

   local sl = {
      -- LeftSide
      colors.mode, get_mode(),
      colors.inverted, icons.ui.SlArrowRight,
      colors.git, get_git_status(),
      colors.name, get_filename(),
      colors.empty, icons.ui.SlArrowRight,
      session_name(),
      get_python_env(),

      -- Middle
      sideSep,
      get_lsp_diagnostic(),
      space,

      -- Right Side
      colors.empty, icons.ui.SlArrowLeft, get_lsp_info(),
      colors.ftype, get_filetype().icon or "",
      space,
      get_filetype().name,
      colors.encoding, get_fencoding(),
      colors.fformat, get_fformat(),
      get_line_onTot(),
      colors.inverted, icons.ui.SlArrowLeft
   }

   return table.concat(sl)
end


---Set statusline based on filetype of current buffer
S.set_statusline = function()
   if not vim.g.statusline_color then set_color_groups() end
   if not to_exclude() then
      vim.wo.statusline = S.on()
   else
      vim.wo.statusline = S.off()
   end
end

return S
