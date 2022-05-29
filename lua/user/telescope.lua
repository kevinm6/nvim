-------------------------------------
-- File         : telescope.lua
-- Description  : Telescope config
-- Author       : Kevin
-- Last Modified: 24/05/2022, 09:11
-------------------------------------


local ok, telescope = pcall(require, "telescope")
if not ok then return end

local icons = require "user.icons"

local actions = require "telescope.actions"

telescope.load_extension "fzf"
telescope.load_extension "media_files"
telescope.load_extension "packer"
telescope.load_extension "project"
telescope.load_extension "ui-select"
telescope.load_extension "file_browser"
telescope.load_extension "notify"

telescope.setup {
  defaults = {
    prompt_prefix = icons.ui.Telescope .. "  ",
    selection_caret = "  ",
    path_display = { "smart" },

    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,
        ["<esc>"] = actions.close,
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

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-w>"] = actions.which_key, -- keys from pressing <C-/>
        ["?"] = actions.which_key,
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["l"] = actions.select_default,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-p>"] = actions.preview_scrolling_up,
        ["<C-n>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

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
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = { "png", "mp4", "pdf", "webp", "jpg", "jpeg" },
      find_cmd = "rg", -- find command (defaults to `fd`)
    },
		fzf = {
			fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
		},
		["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    },
		packer = {
			theme = "k_theme",
			layout_config = {
				height = .5
			}
		},
      auto_replace_desc_with_cmd = false,
    },
}

