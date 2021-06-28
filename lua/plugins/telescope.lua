---------------------------------------
-- File         : telescope.lua
-- Description  : Telescope config
-- Author       : Kevin
-- Last Modified: 07 Jan 2023, 13:41
---------------------------------------

local M = {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  --  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-project.nvim",
    "benfowler/telescope-luasnip.nvim",
    "debugloop/telescope-undo",
    "LinArcX/telescope-env.nvim",
    { "xiyaowong/telescope-emoji.nvim", module = true, lazy = true },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>e", function() require "telescope".extensions.file_browser.file_browser {} end, desc = "File Browser" },
    { "<leader>b", function() require "telescope.builtin".buffers {} end, desc = "Buffers" },

    { "<leader>ff", function() require "telescope.builtin".find_files {} end, desc = "Find Files" },
    { "<leader>fF", function() require "telescope.builtin".live_grep {} end, desc = "Find Text (LiveGrep)" },
    { "<leader>fo", function() require "telescope.builtin".builtin () end, desc = "Open Telescope" },
    { "<leader>fH", function() require "telescope.builtin".help_tags() end, desc = "Help" },
    { "<leader>fg", function() require "telescope.builtin".git_files {} end, desc = "Git Files" },
    { "<leader>fp", function() require "telescope".extensions.project.project() end, desc = "Projects" },
    { "<leader>fr", function() require "telescope.builtin".oldfiles {} end, desc = "Recent File" },
    { "<leader>fR", function() require "telescope.builtin".registers {} end, desc = "Registers" },
    { "<leader>fk", function() require "telescope.builtin".keymaps {} end, desc = "Keymaps" },
  }
}

-- Do Not show binary
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  require "plenary.job":new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        require "telescope.previewers".buffer_previewer_maker(filepath, bufnr, opts)
      else
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {  mime_type .. " FILE" })
        end)
      end
    end
  }):sync()
end



function M.config()
  local telescope = require "telescope"
  local icons = require "user.icons"

  local actions = require "telescope.actions"
  local action_layout = require "telescope.actions.layout"
  local fb_actions = require "telescope".extensions.file_browser.actions

  telescope.setup {
    defaults = {
      preview = {
        hide_on_startup = true,
      },
      buffer_previewer_maker = new_maker,
      initial_mode = "insert",
      prompt_prefix = icons.ui.Telescope .. "  ",
      selection_caret = "> ",
      path_display = { "smart" },
      file_ignore_patterns = { "Icon?", ".DS_Store" },
      selection_strategy = "reset",
      scroll_strategy = "cycle",
      layout_strategy = "horizontal",
      layout = { horizontal = { width = 0.5 } },
      winblend = 6,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["<esc>"] = actions.close,
          ["<C-u>"] = false,
          ["<C-e>"] = { "<esc>", type = "command" },

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,

          ["<CR>"] = actions.select_default,
          ["<C-l>"] = actions.select_default,
          ["<C-h>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<C-p>"] = actions.preview_scrolling_up,
          ["<C-n>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

          ["<C-y>"] = action_layout.toggle_preview,

          -- ["<C-g>"] = fb_actions.goto_parent_dir,

          ["?"] = actions.which_key,
        },

        n = {
          ["<esc>"] = actions.close,
          q = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-h>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-c>"] = actions.close,

          -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-l>"] = actions.select_default,
          j = actions.move_selection_next,
          k = actions.move_selection_previous,
          l = actions.select_default,
          H = actions.move_to_top,
          M = actions.move_to_middle,
          L = actions.move_to_bottom,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,

          ["<C-p>"] = actions.preview_scrolling_up,
          ["<C-n>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<C-y>"] = action_layout.toggle_preview,

          -- ["g"] = fb_actions.goto_parent_dir,

          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
      find_files = {
        theme = "dropdown",
        previewer = false,
        sorting_strategy = "descending",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          height = 0.3
        },
        cwd = require "lspconfig.util".find_git_ancestor(vim.fn.expand "%:p:h") or vim.fn.expand "%:p:h",
        mappings = {
          n = {
            ["h"] = function(prompt_bufnr)
              local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local opts = {
                hidden = true,
                default_text = current_picker:_get_prompt(),
              }

              require "telescope.actions".close(prompt_bufnr)
              require "telescope.builtin".find_files(opts)
            end,
            ["g"] = function(prompt_bufnr)
              local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local opts = {
                default_text = current_picker:_get_prompt(),
                cwd = vim.fn.expand "%:p:h:h"
              }

              require "telescope.actions".close(prompt_bufnr)
              require "telescope.builtin".resume(opts)
            end,
          },
          i = {
            ["<C-g>"] = function(prompt_bufnr)
              local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local opts = {
                default_text = current_picker:_get_prompt(),
                cwd = vim.fn.expand "%:p:h:h"
              }

              require "telescope.actions".close(prompt_bufnr)
              require "telescope.builtin".find_files(opts)
            end,
          }
        }
      },
      buffers = {
        theme = "dropdown",
        sort_mru = true,
        previewer = false,
        initial_mode = "normal",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom"
        },
        mappings = {
          i = {
            ["<C-d>"] = "delete_buffer"
          },
          n = {
            ["d"] = "delete_buffer"
          }
        }
      },
      oldfiles = {
        theme = "dropdown",
        previewer = false,
        cwd_only = false,
        initial_mode = "insert",
        sorting_strategy = "descending",
        layout_strategy = "bottom_pane",
        layout_config = {
          prompt_position = "bottom",
          height = 0.5
        },
      },
      live_grep = {
        theme = "dropdown",
        initial_mode = "insert",
        sorting_strategy = "descending",
        layout_strategy = "bottom_pane",
        layout_config = {
          prompt_position = "bottom",
          height = 0.7
        },
      },
      git_status = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        sorting_strategy = "descending",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.6, height = 0.4 }
        },
      },
      git_branches = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          width = 0.8,
          height = 0.4
        },
      },
      lsp_diagnostics = {
        theme = "dropdown",
        bufnr = 0,
        initial_mode = "normal",
        sorting_strategy = "descending",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          -- vertical = { width = 0.7, height = 0.8 }
        },
      },
      lsp_references = {
        theme = "cursor",
        bufnr = 0,
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.6, height = 0.8 }
        },
      },
      lsp_definitions = {
        theme = "cursor",
        previewer = true,
        initial_mode = "normal",
      },
      lsp_declarations = {
        theme = "cursor",
        previewer = true,
        initial_mode = "normal",
      },
      lsp_implementations = {
        theme = "cursor",
        previewer = true,
        initial_mode = "normal",
      },
      lsp_document_symbols = {
        theme = "dropdown",
        previewer = false,
        bufnr = 0,
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.6, height = 0.8 }
        },
      },
      lsp_dynamic_workspace_symbols = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.6, height = 0.8 }
        },
      },
      registers = {
        theme = "cursor",
        initial_mode = "normal",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.7, height = 0.5 }
        },
      },
      keymaps = {
        theme = "cursor",
        previewer = false,
        initial_mode = "insert",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.8, height = 0.6 }
        },
      }
    },
    extensions = {
      file_browser = {
        previewer = false,
        cwd = "%:p:h",
        initial_mode = "insert",
        select_buffer = true,
        hijack_netrw = true,
        layout_strategy = "bottom_pane",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "bottom",
          height = 0.5
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-a>"] = fb_actions.create,
            ["<C-r>"] = fb_actions.rename,
            ["<C-m>"] = fb_actions.move,
            -- Trash files instead of deleting them
            ["∂"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local fb_utils = require("telescope._extensions.file_browser.utils")
              -- Get the finder
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local finder = current_picker.finder
              -- Get the selections
              local selections = fb_utils.get_selected_files(prompt_bufnr, false)
              if vim.tbl_isempty(selections) then
                fb_utils.notify("actions.trash",
                  { msg = "No selection to be trashed!", level = "WARN", quiet = finder.quiet })
                return
              end

              -- Trash the selected files
              local trashed = {}
              for _, selection in ipairs(selections) do
                local filename = selection.filename:sub(#selection:parent().filename + 2)

                vim.fn.jobstart("mv " .. vim.fn.fnameescape(selection.filename) .. " ~/.Trash", {
                  detach = true,
                  on_exit = function()
                    -- vim.notify(" " .. filename .. " moved to Bin!", "Warn")
                    table.insert(trashed, filename)
                  end,
                })
              end
              -- Notify about operations
              local message = ""
              if not vim.tbl_isempty(trashed) then
                message = message .. "Trashed: " .. table.concat(trashed, ", ")
              end
              fb_utils.notify("actions.trash", { msg = message, level = "INFO", quiet = finder.quiet })
              -- Reset multi selection
              current_picker:refresh(current_picker.finder, { reset_prompt = true })
            end,
          },
          n = {
            m = fb_actions.move,
            a = fb_actions.create,
            -- Trash files instead of deleting them
            D = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local fb_utils = require("telescope._extensions.file_browser.utils")
              -- Get the finder
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local finder = current_picker.finder
              -- Get the selections
              local selections = fb_utils.get_selected_files(prompt_bufnr, false)
              if vim.tbl_isempty(selections) then
                fb_utils.notify("actions.trash",
                  { msg = "No selection to be trashed!", level = "WARN", quiet = finder.quiet })
                return
              end


              -- Trash the selected files
              local trashed = {}
              for _, selection in ipairs(selections) do
                local filename = selection.filename:sub(#selection:parent().filename + 2)
                -- `trash-put` is from the `trash-cli` package
                vim.fn.jobstart("mv " .. vim.fn.fnameescape(selection) .. " ~/.Trash", {
                  detach = true,
                  on_exit = function()
                    -- vim.notify(" " .. filename .. " moved to Bin!", "Warn")
                    table.insert(trashed, filename)
                  end,
                })
              end
              -- Notify about operations
              local message = ""
              if not vim.tbl_isempty(trashed) then
                message = message .. "Trashed: " .. table.concat(trashed, ", ")
              end
              fb_utils.notify("actions.trash", { msg = message, level = "INFO", quiet = finder.quiet })
              -- Reset multi selection
              current_picker:refresh(current_picker.finder, { reset_prompt = true })
            end,
          },
        },
      },
      ["ui-select"] = {
        theme = "cursor",
        layout_strategy = "vertical",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
          width = 0.7,
          height = 0.4
        },
      },
      project = {
        base_dirs = {
          "~/Documents/Developer",
          "~/dev",
          "~/uni/",
          "~/Informatica/Anno2/Semestre1/Programmazione II",
          "~/Informatica/Anno3/Semestre1/Ingegneria del Software/Laboratorio",
        },
        hidden_files = true, -- default: false
        theme = "dropdown"
      },
      -- dap = {}
      undo = {
        use_delta = false,
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = { preview_height = 0.8, },
      }
    }
  }

  telescope.load_extension "file_browser"
  telescope.load_extension "ui-select"

  -- Keymaps
  local telescope_builtin = require "telescope.builtin"

  vim.keymap.set("n", "<leader>fC", function()
    telescope_builtin.colorscheme()
  end, { desc = "Colorscheme" })
  vim.keymap.set("n", "<leader>fe", function()
    telescope.extensions.env.env()
  end, { desc = "Environment" })
  vim.keymap.set("n", "<leader>fE", function()
    telescope.extensions.emoji.emoji {
      theme = "cursor",
      initial_mode = "insert",
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "bottom",
        vertical = { width = 0.5, height = 0.5 }
      },
    }
  end, { desc = "Emoji" })
  vim.keymap.set("n", "<leader>fL", function()
    telescope.extensions.luasnip.luasnip {}
  end, { desc = "Luasnip" })
  vim.keymap.set("n", "<leader>fs", function()
    telescope_builtin.grep_string { theme = "dropdown", previewer = false }
  end, { desc = "Grep string under cursor" })
  vim.keymap.set("n", "<leader>fu", function()
    telescope.extensions.undo.undo { theme = "dropdown", previewer = true }
  end, { desc = "Undo" })

  vim.keymap.set("n", "<leader>go", function()
    telescope_builtin.git_status()
  end, { desc = "Open changed file" })
  vim.keymap.set("n", "<leader>gb", function()
    telescope_builtin.git_branches{}
  end, { desc = "Checkout branch" })
  vim.keymap.set("n", "<leader>gc", function()
    telescope_builtin.git_commits()
  end, { desc = "Checkout commit" })
  vim.keymap.set("n", "<leader>ld", function()
    telescope_builtin.diagnostics()
  end, { desc = "Lsp Diagnostics" })
  vim.keymap.set("n", "<leader>lr", function()
    telescope_builtin.lsp_references()
  end, { desc = "Lsp References" })
  vim.keymap.set("n", "<leader>lD", function()
    telescope_builtin.lsp_type_definitions {}
  end, { desc = "Lsp Type Definitions" })
  vim.keymap.set("n", "<leader>li", function()
    telescope_builtin.lsp_incoming_calls {}
  end, { desc = "Lsp InCalls" })
  vim.keymap.set("n", "<leader>lo", function()
    telescope_builtin.lsp_outgoing_calls {}
  end, { desc = "Lsp OutCalls" })
  vim.keymap.set("n", "<leader>ls", function()
    telescope_builtin.lsp_document_symbols()
  end, { desc = "Document Symbols" })
  vim.keymap.set("n", "<leader>lS", function()
    telescope_builtin.lsp_dynamic_workspace_symbols()
  end, { desc = "Workspace Symbols" })
end

return M
