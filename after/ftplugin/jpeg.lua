local buf = vim.api.nvim_get_current_buf()
local source = vim.api.nvim_buf_get_name(buf)
local image = require("hologram.image"):new(source, {})
image:display(1, 1, buf, {})
