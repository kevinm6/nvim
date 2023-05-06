-------------------------------------
--  File         : gopls.lua
--  Description  : Description
--  Author       : Kevin
--  Last Modified: 06 May 2023, 19:06
-------------------------------------

return {
  root_dir = function(fname)
    local Path = require("plenary.path")

    local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
    local absolute_fname = Path:new(fname):absolute()

    if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
      return absolute_cwd
    end

    return require "lspconfig".util.root_pattern("go.mod", "go.work", ".git")(fname)
  end,
  settings = {
    gopls = {
      codelenses = {
            test = true,
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true
         },
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      -- hints = {
      --   assignVariableTypes = true,
      --   compositeLiteralFields = true,
      --   compositeLiteralTypes = true,
      --   constantValues = true,
      --   functionTypeParameters = true,
      --   parameterNames = true,
      --   rangeVariableTypes = true,
      -- }
    },
  },
  flags = {
    debounce_text_changes = 200,
  },
}
