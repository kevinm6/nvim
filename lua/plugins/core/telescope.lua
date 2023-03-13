---------------------------------------
-- File         : telescope.lua
-- Description  : Telescope config
-- Author       : Kevin
-- Last Modified: 15 Mar 2023, 16:06
---------------------------------------

local M = {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-project.nvim",
    "benfowler/telescope-luasnip.nvim",
    "LinArcX/telescope-env.nvim",
    "xiyaowong/telescope-emoji.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>e", function() require "telescope".extensions.file_browser.file_browser() end, desc = "File Browser" },
    { "<leader>b", function() require "telescope.builtin".buffers() end, desc = "Buffers" },
    { "<leader>ff", function() require "telescope.builtin".find_files() end, desc = "Find Files" },
    { "<leader>fF", function() require "telescope.builtin".live_grep() end, desc = "Find Text (LiveGrep)" },
    { "<leader>fo", function() require "telescope.builtin".builtin() end, desc = "Open Telescope" },
    { "<leader>fH", function() require "telescope.builtin".help_tags() end, desc = "Help" },
    { "<leader>fg", function() require "telescope.builtin".git_files() end, desc = "Git Files" },
    { "<leader>fp", function() require "telescope".extensions.project.project() end, desc = "Projects" },
    { "<leader>fr", function() require "telescope.builtin".oldfiles() end, desc = "Recent File" },
    { "<leader>fR", function() require "telescope.builtin".registers() end, desc = "Registers" },
    { "<leader>fk", function() require "telescope.builtin".keymaps() end, desc = "Keymaps" },
    { "<leader>fl", function() require "telescope.builtin".resume() end, desc = "Resume last" },
    { "<leader>fC", function() require "telescope.builtin".colorscheme() end, desc = "Colorscheme" },
    { "<leader>fe", function() require "telescope".extensions.env.env() end, desc = "Environment" },
    { "<leader>fO", function() require "util.functions".software_licenses().licenses() end, desc = "Software Licenses" },
    { "<leader>fE", function() require "telescope".extensions.emoji.emoji {
      theme = "cursor", initial_mode = "insert",
      layout_strategy = "cursor",
      layout_config = {
        height = 0.4,
        width = 0.5
      }
    }
    end, desc = "Emoji" },

    { "<leader>fb", function() require "telescope".extensions.file_browser.file_browser { cwd = vim.fn.getcwd() } end, desc = "File Browser (CWD)" },
    { "<leader>fL", function() require "telescope".extensions.luasnip.luasnip{} end, desc = "Luasnip" },
    { "<leader>fs", function() require "telescope.builtin".grep_string { theme = "dropdown", previewer = false } end, desc = "Grep string under cursor" },

    { "<leader>go", function() require "telescope.builtin".git_status{} end, desc = "Git status" },
    { "<leader>gb", function() require "telescope.builtin".git_branches{} end, desc = "Checkout branch" },
    { "<leader>gc", function() require "telescope.builtin".git_commits {} end, desc = "Checkout commit" },
    { "<leader>lD", function() require "telescope.builtin".diagnostics { bufnr = 0 } end, desc = "Lsp Diagnostics" },
    { "<leader>lr", function() require "telescope.builtin".lsp_references {} end, desc = "Lsp References" },
    { "<leader>ld", function() require "telescope.builtin".lsp_definitions{} end, desc = "Lsp Definitions" },
    { "<leader>lt", function() require "telescope.builtin".lsp_type_definitions{} end, desc = "Lsp Type Definitions" },
    { "<leader>li", function() require "telescope.builtin".lsp_incoming_calls{} end, desc = "Lsp InCalls" },
    { "<leader>lo", function() require "telescope.builtin".lsp_outgoing_calls{} end, desc = "Lsp OutCalls" },
    { "<leader>ls", function() require "telescope.builtin".lsp_document_symbols{} end, desc = "Document Symbols" },
    { "<leader>lS", function() require "telescope.builtin".lsp_dynamic_workspace_symbols{} end, desc = "Workspace Symbols" },
  }
}

-- Do Not show binary
-- local new_maker = function(filepath, bufnr, opts)
--   filepath = vim.fn.expand(filepath)
--   require "plenary.job":new({
--     command = "file",
--     args = { "--mime-type", "-b", filepath },
--     on_exit = function(j)
--       local mime_type = vim.split(j:result()[1], "/")[1]
--       -- if mime_type == "text" then
--         require "telescope.previewers".buffer_previewer_maker(filepath, bufnr, opts)
--       -- else
--       --   vim.schedule(function()
--       --     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {  mime_type .. " FILE" })
--       --   end)
--       -- end
--     end
--   }):sync()
-- end



function M.config()
  local telescope = require "telescope"
  local icons = require "util.icons"

  local actions = require "telescope.actions"
  local action_layout = require "telescope.actions.layout"
  local fb_actions = require "telescope".extensions.file_browser.actions
  local action_state = require "telescope.actions.state"

  telescope.setup {
    defaults = {
      preview = {
        hide_on_startup = true,
        -- mime_hook = function(filepath, bufnr, opts)
        --   local is_image = function(filepath)
        --     local image_extensions = {'png','jpg'}   -- Supported image formats
        --     local split_path = vim.split(filepath:lower(), '.', {plain=true})
        --     local extension = split_path[#split_path]
        --     return vim.tbl_contains(image_extensions, extension)
        --   end
        --   if is_image(filepath) then
        --     local term = vim.api.nvim_open_term(bufnr, {})
        --     local function send_output(_, data, _ )
        --       for _, d in ipairs(data) do
        --         vim.api.nvim_chan_send(term, d..'\r\n')
        --       end
        --     end
        --     vim.fn.jobstart(
        --       {
        --         'tiv', filepath  -- Terminal image viewer command
        --       },
        --       {on_stdout=send_output, stdout_buffered=true, pty=true})
        --   else
        --     require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
        --   end
        -- end
      },
      -- buffer_previewer_maker = new_maker,
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
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",

          ["<esc>"] = "close",
          ["<C-u>"] = false,
          ["<C-e>"] = { "<esc>", type = "command" },

          ["<Down>"] = "move_selection_next",
          ["<Up>"] = "move_selection_previous",

          ["<CR>"] = function(pb)
            local picker = action_state.get_current_picker(pb)
            local multi = picker:get_multi_selection()
            actions.select_default(pb) -- the normal enter behaviour
            for _, j in pairs(multi) do
              if j.path ~= nil then -- is it a file -> open it as well:
                vim.cmd(string.format("%s %s", "edit", j.path))
              end
            end
          end,
          ["<C-l>"] = "select_default",
          ["<C-s>"] = "select_horizontal",
          ["<C-v>"] = "select_vertical",
          ["<C-t>"] = "select_tab",

          ["<C-p>"] = "preview_scrolling_up",
          ["<C-n>"] = "preview_scrolling_down",

          ["<PageUp>"] = "results_scrolling_up",
          ["<PageDown>"] = "results_scrolling_down",

          -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["„"] = false,

          ["<C-y>"] = action_layout.toggle_preview,

          -- ["<C-g>"] = fb_actions.goto_parent_dir,

          ["?"] = "which_key",
        },

        n = {
          ["<esc>"] = "close",
          ["q"] = "close",
          ["<CR>"] = "select_default",
          ["<C-s>"] = "select_horizontal",
          ["<C-v>"] = "select_vertical",
          ["<C-t>"] = "select_tab",
          ["<C-c>"] = "close",

          -- ["<Tab>"] = "toggle_selection + actions.move_selection_worse"",
          -- ["<S-Tab>"] = "toggle_selection + actions.move_selection_better"",
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["„"] = false,

          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-l>"] = "select_default",
          ["j"] = "move_selection_next",
          ["k"] = "move_selection_previous",
          ["l"] = "select_default",
          ["H"] = "move_to_top",
          ["M"] = "move_to_middle",
          ["L"] = "move_to_bottom",
          ["g"] = false, -- disable map
          ["h"] = false, -- disable map

          ["<Down>"] = "move_selection_next",
          ["<Up>"] = "move_selection_previous",

          ["<C-p>"] = "preview_scrolling_up",
          ["<C-n>"] = "preview_scrolling_down",

          ["<PageUp>"] = "results_scrolling_up",
          ["<PageDown>"] = "results_scrolling_down",

          ["<C-y>"] = action_layout.toggle_preview,

          ["cd"] = function(prompt_bufnr) -- cd to dir in normal mode
            local selection = action_state.get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            actions.close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent tcd %s", dir))
          end,

          ["?"] = "which_key",
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
          height = 0.4
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
        initial_mode = "insert",
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
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "bottom",
          height = 0.8,
          width = 0.6
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
      git_files = {
        theme = "dropdown",
        previewer = false,
        cwd_only = false,
        initial_mode = "insert",
        sorting_strategy = "descending",
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "bottom",
          height = 0.8,
          width = 0.6
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
        sorting_strategy = "descending",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          width = 0.4,
          height = 0.3
        },
      },
      diagnostics = {
        bufnr = 0,
        theme = "dropdown",
        initial_mode = "normal",
        sorting_strategy = "descending",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.6, height = 0.6 }
        },
      },
      lsp_references = {
        theme = "cursor",
        initial_mode = "normal",
        layout_strategy = "cursor",
        sorting_strategy = "ascending",
      },
      lsp_definitions = {
        theme = "cursor",
        initial_mode = "normal",
        layout_strategy = "cursor",
        sorting_strategy = "ascending",
      },
      lsp_type_definitions = {
        theme = "cursor",
        initial_mode = "normal",
        layout_strategy = "cursor",
        sorting_strategy = "ascending",
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
        theme = "dropdown",
        initial_mode = "normal",
        layout_strategy = "center",
        layout_config = {
          prompt_position = "bottom",
          vertical = { width = 0.7, height = 0.5 }
        },
      },
      keymaps = {
        theme = "dropdown",
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
        hidden = false,
        git_status = true,
        color_devicons = true,
        use_less = true,
        layout_config = {
          prompt_position = "bottom",
          height = 0.5
        },
        -- on_input_filter_cb = function(prompt)
        --   if prompt:sub(-1, -1) == os_sep then
        --     local prompt_bufnr = vim.api.nvim_get_current_buf()
        --     if vim.bo[prompt_bufnr].filetype == "TelescopePrompt" then
        --       local current_picker = action_state.get_current_picker(prompt_bufnr)
        --       if current_picker.finder.files then
        --         fb_actions.toggle_browser(prompt_bufnr, { reset_prompt = true })
        --         current_picker:set_prompt(prompt:sub(1, -2))
        --       end
        --     end
        --   end
        -- end,
        mappings = {
          i = {
            ["<C-b>"] = fb_actions.goto_home_dir,
            ["<C-g>"] = fb_actions.goto_cwd,
            ["<C-h>"] = fb_actions.goto_parent_dir,
            ["<C-.>"] = fb_actions.toggle_hidden,
            ["<C-x>"] = fb_actions.change_cwd,
            ["<C-a>"] = fb_actions.toggle_all,
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-c>"] = fb_actions.create,
            ["<C-r>"] = fb_actions.rename,
            ["<C-m>"] = fb_actions.move,
            ["<C-d>"] = fb_actions.remove,
            -- Trash files instead of deleting them
            ["∂"] = function(prompt_bufnr)
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
            b = fb_actions.goto_home_dir,
            g = fb_actions.goto_cwd,
            h = fb_actions.goto_parent_dir,
            x = fb_actions.change_cwd,
            ["."] = fb_actions.toggle_hidden,
            a = fb_actions.toggle_all,
            j = "move_selection_next",
            k = "move_selection_previous",
            c = fb_actions.create,
            r = fb_actions.rename,
            m = fb_actions.move,
            d = fb_actions.remove,
            -- Trash files instead of deleting them
            D = function(prompt_bufnr)
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
        theme = "dropdown",
        layout_strategy = "center",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
          width = 0.5,
          height = 0.5
        },
      },
      project = {
        theme = "dropdown",
        hidden_files = true, -- default: false
        base_dirs = {
          "~/Documents/Developer",
          "~/dev",
          "~/uni/",
          "~/Informatica/Anno2/Semestre1/Programmazione II",
          "~/Informatica/Anno3/Semestre1/Ingegneria del Software/Laboratorio",
        },
      },
      emoji = {
        theme = "cursor",
        initial_mode = "insert",
        layout_strategy = "cursor",
        layout_config = {
          height = 0.4,
          width = 0.5
        }
      }
    }
  }

  telescope.load_extension "file_browser"
  telescope.load_extension "ui-select"
end

return M
