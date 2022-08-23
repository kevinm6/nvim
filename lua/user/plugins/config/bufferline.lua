 -------------------------------------
 -- File         : bufferline.lua
 -- Description  : Bufferline config
 -- Author       : Kevin
 -- Last Modified: 22 Aug 2022, 10:42
 -------------------------------------

local ok, bufferline = pcall(require, "bufferline")
if not ok then return end

local icons = require "user.icons"


bufferline.setup {
  options = {
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "DeleteCurrentBuffer", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "DeleteCurrentBuffer", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
    -- NOTE: this plugin is designed with this icon in mind,
    -- and so changing this is NOT recommended, this is intended
    -- as an escape hatch for people who canno bear it for whatever reason
    indicator = {
      style = 'icon',
      icon = icons.ui.AltSlArrowRight,--  "▎",
    },
    buffer_close_icon = icons.bufferline.buffer_close_icon,
    modified = icons.bufferline.modified,
    close = icons.bufferline.close,
    left_trunc_marker = icons.bufferline.left_trunc_marker,
    right_trunc_marker = icons.bufferline.right_trunc_marker,
    max_name_length = 20,
    max_prefix_length = 20,
    tab_size = 22,
    diagnostics = true,
    diagnostics_update_in_insert = false,
    offsets = {{ filetype = "NvimTree", text = "File Explorer", padding = 1, }, { filetype = "alpha", text = "Dashboard" }},
    -- offsets = {{ filetype = "neo-tree", text = "File Explorer", padding = 1, }, { filetype = "alpha", text = "Dashboard", padding = 1, }},
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = true,
    always_show_bufferline = false,
  },
  highlights = {
    fill = {
      fg = { attribute = "fg", highlight = "#ff0000" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    background = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },

		-- buffer_selected = {
		--    fg = {attribute='fg',highlight='#ff0000'},
		--    bg = {attribute='bg',highlight='#0000ff'},
		--		gui = 'none'
		-- },
    buffer_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },

    close_button = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_selected = {
      fg = { attribute = 'fg', highlight = 'Identifier' },
      -- bg = { attribute = 'bg', highlight = 'TabLine' }
		},

    tab_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    tab = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    tab_close = {
      -- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
      fg = { attribute = "fg", highlight = "Boolean" },
      bg = { attribute = "bg", highlight = "Normal" },
    },

    duplicate_selected = {
      fg = { attribute = "fg", highlight = "TabLineSel" },
      bg = { attribute = "bg", highlight = "TabLineSel" },
      italic = true,
    },
    duplicate_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
      italic = true,
    },
    duplicate = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
      italic = true,
    },

    modified = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_selected = {
      fg = { attribute = "fg", highlight = "TabLine_modified_visible" },
    },
    modified_visible = {
      fg = { attribute = "fg", highlight = "TabLine_modified_visible" },
    },

    separator = {
      fg = { attribute = "bg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    separator_selected = {
      fg = { attribute = "bg", highlight = "Normal" },
    },
    -- separator_visible = {
    --   fg = {attribute='bg',highlight='TabLine'},
    --   bg = {attribute='bg',highlight='TabLine'}
    --   },
    indicator_selected = {
      fg = { attribute = "fg", highlight = "CursorLineNr" },
    },
  },
}
