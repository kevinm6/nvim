-------------------------------------
-- File         : snacks.lua
-- Description  : snacks plugin config
-- Author       : Kevin
-- Last Modified: 25/02/2025 - 08:52
-------------------------------------

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {},
    dashboard = {
      preset = {
        keys = {
          { icon = "", key = "n", desc = "New file", action = ":lua require 'lib'.new_file()" },
          { icon = "", key = "t", desc = "New temp file", action = ":lua require 'lib'.new_tmp_file()" },
          { icon = "", key = "o", desc = "Notes", action = [[:lua require "lib.notes".open_note()]] },
          { icon = "󰾰", key = "f", desc = "Find file", action = ":lua require 'lib'.find_files()" },
          { icon = "", key = "r", desc = "Recent files", action = ":lua require 'lib'.recent_files()" },
          { icon = "", key = "p", desc = "Find project", action = ":lua require 'lib'.projects()" },
          -- { icon = "󰾰", key = "d", desc = "Developer", action = [[:lua require "lib".dev_folder()]] },
          { icon = "", key = "L", desc = "Plugin Manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "", key = "m", desc = "Package Manager", action = ":Mason" },
          { icon = "", key = "g", desc = "Git", action = ":Lazygit" },
          { icon = "♥", key = "H", desc = "Health", action = ":checkhealth" },
          -- { icon = "", key = "c", desc = "Close", action = ":close" },
          { icon = "", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        -- { section = "terminal", cmd = "curl -s 'wttr.in/?0'" },
        { section = "header", padding = 4 },
        { section = "keys", gap = 1, padding = 1 },
        -- { section = "startup" },
        -- {
        --   icon = " ",
        --   title = "Git Status",
        --   section = "terminal",
        --   enabled = function()
        --     return Snacks.git.get_root() ~= nil
        --   end,
        --   cmd = "git status --short --branch --renames",
        --   height = 5,
        --   padding = 1,
        --   ttl = 5 * 60,
        --   indent = 3,
        -- },
      },
      formats = {
        header = { "%s", align = "center", hl = "Type" },
        key = function(item)
          return item.desc == "Quit" and { item.key, hl = "LspDiagnosticsError" } or { item.key, hl = "Function" }
        end,
        icon = function(item)
          return item.desc == "Quit" and { item.icon, hl = "LspDiagnosticsError" } or { item.icon, hl = "Function" }
        end,
        -- footer = { "%s", align = "center", hl = "@comment" },
      },
    },
    image = {},
    -- explorer = {},
    -- input = {
    --   relative = "editor",
    --   row = -2,
    -- },
    picker = {
      sources = {
        pickers = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.8,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        buffers = {
          finder = "buffers",
          format = "buffer",
          hidden = false,
          unloaded = false,
          current = false,
          sort_lastused = true,
          win = {
            input = {
              keys = {
                ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                ["dd"] = { "bufdelete", mode = { "n" } },
              },
            },
            list = { keys = { ["dd"] = "bufdelete" } },
          },
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.5,
              -- min_width = 80,
              height = 0.4,
              -- min_height = 3,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        recent = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.8,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        smart = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              width = 0.75,
              height = 0.8,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.6, border = "left" },
              },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        files = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.5,
              min_height = 3,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        select = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.5,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        lsp_symbols = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        lsp_workspace_symbols = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        lsp_definitions = {
          layout = {
            reverse = true,
            preview = true,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        diagnostics = {
          layout = {
            reverse = true,
            preview = true,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.6,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        diagnostics_buffer = {
          layout = {
            reverse = true,
            preview = true,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.6,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        lsp_references = {
          layout = {
            reverse = true,
            preview = true,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_files = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_status = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_branches = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_stash = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_log = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        git_diff = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        grep = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.6, border = "left" },
              },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        grep_word = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.6, border = "left" },
              },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        keymaps = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              row = -2,
              width = 0.9,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        commands = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              row = -2,
              width = 0.9,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        registers = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              backdrop = false,
              row = -2,
              width = 0.9,
              height = 0.6,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.4, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        projects = {
          dev = { "~/Documents/developer", "~/dev", "~/uni" },
          layout = {
            reverse = true,
            preview = false,
            layout = {
              width = 0.75,
              height = 0.8,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.6, border = "left" },
              },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        spelling = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        help = {
          layout = {
            row = -2,
            reverse = true,
            preview = false,
            layout = {
              width = 0.6,
              height = 0.7,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
        ["Software Licenses"] = {
          layout = {
            reverse = true,
            preview = false,
            layout = {
              width = 0.6,
              height = 0.4,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "preview", title = "{preview}", height = 0.6, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
      },

      layout = {
        preset = function()
          return vim.o.columns >= 120 and "telescope" or "vertical"
        end,
      },
      win = {
        input = {
          keys = {
            ["<c-l>"] = { "confirm", mode = { "n", "i" } },
            ["<c-u>"] = { "list_scroll_up", mode = { "n" } }, -- delete backward till start in insert-mode
          },
        },
      },
    },
    quickfile = {},
    lazygit = {
      win = {
        style = "lazygit",
        width = 0.94,
        height = 0.94,
      },
    },
  },
  keys = {
    {
      "<leader><leader>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },

    {
      "<leader>fs",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart search",
    },
    {
      "<leader>fF",
      function()
        Snacks.picker.grep()
      end,
      desc = "Find Text (LiveGrep)",
    },

    {
      "<leader>fh",
      function()
        local cword = vim.fn.expand "<cword>"
        Snacks.picker.help {
          search = "Search in Help",
          default_text = cword,
        }
      end,
      desc = "Help",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Git Files",
    },
    {
      "<leader>fR",
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "QuickFix",
    },
    {
      "<leader>fQ",
      function()
        Snacks.picker.loclist()
      end,
      desc = "LocationList",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fL",
      function()
        Snacks.picker.lines()
      end,
      desc = "Line fuzzy",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>fe",
      function()
        require("lib.env").show_vars()
      end,
      desc = "Environment",
    },
    {
      "<leader>fO",
      function()
        require("lib.software_licenses").pick_license()
      end,
      desc = "Software Licenses",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word { search = vim.fn.expand "<cword>" }
      end,
      desc = "Grep < cword >",
    },
    {
      "<leader>fW",
      function()
        local word = vim.fn.expand "<cWORD>"
        Snacks.picker.grep_string {
          theme = "dropdown",
          previewer = false,
          search = word,
        }
      end,
      desc = "Grep <cword>",
    },

    {
      "<leader>ff",
      function()
        Snacks.picker.files { cwd = vim.uv.cwd() }
      end,
      desc = "Find Files",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker()
      end,
      desc = "Open Pickers",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent File",
    },
    -- {
    --   "<leader>fp",
    --   function()
    --     Snacks.picker.projects()
    --   end,
    --   desc = "Projects",
    -- },

    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git status",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Checkout branch",
    },
    {
      "<leader>gc",
      function()
        Snacks.picker.git_commits()
      end,
      desc = "Checkout commit",
    },
    {
      "z=",
      function()
        Snacks.picker.spelling { word = "<cword>" }
      end,
      desc = "Spelling suggestion",
    },
  },
}
