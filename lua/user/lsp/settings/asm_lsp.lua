-------------------------------------
-- File         : asm_lsp.lua
-- Description  : asm_lsp server config
-- Author       : Kevin
-- Last Modified: 13/05/2022 - 10:27
-------------------------------------

local asm_root_path = vim.fn.stdpath "data".."/lsp_servers/asm_lsp"
local asm_binary = asm_root_path.."/bin/asm-lsp"

return {
  cmd = { asm_binary },
  filetypes = { "asm", "vmasm", "s", "S" },
	autostart = true,
}

