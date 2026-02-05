-------------------------------------
-- File         : snacks.lua
-- Description  : snacks plugin config
-- Author       : Kevin
-- Last Modified: 03 Feb 2026, 20:54
-------------------------------------

require("snacks").setup {
  bigfile = { enabled = false },
  dashboard = {
    enabled = false,
    preset = {
      keys = {
        { icon = "", key = "n", desc = "New file", action = ":lua require 'lib'.new_file()" },
        { icon = "", key = "t", desc = "New temp file", action = ":lua require 'lib'.new_tmp_file()" },
        { icon = "", key = "o", desc = "Notes", action = [[:lua require "lib.notes".open_note()]] },
        { icon = "󰾰", key = "f", desc = "Find file", action = ":lua require 'lib'.find_files()" },
        { icon = "", key = "r", desc = "Recent files", action = ":lua require 'lib'.recent_files()" },
        { icon = "", key = "p", desc = "Find project", action = ":lua require 'lib'.projects()" },
        { icon = "", key = "s", desc = "Sessions", action = ":lua require 'lib.session'.restore()" },
        { icon = "", key = "L", desc = "Plugin Manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = "", key = "m", desc = "Package Manager", action = ":Mason" },
        { icon = "", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      -- { section = "terminal", cmd = "curl -s 'wttr.in/?0'" },
      { section = "header", padding = 2 },
      function()
        local v = vim.version()
        local v_info = (" v%d.%d.%d"):format(v.major, v.minor, v.patch)
        return {
          title = "version",
          align = "center",
          padding = 2,
          text = v_info,
          hl = "Comment",
        }
      end,
      { section = "keys",   gap = 1,    padding = 1 },
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
  image = {
    resolve = function(_, src)
      if vim.startswith(src, "{{ url_for('") then -- match in Flask apps
        local path = src:match("url_for%('([^']+)'")
        local filename = src:match("filename='([^']+)'")
        if path and filename then
          local dir = vim.fs.find(path, { type = "directory", path = vim.fn.getcwd() })
          local file_path = ("%s/%s"):format(dir[1], filename)
          return file_path
        end
      end
    end
  },
  explorer = { enabled = false },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", height = 0.6, border = "left" },
            },
            { win = "input", height = 1, border = "top" },
          },
        },
      },
      files = {
        win = {
          input = {
            keys = {
              ["<c-g>"] = {
                function(picker)
                  local dir = vim.uv.cwd() .. "/.."
                  vim.fn.chdir(dir)
                  Snacks.notify("cwd set to " .. vim.uv.cwd())
                  picker:close()
                  vim.schedule(function() Snacks.picker.files { dirs = { dir } } end)
                end,
                mode = { "n", "i" }
              }
            }
          }
        },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
          },
        },
      },
      select = {
        ayout = {
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
          },
        },
      },
      lsp_definitions = {
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
              { win = "list",    border = "none" },
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
              { win = "list",    border = "none" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.4,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
          },
        },
      },
      projects = {
        confirm = "picker",
        dev = { "~/Documents/develoer", "~/dev", "~/uni", "~/Informatica" },
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
              { win = "list",    border = "none" },
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
            { win = "list",  border = "none" },
            { win = "input", height = 1,     border = "top" },
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
            { win = "preview", title = "{preview}", height = 0.6,  border = "bottom" },
            { win = "list",    border = "none" },
            { win = "input",   height = 1,          border = "top" },
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
  quickfile = { enabled = false },
  notifier = { enabled = false }
}

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>fs", function()
  Snacks.picker.smart()
end, { desc = "Smart search" })
vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader><M-7>", function()
  vim.ui.input({ prompt = "Enter directory where start grep: " }, function(input)
    if input and input ~= "" then
      vim.schedule(function()
        Snacks.picker.grep { dirs = { input } }
      end)
    end
 end)
end, { desc = "Grep in Dir" })

vim.keymap.set("n", "<leader>fh", function()
  local cword = vim.fn.expand "<cword>"
  Snacks.picker.help { search = "Search in Help", default_text = cword }
end, { desc = "Help" })

vim.keymap.set("n", "<leader>fg", function()
  Snacks.picker.git_files()
end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>fR", function()
  Snacks.picker.registers()
end, { desc = "Registers" })
vim.keymap.set("n", "<leader>fq", function()
  Snacks.picker.qflist()
end, { desc = "QuickFix" })

vim.keymap.set("n", "<leader>fQ", function()
  Snacks.picker.loclist()
end, { desc = "LocationList" })
vim.keymap.set("n", "<leader>fl", function()
  Snacks.picker.resume()
end, { desc = "Resume last" })
vim.keymap.set("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fL", function()
  Snacks.picker.lines()
end, { desc = "Line fuzzy" })
vim.keymap.set("n", "<leader>fc", function()
  Snacks.picker.commands()
end, { desc = "Commands" })
vim.keymap.set("n", "<leader>fe", function()
  require("lib.env").show_vars()
end, { desc = "Environment" })
vim.keymap.set("n", "<leader>fO", function()
  require("lib.software_licenses").pick_license()
end, { desc = "Software Licenses" })
vim.keymap.set("n", "<leader>g/", function()
  Snacks.picker.grep_word { search = vim.fn.expand "<cword>" }
end, { desc = "Grep < cword >" })
vim.keymap.set("n", "<leader>fW", function()
  local word = vim.fn.expand "<cWORD>"
  Snacks.picker.grep_string {
    theme = "dropdown",
    previewer = false,
    search = word,
  }
end, { desc = "Grep <cword>" })

vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.files { cwd = vim.uv.cwd() }
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fo", function()
  Snacks.picker()
end, { desc = "Open Pickers" })

vim.keymap.set("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent File" })

vim.keymap.set("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })

vim.keymap.set("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end, { desc = "Checkout branch" })

vim.keymap.set("n", "<leader>gl", function()
  Snacks.picker.git_log()
end, { desc = "Checkout commit" })

vim.keymap.set("n", "<leader>gB", function()
  Snacks.picker.blame_line()
end, { desc = "Blame line" })

vim.keymap.set("n", "z=", function()
  Snacks.picker.spelling { word = "<cword>" }
end, { desc = "Spelling suggestion" })

-- {
--   "<leader>fp",
--   function()
--     Snacks.picker.projects()
--   end,
--   desc = "Projects",
-- },