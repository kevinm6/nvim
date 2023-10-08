-----------------------------------
--	File: alpha.lua
--	Description: alplha config for Neovim
--	Author: Kevin
--	Last Modified: 06 Oct 2023, 10:12
-----------------------------------

local M = {
   "goolord/alpha-nvim",
   event = "VimEnter",
   keys = {
        { "<leader>a", function() vim.cmd.Alpha {} end, desc = "Alpha Dashboard" }
   },
   config = function()

      local has_dashboard, alpha = pcall(require, "alpha")
      if not has_dashboard then return end

      local icons = require "user_lib.icons"
      local dashboard = require "alpha.themes.dashboard"

      local newline = [[
   ]]

      local date = function()
         return os.date "  %d/%m/%Y   %H:%M:%S"
         -- return require "plugins.dashboard.clock".get_time()
      end

      local nvim_version = function()
         local v = vim.version()
         local v_info = string.format("%s v%s.%s.%s", icons.ui.Version, v.major, v.minor, v.patch)
         return v_info
      end

      -- Get centered string with prefixed spaces
      local function center_string(string_to_center, cols_tot)
         local center_cols = math.floor((cols_tot or vim.o.columns) / 2)
         local center_str_len = math.floor(#string_to_center/2)

         local spaces = string.rep(" ", center_cols - center_str_len)
         return ("%s%s"):format(spaces, string_to_center)
      end

      dashboard.section.header.val = {
         center_string(date(), 55),
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
         dashboard.button("n", icons.ui.NewFile .. " New file", "<cmd>lua require 'user_lib.functions'.new_file()<CR>"),
         dashboard.button(
            "t",
            icons.ui.NewFile .. " New temp file",
            "<cmd>lua require 'user_lib.functions'.new_tmp_file()<CR>"
         ),
         dashboard.button("o", icons.ui.Note .. " Notes", [[<cmd>lua require "user_lib.notes".open_note()<CR>]]),

         dashboard.button(
            "f",
            icons.documents.Files .. " Find file",
            "<cmd>lua require 'telescope.builtin'.find_files()<CR>"
         ),
         dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>lua require 'telescope.builtin'.oldfiles()<CR>"),
         dashboard.button(
            "R",
            icons.git.Repo .. " Find project",
            "<cmd>lua require 'telescope'.extensions.project.project{}<CR>"
         ),
         dashboard.button("d", icons.ui.Dev .. " Developer", [[<cmd>lua require "user_lib.functions".dev_folder()<CR>]]),
         dashboard.button("L", icons.ui.PluginManager .. " Plugin Manager", "<cmd>Lazy<CR>"),
         dashboard.button(
            "P",
            icons.ui.Plugin .. " Plugins Configuration",
            [[<cmd>lua require "telescope".extensions.file_browser.file_browser { cwd = "$NVIMDOTDIR/lua/plugins"}<CR>]]
         ),
         dashboard.button("m", icons.ui.List .. " Package Manager", "<cmd>Mason<CR>"),
         dashboard.button("g", icons.ui.Git .. " Git", "<cmd>Git <CR>"),
         dashboard.button(
            "S",
            icons.ui.History .. " Sessions",
            "<cmd>lua require 'user_lib.sessions'.restore_session()<CR>"
         ),
         dashboard.button(
            "D",
            icons.ui.Lock .. " Dotfiles",
            [[<cmd>lua require "telescope".extensions.file_browser.file_browser { cwd = "$DOTFILES" }<CR>]]
         ),
         dashboard.button("H", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
         dashboard.button("c", icons.documents.Files .. " Close", "<cmd>Alpha<CR>"),
         dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
      }

      local footer = function()
         local plugins = require("lazy").stats().count
         local loaded = require("lazy").stats().loaded
         local plugins_count = string.format("%s %d Plugins | %d loaded", icons.ui.Plugin, plugins, loaded)

         local my_url = "github.com/kevinm6/nvim"
         local myself = string.format(" %s %s ", icons.misc.GitHub, my_url)

         local footer_str = ("%s\n%s"):format(
            center_string(plugins_count, 30),
            center_string(myself, 30)
         )

         return footer_str
      end

      dashboard.section.footer.val = footer()

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.config.opts.noautocmd = true

      alpha.setup(dashboard.opts)
   end
}

return M
