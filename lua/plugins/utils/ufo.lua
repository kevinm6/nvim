-------------------------------------
--  File         : ufo.lua
--  Description  : ufo plugin configuration (folding)
--  Author       : Kevin
--  Last Modified: 28 Sep 2023, 07:59
-------------------------------------

local ftMap = {
   vim = "indent",
   python = { "indent" },
   git = "",
   yaml = "indent",
}

local M = {
   "kevinhwang91/nvim-ufo",
   event = { "LspAttach" },
   dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
   },
   keys = {
      { "zc" },
      { "zr", function() require "ufo".openFoldsExceptKinds() end, desc = "Folds less" },
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Folds more" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
   },
   opts = function(_, o)
      -- fold_virt_text_handler = handler,
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

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
      o.provider_selector = function(_, filetype, _)
         return ftMap[filetype]
      end
   end,
}

return M
