-------------------------------------
-- File         : markdown.lua
-- Description  : filetype markdown extra config
-- Author       : Kevin
-- Last Modified: 12 Oct 2023, 18:45
-------------------------------------

vim.opt_local.conceallevel = 2
vim.opt_local.shiftwidth = 3
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 100
vim.opt_local.foldmethod = "syntax"
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "tcoqln"
vim.opt_local.comments:append { "nb:+", "nb:>", "nb:-", "nb:." }

vim.opt.spell = false

local function conceal_as_devicon(match, _, bufnr, pred, metadata)
   if #pred == 2 then
      -- (#as_devicon! @capture)
      local capture_id = pred[2]
      local lang = vim.treesitter.get_node_text(match[capture_id], bufnr)

      local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(lang, { default = true })
      metadata["conceal"] = icon
   end
end

vim.treesitter.query.add_directive("as_devicon!", conceal_as_devicon, true)

-- add custom mappings only for markdown files
-- if plugin 'peek' is installed
local has_peek, peek = pcall(require, "peek")
if has_peek then
   vim.keymap.set("n", "<leader>mp", function()
      if peek.is_open() then
         peek.close()
      else
         peek.open()
      end
   end, { desc = "Markdown Preview [Peek]" })
else
   vim.notify("Peek is not installed or loaded!\n Can't preview markdown!", vim.log.levels.WARN)
end
