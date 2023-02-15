--------------------------------------
-- File         : lazy.lua
-- Description  : Plugin Manager (Lazy) config
-- Author       : Kevin
-- Last Modified: 15 Feb 2023, 20:33
--------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.notify(
    (" %s\n (%s)"):format("Error loading lazy config \n ", lazy),
    "Error",
    { timeout = 1000, title = "INIT ERROR" }
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
    root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
    defaults = {
      lazy = true, -- should plugins be lazy-loaded?
      version = nil,
      -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    concurrency = nil, ---@type number limit the maximum amount of concurrent tasks
    git = {
      -- defaults for the `Lazy log` command
      -- log = { "-10" }, -- show the last 10 commits
      log = { "--since=3 days ago" }, -- show commits from the last 3 days
      timeout = 120, -- kill processes that take more than 2 minutes
      url_format = "git@github.com:%s.git",
    },
    dev = {
      -- directory where you store your local plugin projects
      path = "~/dev",
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = { "knvim" }, -- For example {"folke"}
    },
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = {},
    },
    ui = {
      -- a number <1 is a percentage., >1 is a fixed size
      size = { width = 0.8, height = 0.8 },
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = "none",
      icons = {
        cmd = " ",
        config = "",
        event = "",
        ft = " ",
        init = " ",
        keys = " ",
        plugin = " ",
        runtime = " ",
        source = " ",
        start = "",
        task = "✔ ",
      },
      throttle = 20, -- how frequently should the ui process render events
      browser = 'Min',
    },
    checker = {
      -- automatically check for plugin updates
      enabled = false,
      concurrency = nil, ---@type number? set to 1 to check for updates very slowly
      notify = true, -- get a notification when new updates are found
      frequency = 3600, -- check for updates every hour
    },
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = true, -- get a notification when changes are found
    },
    performance = {
      cache = {
        enabled = true,
        path = vim.fn.stdpath("state") .. "/lazy/cache",
        -- Once one of the following events triggers, caching will be disabled.
        -- To cache all modules, set this to `{}`, but that is not recommended.
        -- The default is to disable on:
        --  * VimEnter: not useful to cache anything else beyond startup
        --  * BufReadPre: this will be triggered early when opening a file from the command line directly
        disable_events = { "VimEnter", "BufReadPre" },
        ttl = 3600 * 24 * 3 -- keep unused modules for up to 2 days
      },
      reset_packpath = true, -- reset the package path to improve startup time
      rtp = {
        reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
        ---@type string[]
        paths = {}, -- add any custom paths here that you want to indluce in the rtp
        ---@type string[] list any plugins you want to disable here
        disabled_plugins = {
          "gzip",
          -- "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
      root = vim.fn.stdpath("state") .. "/lazy/readme",
      files = { "README.md" },
      -- only generate markdown helptags for plugins that dont have docs
      skip_if_doc_exists = true,
    },
  })

vim.keymap.set("n", "<leader>L", function() vim.cmd.Lazy() end, { desc = "Package Manager" })

local Util = require "lazy.util"
local modules = {
  "config.prefs",
  "config.vars",
  "config.autocommands",
  "config.keymaps"
}

for _, mod in ipairs(modules) do
  Util.try(function()
    require(mod)
  end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local modpath = require "lazy.core.cache".find(mod)
        if modpath then
          Util.error(msg)
        end
      end,
    })
end
