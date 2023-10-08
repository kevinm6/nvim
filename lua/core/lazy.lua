--------------------------------------
-- File         : lazy.lua
-- Description  : Plugin Manager (Lazy) config
-- Author       : Kevin
-- Last Modified: 07 Oct 2023, 19:07
--------------------------------------

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
   }
end
vim.opt.runtimepath:prepend(lazypath)

local has_lazy, lazy = pcall(require, "lazy")
if not has_lazy then
   vim.notify(
      (" %s\n (%s) \n"):format("Error loading lazy config", lazy),
      vim.log.levels.ERROR,
      { timeout = 1000, title = "LAZY ERROR" }
   )
   return
end

lazy.setup({
   { import = "plugins.dashboard" },
   { import = "plugins.core" },
   { import = "plugins.ui" },
   { import = "plugins" },
   { import = "plugins.utils" },
}, {
      root = vim.fn.stdpath "data" .. "/lazy",                    -- directory where plugins will be installed
      defaults = {
         lazy = true,                                             -- plugins lazy-loaded by default
      },
      lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json",    -- lockfile generated after running update.
      dev = {
         path = vim.fn.expand "~/dev",
         fallback = false,
      },
      install = {
         -- install missing plugins on startup. This doesn't increase startup time.
         missing = false,
         -- try to load one of these colorschemes when starting an installation during startup
         colorscheme = { "knvim", "habamax" },
      },
      ui = {
         title = "Plugin Manager",
         -- a number <1 is a percentage., >1 is a fixed size
         size = { width = 0.8, height = 0.8 },
         -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
         border = "rounded",
         icons = {
            cmd = " ",
            config = "",
            event = "",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "●",
            not_loaded = "○",
            plugin = " ",
            runtime = " ",
            require = "󰢱 ",
            source = " ",
            start = "",
            task = " ",
            list = {
               "●",
               "→",
               "",
               "‒",
            },
         },
      },
      performance = {
         cache = {
            enabled = true,
            path = vim.fn.stdpath "state" .. "/lazy/cache",
         },
         reset_packpath = true,
         rtp = {
            reset = true,    -- reset the runtime path to $VIMRUNTIME and your config directory
            disabled_plugins = {
               "gzip",
               "matchit",
               "matchparen",
               "netrwPlugin",
               "tarPlugin",
               "tohtml",
               "tutor",
               "zipPlugin",
            },
         },
      }
   })

vim.keymap.set("n", "<leader>Cl", function()
   vim.cmd.Lazy()
end, { desc = "Package Manager" })

local Util = require "lazy.util"
local modules = {
   "config.prefs",
   "config.vars",
   "config.autocommands",
   "config.keymaps",
}

for _, mod in ipairs(modules) do
   Util.try(function()
      require(mod)
   end, {
         msg = "Failed loading " .. mod,
         on_error = function(msg)
            local modpath = require("lazy.core.cache").find(mod)
            if modpath then
               Util.error(msg)
            end
         end,
      })
end
