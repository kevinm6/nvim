-------------------------------------
-- File         : python.lua
-- Description  : python config for vim
-- Author       : Kevin
-- Last Modified: 27 Dec 2022, 10:42
-------------------------------------

local M = {
  {
    "ahmedkhalf/jupyter-nvim",
    build = ":UpdateRemotePlugins",
    ft = "ipynb",
    config = {}
  },
  {
    "jupyter-vim/jupyter-vim",
    ft = "ipynb"
  },
  {
    "bfredl/nvim-ipy",
    ft = "ipy",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = { "py", "python", "ipynb" },
    config = function()
      require("dap-python").setup("~/.local/share/virtualenvs")
    end
  },
}

return M

