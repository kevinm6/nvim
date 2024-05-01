---------------------------------------
-- File         : telescope.lua
-- Description  : Telescope config
-- Author       : Kevin
-- Last Modified: 08 May 2024, 11:59
---------------------------------------

local function select_one_or_multi(prompt_bufnr, action)
  local tele_actions = require "telescope.actions"
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require('telescope.actions').close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", action, j.path))
      end
    end
  else
    local action_map = {
      edit = tele_actions.select_default,
      sp = tele_actions.select_horizontal,
      vsp = tele_actions.select_vertical,
      tabe = tele_actions.select_tab
    }
    if not action_map[action] then
      vim.notify("action passed not found: " .. action)
      return
    end

    action_map[action](prompt_bufnr)
  end
end

return {
  ---Telescope
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    opts = function(_, o)
      local icons = require "lib.icons"

      local actions = require "telescope.actions"
      local action_layout = require "telescope.actions.layout"
      local action_state = require "telescope.actions.state"

      o.defaults = {
        preview = { hide_on_startup = true },
        initial_mode = "insert",
        prompt_prefix = icons.ui.Telescope .. "  ",
        selection_caret = "❭ ",
        entry_prefix = "   ",
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

            ["<CR>"] = function(pb) select_one_or_multi(pb, 'edit') end,
            ["<C-l>"] = function(pb) select_one_or_multi(pb, 'edit') end,
            ["<C-s>"] = function(pb) select_one_or_multi(pb, 'sp') end,
            ["<C-v>"] = function(pb) select_one_or_multi(pb, 'vsp') end,
            ["<C-t>"] = function(pb) select_one_or_multi(pb, 'tabe') end,

            ["<C-b>"] = "preview_scrolling_up",
            ["<C-f>"] = "preview_scrolling_down",

            ["<PageUp>"] = "results_scrolling_up",
            ["<PageDown>"] = "results_scrolling_down",

            ["<C-i>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-C-i>"] = actions.toggle_selection + actions.move_selection_better,
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
            ["<CR>"] = function(pb) select_one_or_multi(pb, 'edit') end,
            ["<C-l>"] = function(pb) select_one_or_multi(pb, 'edit') end,
            ["<C-s>"] = function(pb) select_one_or_multi(pb, 'sp') end,
            ["<C-v>"] = function(pb) select_one_or_multi(pb, 'vsp') end,
            ["<C-t>"] = function(pb) select_one_or_multi(pb, 'tabe') end,
            ["<C-c>"] = "close",

            -- ["<Tab>"] = "toggle_selection + actions.move_selection_worse"",
            -- ["<S-Tab>"] = "toggle_selection + actions.move_selection_better"",
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["„"] = false,

            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",

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

            ["<C-b>"] = "preview_scrolling_up",
            ["<C-f>"] = "preview_scrolling_down",

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
          }
        }
      }

      o.pickers = {
        find_files = {
          theme = "dropdown",
          sorting_strategy = "descending",
          layout_strategy = "center",
          layout_config = {
            prompt_position = "bottom",
            height = 0.4
          },
          cwd = vim.uv.cwd(),
          no_ignore = true,
          path_display = {
            filename_first = { reverse_directories = false }
          },
          mappings = {
            n = {
              ["."] = function(prompt_bufnr)
                local current_picker =
                    require("telescope.actions.state").get_current_picker(
                      prompt_bufnr
                    )
                local opts = {
                  hidden = true,
                  default_text = current_picker:_get_prompt(),
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").find_files(opts)
              end,
              ["g"] = function(prompt_bufnr)
                local current_picker =
                    require("telescope.actions.state").get_current_picker(
                      prompt_bufnr
                    )
                local opts = {
                  default_text = current_picker:_get_prompt(),
                  cwd = vim.fn.expand "%:p:h:h",
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").resume(opts)
              end
            },
            i = {
              ["<C-.>"] = function(prompt_bufnr)
                local current_picker =
                    require("telescope.actions.state").get_current_picker(
                      prompt_bufnr
                    )
                local opts = {
                  hidden = true,
                  default_text = current_picker:_get_prompt(),
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").find_files(opts)
              end,
              ["<C-g>"] = function(prompt_bufnr)
                local current_picker =
                    require("telescope.actions.state").get_current_picker(
                      prompt_bufnr
                    )
                local opts = {
                  default_text = current_picker:_get_prompt(),
                  cwd = vim.fn.expand "%:p:h:h",
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").find_files(opts)
              end
            }
          }
        },
        buffers = {
          theme = "dropdown",
          sort_mru = true,
          ignore_current_buffer = true,
          previewer = false,
          initial_mode = "insert",
          sorting_strategy = "descending",
          path_display = {
            filename_first = { reverse_directories = false }
          },
          layout_config = {
            prompt_position = "bottom",
          },
          mappings = {
            i = {
              ["<C-x>"] = "delete_buffer",
            },
            n = {
              ["x"] = "delete_buffer",
            }
          }
        },
        oldfiles = {
          previewer = false,
          initial_mode = "insert",
          sorting_strategy = "descending",
          layout_strategy = "vertical",
          tiebreak = function(current, existing, _)
            return current.index < existing.index
          end,
          layout_config = {
            prompt_position = "bottom",
            height = 0.8,
            width = 0.6,
          }
        },
        live_grep = {
          initial_mode = "insert",
          sorting_strategy = "descending",
          layout_strategy = "bottom_pane",
          path_display = {
            filename_first = { reverse_directories = false }
          },
          debounce = 400,
          layout_config = {
            prompt_position = "bottom",
            height = 0.7,
          }
        },
        git_files = {
          -- initial_mode = "insert",
          sorting_strategy = "descending",
          layout_strategy = "vertical",
          path_display = {
            filename_first = { reverse_directories = false }
          },
          layout_config = {
            prompt_position = "bottom",
            height = 0.8,
            width = 0.6,
          }
        },
        git_status = {
          theme = "dropdown",
          -- previewer = false,
          initial_mode = "normal",
          sorting_strategy = "descending",
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "bottom",
            vertical = { width = 0.6, height = 0.4 },
          }
        },
        git_branches = {
          theme = "dropdown",
          -- previewer = false,
          initial_mode = "normal",
          sorting_strategy = "descending",
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "bottom",
            width = 0.6,
            height = 0.4,
          }
        },
        diagnostics = {
          bufnr = 0,
          previewer = true,
          sorting_strategy = "descending",
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "bottom",
            vertical = { width = 0.6, height = 0.6 },
          }
        },
        lsp_references = {
          previewer = true,
          initial_mode = "normal",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          },
        },
        lsp_definitions = {
          previewer = true,
          initial_mode = "normal",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        lsp_type_definitions = {
          previewer = true,
          initial_mode = "normal",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        lsp_declarations = {
          previewer = true,
          initial_mode = "normal",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        lsp_implementations = {
          previewer = true,
          initial_mode = "normal",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        lsp_document_symbols = {
          previewer = true,
          initial_mode = "insert",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        lsp_dynamic_workspace_symbols = {
          previewer = true,
          initial_mode = "insert",
          layout_strategy = "vertical",
          sorting_strategy = "descending",
          layout_config = {
            vertical = { width = 0.7, height = 0.6 },
          }
        },
        registers = {
          initial_mode = 'insert',
          layout_strategy = 'vertical',
          layout_config = {
            anchor = 'S',
            prompt_position = "bottom",
            vertical = { width = 0.9, height = 0.6 },
          }
        },
        keymaps = {
          initial_mode = 'insert',
          layout_strategy = 'vertical',
          layout_config = {
            anchor = 'S',
            prompt_position = "bottom",
            vertical = { width = 0.9, height = 0.4 },
          }
        },
        commands = {
          initial_mode = 'insert',
          layout_strategy = 'vertical',
          layout_config = {
            anchor = 'S',
            prompt_position = "bottom",
            vertical = { width = 0.9, height = 0.4 },
          }
        }
      }

      o.extensions = {
        ["ui-select"] = {
          theme = "dropdown",
          layout_strategy = "center",
          sorting_strategy = "descending",
          layout_config = {
            prompt_position = "bottom",
            width = 0.5,
            height = 0.5,
          },
        },
      }
    end,
    config = function(_, o)
      local telescope = require "telescope"
      telescope.setup(o)

      local tele_builtin = require "telescope.builtin"

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })

      -- Keymaps
      local function nmap(tbl)
        vim.keymap.set("n", tbl[1], tbl[2],
          { desc = require "lib.icons".ui.Telescope .. tbl[3] })
      end
      nmap { "<leader><leader>", tele_builtin.buffers, " Buffers" }

      nmap { "<leader>fF", tele_builtin.live_grep, "Find Text (LiveGrep)" }

      nmap { "<leader>fh", function()
        local cword = vim.fn.expand "<cword>"
        tele_builtin.help_tags({ default_text = cword })
      end, "Help" }

      nmap { "<leader>fg", function()
        tele_builtin.git_files()
      end, "Git Files" }
      nmap { "<leader>fR", function()
        tele_builtin.registers()
      end, "Registers" }
      nmap { "<leader>fq", tele_builtin.quickfix, "QuickFix" }
      nmap { "<leader>fQ", tele_builtin.loclist, "LocationList" }
      nmap { "<leader>fl", tele_builtin.resume, "Resume last" }
      nmap { "<leader>fk", tele_builtin.keymaps, "Keymaps" }
      nmap { "<leader>fc", tele_builtin.current_buffer_fuzzy_find, "Line fuzzy" }
      nmap { "<leader>fC", tele_builtin.commands, "Colorscheme" }
      nmap { "<leader>fe", function() require "lib.env".show_vars() end, "Environment" }
      nmap { "<leader>fO", require "lib.software_licenses".pick_license, "Software Licenses" }
      nmap { "<leader>fw", function()
        tele_builtin.grep_string {
          theme = "dropdown",
          previewer = false,
        }
      end, "Grep < cword >" }
      nmap { "<leader>fW", function()
        local word = vim.fn.expand("<cWORD>")
        tele_builtin.grep_string {
          theme = "dropdown",
          previewer = false,
          search = word
        }
      end, "Grep <cword>" }

      nmap { "<leader>ff", function()
        tele_builtin.find_files { cwd = vim.uv.cwd() }
      end, "Find Files" }
      nmap { "<leader>fo", tele_builtin.builtin,
        "Open Telescope" }
      nmap { "<leader>fr", tele_builtin.oldfiles, "Recent File" }

      nmap { "<leader>gs", tele_builtin.git_status, "Git status" }
      nmap { "<leader>gb", tele_builtin.git_branches, "Checkout branch" }
      nmap { "<leader>gc", tele_builtin.git_commits, "Checkout commit" }
    end
  },

  ---Fzf-native
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
  },

  ---UI-select
  "nvim-telescope/telescope-ui-select.nvim"
}