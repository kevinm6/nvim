---@diagnostic disable: missing-fields
----------------------------------------
--  File         : noice.lua
--  Description  : noice plugin configuration
--  Author       : Kevin
--  Last Modified: 03 Dec 2023, 10:49
----------------------------------------

local M = {
  "folke/noice.nvim",
  cmd = "Noice",
  event = { "VeryLazy", "CmdLineEnter" },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      event = "BufRead",
      config = function(_, o)
        -- Animation style (see below for details)
        o.stages = "fade"

        -- Function called when a new window is opened, use for changing win settings/config
        o.on_open = nil

        -- Function called when a window is closed
        o.on_close = nil

        -- Render function for notifications. See notify-render()
        o.render = "default"

        -- Default timeout for notifications
        o.timeout = 1600

        -- For stages that change opacity this is treated as the highlight behind the window
        -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
        o.background_colour = "#2c2c2c"

        -- Minimum width for notification windows
        o.minimum_width = 12

        o.max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end
        o.max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end

        local icons = require "lib.icons"
        -- Icons for the different levels
        o.icons = {
          ERROR = icons.diagnostics.Error,
          WARN  = icons.diagnostics.Warning,
          INFO  = icons.diagnostics.Information,
          DEBUG = icons.ui.Bug,
          TRACE = icons.ui.Pencil,
        }

        local notify = require "notify"
        notify.setup(o)
        vim.notify = notify
      end
    }
  },
  opts = function(_, o)
    o.cmdline = {
      enabled = true,
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
      icons = {
        ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
        ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
        [":"] = { icon = " ", hl_group = "DiagnosticInfo", firstc = false },
      },
      format = {
        cmdline = { icon = " " },
        search_down = { icon = " ⌄" },
        search_up = { icon = " ⌃" },
        filter = { icon = "" },
        lua = { icon = " " },
        help = { icon = "" },
      },
    }
    o.lsp = {
      progress = {
        format_done = {
          { "✓ ", hl_group = "NoiceLspProgressSpinner" },
          { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
          { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
        },
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = true,
      },
      hover = {
        enabled = true,
      },
    }
    o.presets = {
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true,
    }
    o.views = {
      cmdline_popup = {
        position = {
          row = "90%",
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "83%",
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = {
            bottom = -1,
            left = 1,
            right = 1
          },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "WinSeparator" },
        },
      },
      split = {
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "WinSeparator" },
        },
      },
      mini = { win_options = { winblend = 6 } }
    } -- @see the section on views below
    ---@type NoiceRouteConfig[]
    -- NOTE: https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#messages-and-notifications-in-neovim
    o.routes = {
      -- NOTE: reroute long notifications to split
      -- {
      --    filter = {
      --       event = "msg_show",
      --       any = { { min_height = 5 }, { min_width = 100 } },
      --       ["not"] = {
      --          kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" }
      --       },
      --       blocking = false
      --    },
      --    view = "messages",
      --    opts = { stop = true }
      -- },
      {
        filter = {
          event = "notify",
          min_height = 4
        },
        view = "split",
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "workspace", -- skip all progress containing 'workspace'
        },
        opts = { skip = true }
      },
      -- { -- skip lsp_progress for client
      --    filter = {
      --      event = "lsp",
      --      kind = "progress",
      --      cond = function(message)
      --        local client = vim.tbl_get(message.opts, "progress", "client")
      --        return client == "lua_ls" -- skip lua-ls progress
      --      end,
      --    },
      --    opts = { skip = true },
      --  },
      -- NOTE: avoid search messages (using virtualtext as default)
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      { -- show @recording messages as notification
        view = "notify",
        filter = { event = "msg_showmode" },
      },
      {
        view = "mini",
        filter = {
          event = "msg_show",
          any = {
            { find = '; after #%d+' },
            { find = '; before #%d+' },
            { find = 'fewer lines' },
            { find = 'written' },
            { find = 'E162' },
            { find = 'E37' }
          }
        }
      },
      {
        view = 'mini',
        filter = {
          event = 'notify',
          any = {
            { find = 'hidden' },
            { find = 'clipboard' },
          },
        },
      },
      -- NOTE: this avoid written messages
      -- {
      --    filter = {
      --       event = "msg_show",
      --       kind = "",
      --    },
      --    opts = { skip = true },
      -- },
    } -- @see the section on routes below
    ---@type table<string, NoiceFilter>
    o.status = {} --@see the section on statusline components below
    ---@type NoiceFormatOptions
    o.format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- view: (default is cmdline view)
      -- opts: any options passed to the view
      -- icon_hl_group: optional hl_group for the icon
      -- title: set to anything or empty string to hide
      default = { "{level} ", "{title} ", "{message}" },
      notify = { "{message}" },
      level = { icons = { error = " ", warn = " ", info = " " } },
      details = {
        "{level} ",
        "{date} ",
        "{event}",
        { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
        " ",
        "{title} ",
        "{cmdline} ",
        "{message}",
      },
      cmdline = {
        pattern = "^:",
        icon = "",
        lang = "vim",
      },
      search_down = {
        kind = "search",
        pattern = "^/",
        icon = " ",
        lang = "regex",
      },
      search_up = {
        kind = "search",
        pattern = "^%?",
        icon = " ",
        lang = "regex",
      },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = {
        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
        icon = "",
        lang = "lua",
      },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
      input = {}, -- Used by input()
      -- lua = false, -- to disable a format, set to `false`
    } -- @see section on formatting
  end,
  config = function(_, o)
    require "noice".setup(o)

    vim.keymap.set({ "n", "s" }, "<C-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<C-f>"
      end
    end, { silent = true, expr = true })

    vim.keymap.set({ "n", "s" }, "<C-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<C-b>"
      end
    end, { silent = true, expr = true })

    vim.keymap.set("n",
      "<leader>n",
      function() end,
      { desc = "Notifications" }
    )
    vim.keymap.set("n",
      "<leader>nn",
      function()
        require("noice").cmd "History"
      end,
      { desc = "Notifications" }
    )
    vim.keymap.set("n",
      "<leader>nL",
      function()
        require("noice").cmd "Log"
      end,
      { desc = "Log" }
    )
    vim.keymap.set("n",
      "<leader>ne",
      function()
        require("noice").cmd "Error"
      end,
      { desc = "Error" }
    )
    vim.keymap.set("n",
      "<leader>nl",
      function()
        require("noice").cmd "Last"
      end,
      { desc = "NoiceLast" }
    )
    vim.keymap.set("n",
      "<leader>nt",
      function()
        require("telescope").extensions.noice.noice { theme = "dropdown" }
      end,
      { desc = "Noice Telescope" }
    )

  end
}

return M