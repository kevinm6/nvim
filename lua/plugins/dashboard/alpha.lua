-----------------------------------
--	File: alpha.lua
--	Description: alplha config for Neovim
--	Author: Kevin
--	Last Modified: 19 Jun 2023, 11:32
-----------------------------------

local M = {
   "goolord/alpha-nvim",
   event = "VimEnter",
}

function M.config()
   -- local has_telescope, _ = pcall(require, "telescope")
   -- if not has_telescope then
   --    vim.notify("Telescope not available!\n Not opening dashboard", vim.log.levels.WARN)
   --    return
   -- end

   local alpha = require "alpha"
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

   dashboard.section.header.val = {
      [[               ]] .. date() .. newline,
      [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
      [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
      [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
      [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
      [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
      [[
    ]],
      [[                      ]] .. nvim_version(),
   }

   dashboard.section.buttons.val = {
      dashboard.button("f", icons.ui.NewFile .. " New file", "<cmd>lua require 'user_lib.functions'.new_file()<CR>"),
      dashboard.button(
         "t",
         icons.ui.NewFile .. " New temp file",
         "<cmd>lua require 'user_lib.functions'.new_tmp_file()<CR>"
      ),
      dashboard.button(
         "N",
         icons.ui.Note .. " Notes",
         "<cmd>edit ~/Library/Mobile Documents/com~apple~CloudDocs/Notes/notes.md<CR>"
      ),

      dashboard.button(
         "F",
         icons.documents.Files .. " Find file",
         "<cmd>lua require 'telescope.builtin'.find_files()<CR>"
      ),
      dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>lua require 'telescope.builtin'.oldfiles()<CR>"),
      dashboard.button(
         "R",
         icons.git.Repo .. " Find project",
         "<cmd>lua require 'telescope'.extensions.project.project{}<CR>"
      ),
      dashboard.button(
         "u",
         icons.ui.Uni .. " University",
         [[<cmd>lua require "telescope".extensions.file_browser.file_browser { cwd = "$CS"}<CR>]]
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
         "<cmd>lua require 'user_lib.functions'.restore_session()<CR>"
      ),
      dashboard.button(
         "C",
         icons.ui.Gear .. " Config",
         [[<cmd>lua require "telescope".extensions.file_browser.file_browser { cwd = "$NVIMDOTDIR" }<CR>]]
      ),
      dashboard.button(
         "D",
         icons.ui.Lock .. " Dotfiles",
         [[<cmd>lua require "telescope".extensions.file_browser.file_browser { cwd = "$DOTFILES" }<CR>]]
      ),
      dashboard.button("h", icons.ui.Health .. " Health", "<cmd>checkhealth<CR>"),
      dashboard.button("c", icons.documents.Files .. " Close", "<cmd>Alpha<CR>"),
      dashboard.button("q", icons.diagnostics.Error .. " Quit", "<cmd>qa<CR>"),
   }

   local footer = function()
      local plugins = require("lazy").stats().count
      local loaded = require("lazy").stats().loaded
      local plugins_count = string.format("      %s %d Plugins, %d loaded \n\n", icons.ui.Plugin, plugins, loaded)

      local my_url = "https://github.com/kevinm6/nvim"
      local myself = string.format(" %s %s ", icons.misc.GitHub, my_url)

      return plugins_count .. newline .. newline .. myself
   end

   dashboard.section.footer.val = footer()

   dashboard.section.header.opts.hl = "AlphaHeader"
   dashboard.section.buttons.opts.hl = "AlphaButtons"
   dashboard.section.footer.opts.hl = "AlphaFooter"

   -- dashboard.config.opts.noautocmd = true

   alpha.setup(dashboard.opts)

   vim.keymap.set("n", "<leader>a", function()
      vim.cmd.Alpha {}
   end, { desc = "Alpha Dashboard" })
end

return M
