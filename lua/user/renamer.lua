-------------------------------------
-- File         : renamer.lua
-- Description  : Renamer config
-- Author       : Kevin
-- Last Modified: 12/03/2022 - 17:31
-------------------------------------

-- BUG : Broken after updating NeoVim to 0.7 -> using lsp built-in for now

local ok, renamer = pcall(require, "renamer")
if not ok then return end

vim.keymap.set(
	"i",
	"<F4>",
	'<cmd>lua require("renamer").rename({empty = true})<cr>',
	{ noremap = true, silent = true }
)

vim.keymap.set(
	"n",
	"<F4>",
	'<cmd>lua require("renamer").rename({empty = true})<cr>',
	{ noremap = true, silent = true }
)

local mappings_utils = require "renamer.mappings.utils"
renamer.setup({
	-- The popup title, shown if `border` is true
	title = "Rename",
	-- The padding around the popup content
	padding = {
		top = 0,
		left = 0,
		bottom = 0,
		right = 0,
	},
	-- Whether or not to shown a border around the popup
	border = true,
	-- The characters which make up the border
	border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	-- Whether or not to highlight the current word references through LSP
  show_refs = true,
  -- Whether or not to add resulting changes to the quickfix list
  with_qf_list = true,
  -- Whether or not to enter the new name through the UI or Neovim's `input`
  -- prompt
  with_popup = true,
  -- The keymaps available while in the `renamer` buffer. The example below
  -- overrides the default values, but you can add others as well.
   -- The minimum width of the popup
    min_width = 14,
    -- The maximum width of the popup
    max_width = 46,
	mappings = {
		["<c-i>"] = mappings_utils.set_cursor_to_start,
		["<c-a>"] = mappings_utils.set_cursor_to_end,
		["<c-e>"] = mappings_utils.set_cursor_to_word_end,
		["<c-b>"] = mappings_utils.set_cursor_to_word_start,
		["<c-c>"] = mappings_utils.clear_line,
		["<c-u>"] = mappings_utils.undo,
		["<c-r>"] = mappings_utils.redo,
	},
  handler = nil,
})
