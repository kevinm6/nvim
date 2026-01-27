local M = {}

M = setmetatable({
  neovim = "",
  error = "",
  warning = "",
  information = "",
  hint = "󱧢",
  status_ok = "",
  status_not_ok = "",
  dashboard = "",
  folder = "",
  lsp_info = "󰒓",
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
    local default_ico = ""
    if not has_icons then
      return default_ico
    else
      local has_icon, icon = pcall(icons.get, "filetype", k)
      local ico = has_icon and icon or default_ico
      t[k] = ico
      return ico
    end
  end,
})

return M