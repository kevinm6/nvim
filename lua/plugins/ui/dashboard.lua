-----------------------------------
--	File: dashboard.lua
--	Description: greeter config for Neovim (using Alpha actually)
--	Author: Kevin
--	Last Modified: 01 May 2024, 12:33
-----------------------------------

---Get date in nice style
---@return string date formatted
local function get_date()
  return tostring(os.date "  %d/%m/%Y   %H:%M")
end

---Get Neovim version
---@return string nvim_version full neovim version
local function get_nvim_version()
  local v = vim.version()
  local v_info = string.format(" v%d.%d.%d", v.major, v.minor, v.patch)
  return v_info
end

---Get centered string with prefixed spaces
---@param string_to_center string string passed to be centered
---@param cols_tot number | nil total number of coloumns to be used for center the string
---@return string centered_string string
local function center_string(string_to_center, cols_tot)
  local center_cols = math.floor((cols_tot or vim.o.columns) / 2)
  local center_str_len = math.floor(#string_to_center / 2)

  local spaces = string.rep(" ", center_cols - center_str_len)
  return string.format("%s%s", spaces, string_to_center)
end

---Create footer for Alpha dashboard
---@return string footer_str
local function footer()
  local plugins = require("lazy").stats().count
  local loaded = require("lazy").stats().loaded

  local plugins_count = string.format("󰀻 %d Plugins | %d loaded", plugins, loaded)

  -- local my_url = "github.com/kevinm6/nvim"
  -- local myself = "  " ..  my_url

  -- local footer_str = string.format("%s\n%s",
  --   center_string(plugins_count, 30),
  --   center_string(myself, 30)
  -- )

  return center_string(plugins_count, #plugins_count)
end

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require "alpha"
    local db = require "alpha.themes.dashboard"

    local newline = [[
   ]]

    local date = get_date()
    local nvim_version = get_nvim_version()

    db.section.header.val = {
      center_string(date, 58),
      newline,
      [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
      [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
      [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
      [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
      [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
      newline,
      center_string(nvim_version, 55),
      newline,
    }

    local db_btn = db.button
    db.section.buttons.val = {
      db_btn("n", " New file", "<cmd>lua require 'lib'.new_file()<CR>"),
      db_btn("t", " New temp file", "<cmd>lua require 'lib'.new_tmp_file()<CR>"),
      db_btn("o", " Notes", [[<cmd>lua require "lib.notes".open_note()<CR>]]),

      db_btn("f", "󰾰 Find file", "<cmd>lua require 'lib'.find_files()<CR>"),
      db_btn("r", " Recent files", "<cmd>lua require 'lib'.recent_files()<CR>"),
      db_btn("p", " Find project", "<cmd>lua require 'lib'.projects()<CR>"),
      db_btn("d", "󰾰 Developer", [[<cmd>lua require "lib".dev_folder()<CR>]]),
      db_btn("L", " Plugin Manager", "<cmd>Lazy<CR>"),
      db_btn("m", " Package Manager", "<cmd>Mason<CR>"),
      db_btn("g", " Git", ":Lazygit<CR>"),
      db_btn("H", "♥ Health", "<cmd>checkhealth<CR>"),
      db_btn("c", " Close", "<cmd>Alpha<CR>"),
      db_btn("q", " Quit", "<cmd>qa<CR>"),
    }

    db.section.footer.val = footer

    db.section.header.opts.hl = "Type"
    -- db.section.buttons.val.opts.hl = "Type"
    for _, btn in pairs(db.section.buttons.val) do
      if btn.val ~= " Quit" then
        btn.opts.hl_shortcut = "Type"
      else
        btn.opts.hl_shortcut = "ErrorMsg"
      end
    end
    db.section.footer.opts.hl = "Comment"

    db.config.opts.noautocmd = true
    alpha.setup(db.opts)
  end,
}
