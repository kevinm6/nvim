-----------------------------------------
-- File         : winbar.lua
-- Description  : Personal winbar config
-- Author       : Kevin Manca
-- Last Modified: 31 Dec 2025, 16:41
-----------------------------------------

local winbar = {
  ---filetypes to exclude
  to_exclude = {
    dashboard = true,
    alpha = true,
    lspinfo = true,
    qf = true,
    snacks_picker_input = true,
    snacks_picker_list = true,
    snacks_picker_preview = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    checkhealth = true,
    notify = true,
    cmpmenu = true,
    vim = true,
    oil = true,
    help = true,
    query = true,
    httpResult = true,
    ["dap-view"] = true,
    ["dap-float"] = true,
    minifiles = true,
  },
}

---Check string is empty
---@param s string|nil
---@return boolean not_empty false for empty string | true otherwise
local function is_not_empty(s)
  return s ~= nil and s ~= ""
end

---Set highlights groups for WinBar
local function set_color_groups()
  vim.api.nvim_set_hl(0, "WinBar", { fg = "#6c6c6c", bg = "#1c1c1c", bold = true })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#3c3c3c", bg = "#1c1c1c", italic = true })
end

---Get Filename of current buffer
---@return string filename file name formatted with icon if available
local function get_filename()
  local filename = vim.fn.expand "%:t"

  if is_not_empty(filename) then
    local file_icon = ""
    local extension = vim.fn.expand "%:e"

    local has_icons, icons = pcall(require, "mini.icons")

    file_icon = has_icons and icons.get("filetype", extension) or ""

    return ("%%#FileIconColor%s#%s%%* %s"):format(extension, file_icon, filename)
  end
  return ""
end


---Define autocmds for load winbar module and initialize
function winbar.toggle()
  if vim.g.winbar ~= nil then
    vim.api.nvim_del_autocmd(vim.g.winbar)
    vim.wo.winbar = ""
    vim.g.winbar = nil
  else
    vim.api.nvim_create_autocmd({
      "CursorMoved",
      "ModeChanged",
      "BufEnter",
    }, {
      group = vim.api.nvim_create_augroup("_winbar", { clear = true }),
      callback = function(cb)
        if vim.g.winbar ~= nil then
          if not vim.api.nvim_win_get_config(0).relative ~= "" and not winbar.to_exclude[vim.bo.filetype] then
            vim.wo.winbar = get_filename()
          end
        else
          set_color_groups()
          vim.g.winbar = cb.id
        end
      end,
    })
  end
end

vim.api.nvim_create_user_command("ToggleWinbar", function()
  winbar.toggle()
end, { desc = "Toggle Winbar" })

return winbar