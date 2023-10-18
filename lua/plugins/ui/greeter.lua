-----------------------------------
--	File: greeter.lua
--	Description: greeter config for Neovim (using Alpha actually)
--	Author: Kevin
--	Last Modified: 03 Dec 2023, 10:48
-----------------------------------

---Get date in nice style
---@return string date formatted
local function date()
  return tostring(os.date "  %d/%m/%Y   %H:%M")
end

---Get Neovim version
---@return string nvim_version full neovim version
local function nvim_version()
  local icons = require "lib.icons"
  local v = vim.version()
  local v_info = string.format("%s v%s.%s.%s", icons.ui.Version, v.major, v.minor, v.patch)
  return v_info
end


---Get centered string with prefixed spaces
---@param string_to_center string string passed to be centered
---@param cols_tot number total number of coloumns to be used for center the string
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

  local my_url = "github.com/kevinm6/nvim"
  local myself = string.format(" %s %s ", icons.misc.GitHub, my_url)

  local footer_str = string.format("%s\n%s",
    center_string(plugins_count, 30),
    center_string(myself, 30)
  )

  return footer_str
end


local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  keys = {
    { "<leader>a", function() vim.cmd.Alpha {} end, desc = "Alpha Dashboard" }
  },
  config = function()
    local alpha = require "alpha"
    local dashboard = require "alpha.themes.dashboard"
    local icons = require "lib.icons"

    local newline = [[
   ]]

    dashboard.section.header.val = {
      center_string(date(), 58),
      newline,
      [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
      [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
      [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
      [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
      [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
      newline,
      center_string(nvim_version(), 55)
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", icons.ui.NewFile .. " New file", "<cmd>lua require 'lib.utils'.new_file()<CR>"),
      dashboard.button(
        "t",
        icons.ui.NewFile .. " New temp file",
        "<cmd>lua require 'lib.utils'.new_tmp_file()<CR>"
      ),
      dashboard.button("o", icons.ui.Note .. " Notes", [[<cmd>lua require "lib.notes".open_note()<CR>]]),

      dashboard.button(
        "f",
        icons.documents.Files .. " Find file",
        "<cmd>lua require 'telescope.builtin'.find_files()<CR>"
      ),
      dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>lua require 'telescope.builtin'.oldfiles()<CR>"),
      dashboard.button(
        "R",
        icons.git.Repo .. " Find project",
        "<cmd>lua require 'lib.utils'.projects()<CR>"
      ),
      dashboard.button("d", icons.ui.Dev .. " Developer", [[<cmd>lua require "lib.utils".dev_folder()<CR>]]),
      dashboard.button("L", icons.ui.PluginManager .. " Plugin Manager", "<cmd>Lazy<CR>"),
      dashboard.button(
        "P",
        icons.ui.Plugin .. " Plugins config",
        [[<cmd>lua require "oil".open_float(vim.fn.expand "$NVIMDOTDIR/lua/plugins")<CR>]]
      ),
      dashboard.button("m", icons.ui.List .. " Package Manager", "<cmd>Mason<CR>"),
      dashboard.button("g", icons.ui.Git .. " Git", "<cmd>Git <CR>"),
      dashboard.button(
        "S",
        icons.ui.History .. " Sessions",
        "<cmd>lua require 'lib.sessions'.restore_session()<CR>"
      ),
      dashboard.button(
        "D",
        icons.ui.Lock .. " Dotfiles",
        [[<cmd>lua require "oil".open_float(vim.fn.expand "$DOTFILES")<CR>]]
      ),
      dashboard.button("H", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
      dashboard.button("c", icons.documents.Files .. " Close", "<cmd>Alpha<CR>"),
      dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
    }


    dashboard.section.footer.val = footer

    dashboard.section.header.opts.hl = "Type"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#016a60" })
    -- vim.api.nvim_set_hl(0, "AlphaButtons", { link = "Keyword" })
    -- vim.api.nvim_set_hl(0, "AlphaFooter", { link = "Comment" })

    dashboard.config.opts.noautocmd = true

    alpha.setup(dashboard.opts)
  end
}

return M