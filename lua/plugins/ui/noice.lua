----------------------------------------
--  File         : noice.lua
--  Description  : noice plugin configuration
--  Author       : Kevin
--  Last Modified: 23 Jan 2023, 16:57
----------------------------------------

local M = {
  "folke/noice.nvim",
  cmd = "Noice",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
}

function M.config()
  local noice = require "noice"

  noice.setup {
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
      icons = {
        ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
        ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
        [":"] = { icon = " ", hl_group = "DiagnosticInfo", firstc = false },
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true, -- enables the Noice messages UI
      view = "notify", -- default view for messages
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
      opts = {},
    },
    popupmenu = {
      enabled = true, -- disable if you use something like cmp-cmdline
      ---@type 'nui'|'cmp'
      backend = "nui", -- backend to use to show regular cmdline completions
      kind_icons = {},
    },
    -- :Noice command
    commands = {
      -- :Noice history
      history = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp", kind = "message" },
          },
        },
      },
      -- :Noice last
      last = {
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp", kind = "message" },
          },
        },
        filter_opts = { count = 1 },
      },
      -- :Noice errors
      errors = {
        -- options for the message history that you get with `:Noice`
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = { error = true },
        filter_opts = { reverse = true },
      },
    },
    notify = {
      -- Noice can be used as `vim.notify` so you can route any notification like other messages
      -- Notification messages have their level and other properties set.
      -- event is always "notify" and kind can be any log level as a string
      -- The default routes will forward notifications to nvim-notify
      -- Benefit of using Noice for this is the routing and consistent history view
      enabled = true,
      view = "notify"
    },
    lsp = {
      progress = {
        enabled = true,
        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
        -- See the section on formatting for more details on how to customize.
        --- @type NoiceFormat|string
        format = "lsp_progress",
        --- @type NoiceFormat|string
        format_done = "lsp_progress_done",
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = "mini",
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
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {}, -- merged with defaults from documentation
      },
      hover = {
        enabled = true,
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {}, -- merged with defaults from documentation
      },
      message = {
        -- Messages shown by lsp servers
        enabled = true,
        view = "notify",
        opts = {},
      },
      -- defaults for hover and signature help
      documentation = {
        view = "hover",
        ---@type NoiceViewOptions
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },
    markdown = {
      hover = {
        ["|(%S-)|"] = vim.cmd.help, -- vim help links
        ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
      },
      highlights = {
        ["|%S-|"] = "@text.reference",
        ["@%S+"] = "@parameter",
        ["^%s*(Parameters:)"] = "@text.title",
        ["^%s*(Return:)"] = "@text.title",
        ["^%s*(See also:)"] = "@text.title",
        ["{%S-}"] = "@parameter",
      },
    },
    health = {
      checker = true, -- Disable if you don't want health checks to run
    },
    smart_move = {
      -- noice tries to move out of the way of existing floating windows.
      enabled = true, -- you can disable this behaviour here
      -- add any filetypes here, that shouldn't trigger smart move.
      excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
    },
    ---@type NoicePresets
    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
    ---@type table<string, NoiceViewOptions>
    views = {
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
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    }, -- @see the section on views below
    ---@type NoiceRouteConfig[]
    routes = {
      {
        filter = {
          event = "notify",
          min_height = 15
        },
        view = 'split'
      },
      -- {
      --   filter = {
      --     event = "msg_show",
      --     kind = "",
      --   },
      --   opts = { skip = true },
      -- },
    }, -- @see the section on routes below
    ---@type table<string, NoiceFilter>
    status = {}, --@see the section on statusline components below
    ---@type NoiceFormatOptions
    format = {}, -- @see section on formatting
  }

  vim.keymap.set("n", "<leader>nn", function() noice.cmd "History" end, { desc = "Notifications" })
  vim.keymap.set("n", "<leader>nL", function() noice.cmd "Log" end, { desc = "Log" })
  vim.keymap.set("n", "<leader>ne", function() noice.cmd "Error" end, { desc = "Error" })
  vim.keymap.set("n", "<leader>nl", function() noice.cmd "Last" end, { desc = "Last" })
  vim.keymap.set("n", "<leader>nt", function()
    require "telescope".extensions.noice.noice { theme = "dropdown" }
  end, { desc = "Noice Telescope" })


  vim.keymap.set("n", "<c-f>", function()
    if not require("noice.lsp").scroll(4) then
      return "<c-f>"
    end
  end, { silent = true, expr = true })

  vim.keymap.set("n", "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then
      return "<c-b>"
    end
  end, { silent = true, expr = true })
end

return M