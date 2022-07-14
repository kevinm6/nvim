-------------------------------------
--	File: color_picker.lua
--	Description: color_picker plugin config
--	Author: Kevin
--	Last Modified: 28 Jun 2022, 18:09
-------------------------------------

local custom_keymaps = {
  C = {
    name = "Color Picker",
    c = { "<cmd>PickColor<cr>", "PickColor" },
    i = { "<cmd>PickColorInsert<cr>", "PickColorInsert" },
  },
}
require("which-key").register(custom_keymaps, { prefix = "<leader>", silent = true, noremap = true })

-- only need setup() if you want to change progress bar icons
require("color-picker").setup {
	-- ["icons"] = { "ﱢ", "" },
	-- ["icons"] = { "ﮊ", "" },
	-- ["icons"] = { "", "ﰕ" },
	["icons"] = { "ﱢ", "" },
	-- ["icons"] = { "", "" },
	-- ["icons"] = { "", "" },
}

-- vim.api.nvim_set_hl(0, "FloatBorder", {})
