----------------------------------------
--  File         : noice.lua
--  Description  : noice plugin configuration
--  Author       : Kevin
--  Last Modified: 08 Oct 2023, 12:54
----------------------------------------

local M = {
  "folke/noice.nvim",
  cmd = "Noice",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    { "MunifTanjim/nui.nvim", event = "BufReadPre" },
    "rcarriga/nvim-notify",
    -- "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>n",
      function() end,
      desc = "Notifications",
    },
    {
      "<leader>nn",
      function()
        require("noice").cmd "History"
      end,
      desc = "Notifications",
    },
    {
      "<leader>nL",
      function()
        require("noice").cmd "Log"
      end,
      desc = "Log",
    },
    {
      "<leader>ne",
      function()
        require("noice").cmd "Error"
      end,
      desc = "Error",
    },
    {
      "<leader>nl",
      function()
        require("noice").cmd "Last"
      end,
      desc = "NoiceLast",
    },
    {
      "<leader>nt",
      function()
        require("telescope").extensions.noice.noice { theme = "dropdown" }
      end,
      desc = "Noice Telescope",
    },
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
    } -- @see the section on views below
    ---@type NoiceRouteConfig[]
    -- NOTE: https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#messages-and-notifications-in-neovim
    o.routes = {
      -- NOTE: reroute long notifications to split
      {
        filter = {
          event = "notify",
          min_height = 15,
        },
        view = "split",
      },
      -- NOTE: avoid search messages (using virtualtext as default)
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      {
        view = "notify",
        filter = { event = "msg_showmode" },
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

  end
}

return M
