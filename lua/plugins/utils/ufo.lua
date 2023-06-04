-------------------------------------
--  File         : ufo.lua
--  Description  : ufo plugin configuration (folding)
--  Author       : Kevin
--  Last Modified: 09 Jun 2023, 17:16
-------------------------------------

local ftMap = {
   vim = "indent",
   python = { "indent" },
   git = "",
}

local M = {
   "kevinhwang91/nvim-ufo",
   event = "BufAdd",
   dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
   },
   keys = {
      { "zc" },
      { "zr" },
      { "zR" },
      { "zo" },
      { "zO" },
      { "zm" },
      { "zM" },
   },
   opts = function(_, o)
      -- fold_virt_text_handler = handler,
      vim.wo.foldcolumn = "0"
      vim.wo.foldlevel = 99
      vim.wo.foldenable = true

      o.open_fold_hl_timeout = 150
      o.preview = {
         win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Special:Folded",
            winblend = 0,
         },
         mappings = {
            scrollU = "<C-b>",
            scrollD = "<C-f>",
         },
      }
      o.close_fold_kinds = { 'imports', 'comment' }
      o.provider_selector = function(bufnr, filetype, buftype)
         return ftMap[filetype]
      end
   end,
}

return M
