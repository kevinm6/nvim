-----------------------------------
--	File: dashboard.lua
--	Description: greeter config for Neovim (using Alpha actually)
--	Author: Kevin
--	Last Modified: 20 Mar 2024, 11:58
-----------------------------------

---Get date in nice style
---@return string date formatted
local function get_date()
  return tostring(os.date "  %d/%m/%Y   %H:%M")
end

---Get Neovim version
---@return string nvim_version full neovim version
local function get_nvim_version()
  local icons = require "lib.icons"
  local v = vim.version()
  local v_info = string.format("%s v%s.%s.%s", icons.ui.Version, v.major, v.minor, v.patch)
  return v_info
end


---Get centered string with prefixed spaces
---@param string_to_center string string passed to be centered
---@param cols_tot number | nil total number of coloumns to be used for center the string
---@return string centered_string string
local function center_string(string_to_center, cols_tot)
  local center_cols = math.floor((cols_tot or vim.o.columns) / 2)
  local center_str_len = math.floor(#string_to_center/2)

  local spaces = string.rep(" ", center_cols - center_str_len)
  return string.format("%s%s", spaces, string_to_center)
end

---Create footer for Alpha dashboard
---@return string footer_str
local function footer()
  local plugins = require("lazy").stats().count
  local loaded = require("lazy").stats().loaded
  local icons = require "lib.icons"

  local plugins_count = string.format("%s %d Plugins | %d loaded", icons.ui.Plugin, plugins, loaded)

  -- local my_url = "github.com/kevinm6/nvim"
  -- local myself = string.format(" %s %s ", icons.misc.GitHub, my_url)

  -- local footer_str = string.format("%s\n%s",
  --   center_string(plugins_count, 30),
  --   center_string(myself, 30)
  -- )

  return center_string(plugins_count, #plugins_count)
end


local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  keys = {
    { "<leader>a", function() vim.cmd.Alpha() end, desc = "Dashboard" }
  },
  config = function()
    local alpha = require "alpha"
    local db = require "alpha.themes.dashboard"
    local icons = require "lib.icons"

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
      newline
    }

    local db_btn = db.button
    db.section.buttons.val = {
      db_btn("n", icons.ui.NewFile .. " New file", "<cmd>lua require 'lib.utils'.new_file()<CR>"),
      db_btn(
        "t",
        icons.ui.NewFile .. " New temp file",
        "<cmd>lua require 'lib.utils'.new_tmp_file()<CR>"
      ),
      db_btn("o", icons.ui.Note .. " Notes", [[<cmd>lua require "lib.notes".open_note()<CR>]]),

      db_btn(
        "f",
        icons.documents.Files .. " Find file",
        "<cmd>lua require 'lib.utils'.find_files()<CR>"
      ),
      db_btn("r", icons.ui.History .. " Recent files", "<cmd>lua require 'lib.utils'.recent_files()<CR>"),
      db_btn(
        "R",
        icons.git.Repo .. " Find project",
        "<cmd>lua require 'lib.utils'.projects()<CR>"
      ),
      db_btn("d", icons.ui.Dev .. " Developer", [[<cmd>lua require "lib.utils".dev_folder()<CR>]]),
      db_btn("L", icons.ui.PluginManager .. " Plugin Manager", "<cmd>Lazy<CR>"),
      db_btn("m", icons.ui.List .. " Package Manager", "<cmd>Mason<CR>"),
      db_btn("g", icons.ui.Git .. " Git", "<cmd>Git <CR>"),
      db_btn("H", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
      db_btn("c", icons.documents.Files .. " Close", "<cmd>Alpha<CR>"),
      db_btn("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
    }

    db.section.footer.val = footer

    db.section.header.opts.hl  = "Type"
    db.section.buttons.opts.hl = "Keyword"
    db.section.footer.opts.hl  = "Comment"

    db.config.opts.noautocmd = true

    alpha.setup(db.opts)
  end
}

return M