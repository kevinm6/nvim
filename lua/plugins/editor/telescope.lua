---------------------------------------
-- File         : telescope.lua
-- Description  : Telescope config
-- Author       : Kevin
-- Last Modified: 03 Dec 2023, 10:48
---------------------------------------


local function git_hunks()
   require("telescope.pickers")
       .new({
          finder = require("telescope.finders").new_oneshot_job(
             { "git", "jump", "--stdout", "diff" },
             {
                entry_maker = function(line)
                   local filename, lnum_string = line:match "([^:]+):(%d+).*"

                   -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
                   -- return nil if filename is /dev/null because this means the file was deleted.
                   if filename:match "^/dev/null" then
                      return nil
                   end

                   return {
                      value = filename,
                      display = line,
                      ordinal = line,
                      filename = filename,
                      lnum = tonumber(lnum_string),
                   }
                end,
             }
          ),
          sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
          previewer = require("telescope.config").values.grep_previewer {},
          results_title = "Git hunks",
          prompt_title = "Git hunks",
          layout_strategy = "flex",
       }, {})
       :find()
end


local select_one_or_multi = function(prompt_bufnr, action)
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
      if action == 'edit' then
         require('telescope.actions').select_default(prompt_bufnr)
      elseif action == 'sp' then
         require('telescope.actions').select_horizontal(prompt_bufnr)
      elseif action == 'vsp' then
         require('telescope.actions').select_vertical(prompt_bufnr)
      elseif action == 'tabe' then
         require('telescope.actions').select_tab(prompt_bufnr)
      end
   end
end


local function filenameFirst(_, path)
   local tail = vim.fs.basename(path)
   local parent = vim.fs.dirname(path)
   if parent == "." then return tail end
   return string.format("%s\t\t%s", tail, parent)
end

local M = {
   {
      "nvim-telescope/telescope.nvim",
      cmd = { "Telescope" },
      dependencies = {
         "nvim-lua/plenary.nvim",
         {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make"
         },
         "benfowler/telescope-luasnip.nvim",
         "LinArcX/telescope-env.nvim",
         "nvim-telescope/telescope-ui-select.nvim",
         -- "nvim-telescope/telescope-file-browser.nvim",
      },
      keys = {
         {
            "<leader>b",
            function()
               require("telescope.builtin").buffers()
            end,
            desc = "Buffers",
         },
         { "<leader>f", nil, desc = "Telescope", },
      },
      opts = function(_, o)
         local icons = require "lib.icons"

         local actions = require "telescope.actions"
         local action_layout = require "telescope.actions.layout"
         -- local fb_actions = require("telescope").extensions.file_browser.actions
         local action_state = require "telescope.actions.state"

         o.defaults = {
            preview = { hide_on_startup = true },
            initial_mode = "insert",
            prompt_prefix = icons.ui.Telescope .. "  ",
            selection_caret = "> ",
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

                  ["<C-p>"] = "preview_scrolling_up",
                  ["<C-n>"] = "preview_scrolling_down",

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
         }

         o.pickers = {
            find_files = {
               theme = "dropdown",
               previewer = false,
               sorting_strategy = "descending",
               layout_strategy = "center",
               layout_config = {
                  prompt_position = "bottom",
                  height = 0.4,
               },
               cwd = require("lspconfig.util").find_git_ancestor(vim.fn.expand "%:p:h")
                   or vim.fn.expand "%:p:h",
               no_ignore = true,
               path_display = filenameFirst,
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
                     end,
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
                     end,
                  },
               },
            },
            buffers = {
               theme = "dropdown",
               sort_mru = true,
               ignore_current_buffer = true,
               previewer = false,
               initial_mode = "insert",
               sorting_strategy = "descending",
               path_display = filenameFirst,
               layout_config = {
                  prompt_position = "bottom",
               },
               mappings = {
                  i = {
                     ["<C-x>"] = "delete_buffer",
                  },
                  n = {
                     ["x"] = "delete_buffer",
                  },
               },
            },
            oldfiles = {
               previewer = false,
               cwd_only = false,
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
               },
            },
            live_grep = {
               initial_mode = "insert",
               sorting_strategy = "descending",
               layout_strategy = "bottom_pane",
               path_display = filenameFirst,
               debounce = 400,
               layout_config = {
                  prompt_position = "bottom",
                  height = 0.7,
               },
            },
            git_files = {
               previewer = false,
               cwd_only = false,
               initial_mode = "insert",
               sorting_strategy = "descending",
               layout_strategy = "vertical",
               path_display = filenameFirst,
               layout_config = {
                  prompt_position = "bottom",
                  height = 0.8,
                  width = 0.6,
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
                  vertical = { width = 0.6, height = 0.4 },
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
                  width = 0.6,
                  height = 0.4,
               },
            },
            commands = {
               theme = "dropdown",
               previewer = false,
               initial_mode = "normal",
               sorting_strategy = "descending",
               layout_strategy = "vertical",
               layout_config = {
                  prompt_position = "bottom",
                  width = 0.6,
                  height = 0.4,
               },
            },
            diagnostics = {
               bufnr = 0,
               previewer = true,
               initial_mode = "normal",
               sorting_strategy = "descending",
               layout_strategy = "vertical",
               layout_config = {
                  prompt_position = "bottom",
                  vertical = { width = 0.6, height = 0.6 },
               },
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
               },
            },
            lsp_type_definitions = {
               previewer = true,
               initial_mode = "normal",
               layout_strategy = "vertical",
               sorting_strategy = "descending",
               layout_config = {
                  vertical = { width = 0.7, height = 0.6 },
               },
            },
            lsp_declarations = {
               previewer = true,
               initial_mode = "normal",
               layout_strategy = "vertical",
               sorting_strategy = "descending",
               layout_config = {
                  vertical = { width = 0.7, height = 0.6 },
               },
            },
            lsp_implementations = {
               previewer = true,
               initial_mode = "normal",
               layout_strategy = "vertical",
               sorting_strategy = "descending",
               layout_config = {
                  vertical = { width = 0.7, height = 0.6 },
               },
            },
            lsp_document_symbols = {
               previewer = true,
               initial_mode = "insert",
               layout_strategy = "vertical",
               sorting_strategy = "descending",
               layout_config = {
                  vertical = { width = 0.7, height = 0.6 },
               },
            },
            lsp_dynamic_workspace_symbols = {
               previewer = true,
               initial_mode = "insert",
               layout_strategy = "vertical",
               sorting_strategy = "descending",
               layout_config = {
                  vertical = { width = 0.7, height = 0.6 },
               },
            },
            registers = {
               theme = "dropdown",
               initial_mode = "normal",
               layout_strategy = "center",
               layout_config = {
                  prompt_position = "bottom",
                  vertical = { width = 0.7, height = 0.5 },
               },
            },
            keymaps = {
               theme = "dropdown",
               previewer = false,
               initial_mode = "insert",
               layout_strategy = "center",
               layout_config = {
                  prompt_position = "bottom",
                  vertical = { width = 0.8, height = 0.6 },
               },
            },
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

         telescope.load_extension "fzf"
         telescope.load_extension "ui-select"
         -- telescope.load_extension "file_browser"

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

         vim.keymap.set("n",
            "<leader>fF",
            function()
               tele_builtin.live_grep()
            end,
            { desc = "Find Text (LiveGrep)" }
         )
         vim.keymap.set("n",
            "<leader>fH",
            function()
               local cword = vim.fn.expand "<cword>"
               tele_builtin.help_tags({ default_text = cword })
            end,
            { desc = "Help" }
         )
         vim.keymap.set("n",
            "<leader>fg",
            function()
               tele_builtin.git_files()
            end,
            { desc = "Git Files" }
         )
         -- vim.keymap.set("n",
         --    "<leader>fp",
         --    function()
         --       telescope.extensions.project.project()
         --    end,
         --    { desc = "Projects" }
         -- )
         vim.keymap.set("n",
            "<leader>fR",
            function()
               tele_builtin.registers()
            end,
            { desc = "Registers" }
         )
         vim.keymap.set("n",
            "<leader>fq",
            function()
               tele_builtin.quickfix()
            end,
            { desc = "QuickFix" }
         )
         vim.keymap.set("n",
            "<leader>fQ",
            function()
               tele_builtin.loclist()
            end,
            { desc = "LocationList" }
         )
         vim.keymap.set("n",
            "<leader>fl",
            function()
               tele_builtin.resume()
            end,
            { desc = "Resume last" }
         )
         vim.keymap.set("n",
            "<leader>fc",
            function()
               tele_builtin.current_buffer_fuzzy_find()
            end,
            { desc = "Line fuzzy" }
         )
         vim.keymap.set("n",
            "<leader>fC",
            function()
               tele_builtin.commands()
            end,
            { desc = "Colorscheme" }
         )
         vim.keymap.set("n",
            "<leader>fe",
            function()
               telescope.extensions.env.env()
            end,
            { desc = "Environment" }
         )
         vim.keymap.set("n",
            "<leader>fO",
            function()
               require("lib.software_licenses").pick_license()
            end,
            { desc = "Software Licenses" }
         )
         -- vim.keymap.set("n",
         --    "<leader>fE",
         --    function()
         --       telescope.extensions.emoji.emoji {
         --          theme = "cursor",
         --          initial_mode = "insert",
         --          layout_strategy = "cursor",
         --          layout_config = {
         --             height = 0.4,
         --             width = 0.5,
         --          },
         --       }
         --    end,
         --    { desc = "Emoji" }
         -- )

         -- vim.keymap.set("n",
         --    "<leader>fb",
         --    function()
         --       telescope.extensions.file_browser.file_browser {
         --          cwd = vim.fn.getcwd(),
         --       }
         --    end,
         --    { desc = "File Browser (CWD)" }
         -- )
         vim.keymap.set("n",
            "<leader>fs",
            function()
               tele_builtin.grep_string {
                  theme = "dropdown",
                  previewer = false,
               }
            end,
            { desc = "Grep < cword >" }
         )

         vim.keymap.set("n",
            "<leader>ff",
            function()
               require("telescope.builtin").find_files()
            end,
            { desc = "Find Files" }
         )
         vim.keymap.set("n",
            "<leader>fo",
            function()
               require("telescope.builtin").builtin()
            end,
            { desc = "Open Telescope" }
         )
         vim.keymap.set("n",
            "<leader>fr",
            function()
               require("telescope.builtin").oldfiles()
            end,
            { desc = "Recent File" }
         )

         -- vim.keymap.set("n",
         --    "<leader>fU",
         --    function()
         --       telescope.extensions.file_browser.file_browser {
         --          cwd = "~/Informatica/",
         --       }
         --    end,
         --    { desc = "University Folder" }
         -- )

         vim.keymap.set("n",
            "<leader>gs",
            function()
               tele_builtin.git_status()
            end,
            { desc = "Git status" }
         )
         vim.keymap.set("n",
            "<leader>gb",
            function()
               tele_builtin.git_branches()
            end,
            { desc = "Checkout branch" }
         )
         vim.keymap.set("n",
            "<leader>gc",
            function()
               tele_builtin.git_commits()
            end,
            { desc = "Checkout commit" }
         )
         vim.keymap.set("n",
            "<leader>gh",
            function()
               git_hunks()
            end,
            { desc = "Git Hunks" }
         )

         vim.keymap.set("n",
            "<leader>lD",
            function()
               tele_builtin.diagnostics { bufnr = 0 }
            end,
            { desc = "Lsp Diagnostics" }
         )
      end
   },
}

return M