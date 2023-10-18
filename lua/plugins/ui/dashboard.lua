-----------------------------------
--	File: dashboard.lua
--	Description: greeter config for Neovim (nvim-dashboard)
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
  local v_info = string.format("%s v%s.%s.%s", icons.ui.Version, v.major, v.minor, v
    .patch)
  return v_info
end


local M = {
  'nvimdev/dashboard-nvim',
  enabled = false,
  event = 'VimEnter',
  keys = {
    { "<leader>a", function() vim.cmd.Dashboard() end, desc = "Dashboard" }
  },
  config = function(_, o)
    local icons = require "lib.icons"

    local logo = [[
        ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
        ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
        ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
        ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
        ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
        ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
    ]]

    logo = string.rep("\n", 4) .. logo .. "\n\n"
    local header = function()
      local str = string.format("%s\n%s\n%s", date(), logo, nvim_version())
      return vim.split(str, "\n")
    end

    local footer = function()
      local plugins = require("lazy").stats().count
      local loaded = require("lazy").stats().loaded

      local plugins_count = string.format("%s %d Plugins | %d loaded",
        icons.ui.Plugin, plugins, loaded)
      return plugins_count
    end

    o = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = header(),
        week_heade = {
          enable = true,
        },
        disable_move = true,
        -- date(),
        -- nvim_version()

        center = {
          {
            action = "lua require 'lib.utils'.new_file()",
            desc = "New File",
            icon = icons.ui.NewFile,
            key = "n"
          },
          {
            action = "lua require 'lib.utils'.new_tmp_file()()",
            desc = "New temp file",
            icon = icons.ui.NewFile,
            key = "t"
          },
          {
            action = [[lua require "lib.notes".open_note()()]],
            desc = "Notes",
            icon = icons.ui.Note,
            key = "o"
          },
          {
            action = "lua require 'telescope.builtin'.find_files()",
            desc = "Find file",
            icon = icons.documents.Files,
            key = "f"
          },
          {
            action = "lua require 'telescope.builtin'.oldfiles()",
            desc = "Recent files",
            icon = icons.ui.History,
            key = "r"
          },
          {
            action = "lua require 'lib.utils'.projects()",
            desc = "Find project",
            icon = icons.git.Repo,
            key = "R"
          },
          {
            action = [[lua require "lib.utils".dev_folder()]],
            desc = "Developer",
            icon = icons.ui.Dev,
            key = "d"
          },
          {
            action = "Lazy",
            desc = "Plugin Manager",
            icon = icons.ui.PluginManager,
            key = "L"
          },
          {
            action =
              [[lua require "oil".open_float(vim.fn.expand "$NVIMDOTDIR/lua/plugins")]],
            desc = "Plugins config",
            icon = icons.ui.Plugin,
            key = "P"
          },
          {
            action = "Mason",
            desc = "Package Manager",
            icon = icons.ui.List,
            key = "m"
          },
          {
            action = "Git",
            desc = "Git",
            icon = icons.ui.Git,
            key = "g"
          },
          {
            action = "lua require 'lib.sessions'.restore_session()",
            desc = "Sessions",
            icon = icons.ui.History,
            key = "S"
          },
          {
            action = [[lua require "oil".open_float(vim.fn.expand "$DOTFILES")]],
            desc = "Dotfiles",
            icon = icons.ui.Lock,
            key = "D"
          },
          {
            action = "checkhealth",
            desc = "Health",
            icon = icons.ui.Health,
            key = "H"
          },
          -- {
          --   action = "close",
          --   desc = "Close",
          --   icon = icons.documents.Files,
          --   key = "c"
          -- },
          {
            action = "qa",
            desc = "Quit",
            icon = "",
            icon_hl = "String",
            key = "q"
          },
        },
        footer = footer()
      },
    }

    for _, button in ipairs(o.config.center) do
      button.desc = " " .. button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    -- if vim.o.filetype == "lazy" then
    --   vim.cmd.close()
    --   vim.api.nvim_create_autocmd("User", {
    --     pattern = "DashboardLoaded",
    --     callback = function()
    --       require("lazy").show()
    --     end,
    --   })
    -- end

    require "knvim.plugins.dashboard"
  end
}

return M