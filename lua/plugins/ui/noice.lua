----------------------------------------
--  File         : noice.lua
--  Description  : noice plugin configuration
--  Author       : Kevin
--  Last Modified: 08 May 2024, 12:10
----------------------------------------

return {
  {
    "folke/noice.nvim",
    cmd = "Noice",
    event = { "VeryLazy" },
    opts = function(_, o)
      local icons = require "lib.icons"

      o.cmdline = {
        -- opts = { buf_options = { filetype = 'vim' } }, -- enable syntax highlighting in the cmdline
        icons = {
          ["/"] = { icon = icons.ui.Search, hl_group = "DiagnosticWarn" },
          ["?"] = { icon = icons.ui.Search, hl_group = "DiagnosticWarn" },
          [":"] = { icon = icons.ui.term, hl_group = "DiagnosticInfo", firstc = false },
        },
        format = {
          cmdline = { icon = icons.ui.term },
          search_down = { icon = icons.ui.Search .. "⌄" },
          search_up = { icon = icons.ui.Search .. "⌃" },
          -- execute shell command (!command)
          filter = { pattern = "^:%s*!", icon = "$", ft = "sh" },
          -- replace file content with shell command output (%!command)
          f_filter = { pattern = "^:%s*%%%s*!", icon = icons.documents.File .. "$", ft = "sh" },
          -- replace selection with shell command output (%! command on visual selection)
          v_filter = { pattern = "^:%s*%'<,%'>%s*!", icon = " $", ft = "sh" },
          lua = { icon = " " },
          help = { icon = "" },
          substitute = {
            pattern = { "^:%%?s/", "'<,'>s/" }, -- range substitute
            icon = " ",
            ft = "regex",
            opts = { border = { text = { top = " sub (old/new/) " } } },
          },
        },
      }
      o.lsp = {
        progress = {
          format_done = {
            { "✓ ", hl_group = "NoiceLrpProgressSpinner" },
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
      }
      o.presets = {
        long_message_to_split = true,
        cmdline_output_to_split = true,
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
        split = {
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "WinSeparator" },
          },
        },
        mini = {
          timeout = 3000,
          win_options = { winblend = 8 },
        },
      } -- @see the section on views below
      -- NOTE: https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#messages-and-notifications-in-neovim
      o.routes = {
        {
          filter = {
            event = "notify",
            min_height = 6,
          },
          view = "split",
        },
        {
          filter = {
            event = "lsp",
            kind = "progress",
            any = {
              { find = "workspace" }, -- skip all progress containing 'workspace'
              { find = "code_action" },
            },
          },
          opts = { skip = true },
        },
        { -- disable view "mini" in insert mode
          view = "mini",
          filter = { mode = "i" },
          opts = { skip = true },
        },
        { -- NOTE: avoid search messages (using virtualtext as default)
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
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "fewer lines" },
              { find = "written" },
              { find = "E162" },
              { find = "E37" },
              -- { event = "msg_show", find = '[nvim-treesitter] [%d/%d]' }
            },
          },
        },
        {
          view = "mini",
          filter = {
            event = "notify",
            any = {
              { find = "hidden" },
              { find = "clipboard" },
            },
          },
        },
        { -- reroute DAP messages to view "mini"
          filter = {
            event = "notify",
            cond = function(message)
              return message.opts and message.opts.title == "DAP"
            end,
          },
          opts = { skip = true },
        },
      }
      o.format = {
        level = {
          icons = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warning,
            info = icons.diagnostics.Information,
          },
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
          icon = " ",
          lang = "lua",
        },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
      }
    end,
    config = function(_, o)
      local noice = require "noice"
      noice.setup(o)

      -- Keymaps
      local function nsmap(tbl)
        vim.keymap.set({ "n", "s" }, tbl[1], tbl[2], { silent = true, expr = true })
      end

      nsmap {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
          end
        end,
      }

      nsmap {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-b>"
          end
        end,
      }

      local function nmap(tbl)
        vim.keymap.set("n", tbl[1], tbl[2], { desc = require("lib.icons").ui.Bell .. tbl[3] })
      end

      nmap { "<leader>n", function() end, "Notifications" }
      nmap {
        "<leader>nn",
        function()
          noice.cmd "History"
        end,
        "Notifications",
      }
      nmap {
        "<leader>nL",
        function()
          noice.cmd "Log"
        end,
        "Log",
      }
      nmap {
        "<leader>ne",
        function()
          noice.cmd "Error"
        end,
        "Error",
      }
      nmap {
        "<leader>nl",
        function()
          noice.cmd "Last"
        end,
        "NoiceLast",
      }
      nmap {
        "<leader>nt",
        function()
          require("telescope").extensions.noice.noice { theme = "dropdown" }
        end,
        "Noice Telescope",
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function(_, o)
      o.stages = "fade"
      o.on_open = nil
      o.on_close = nil
      o.render = "default"
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
        WARN = icons.diagnostics.Warning,
        INFO = icons.diagnostics.Information,
        DEBUG = icons.ui.Bug,
        TRACE = icons.ui.Pencil,
      }

      local notify = require "notify"
      notify.setup(o)
      vim.notify = notify
    end,
  },
}