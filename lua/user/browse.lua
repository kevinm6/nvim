-----------------------------------
--  File         : browse.lua
--  Description  : browse plugin conf
--  Author       : Kevin
--  Last Modified: 03 Jul 2022, 10:12
-----------------------------------

local ok, browse = pcall(require, "browse")
if not ok then return end


local bookmarks = {
  "https://github.com/neovim/neovim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/nvim-lsp-installer",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/kevinm6/nvim",
  "https://github.com/rockerBOO/awesome-neovim",
  "https://neovim.discourse.group/",
}

local custom_keymaps = {
  -- Packer
  B = {
    name = "Browse",
    B = {
      function() browse.open_bookmarks({ bookmarks = bookmarks }) end,
      "Bookmarks"
    },
    c = { function()
      browse.input_search()
    end, "Input search" },
    b = { function()
      browse.browse({ bookmarks = bookmarks })
    end, "Browse" },
    d = { function()
      browse.devdocs.search()
    end, "DevDocs" },
    D = { function() browse.devdocs.search_with_filetype() end,
      "DevDocs + Filetype"
    },
    m = { function()
      browse.mdn.search()
      end,
      "Mdn Search"
    }
  },
}

require("which-key").register(custom_keymaps, { prefix = "<leader>", silent = false })

vim.api.nvim_create_user_command("Browse", function()
  browse.browse { bookmarks = bookmarks }
end, {})

