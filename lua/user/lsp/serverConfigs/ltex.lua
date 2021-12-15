-------------------------------------
-- File: ltex.lua
-- Description: LanguageServerProtocol K configuration
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lspconfig/sumneko_lua.lua
-- Last Modified: 15/12/21 - 11:50
-------------------------------------


local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "ltex"

configs[name] = {
    cmd = { "ltex-ls" },
      filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
      get_language_id = function(_, filetype)
            local language_id = language_id_mapping[filetype]
            if language_id then
              return language_id
            else
              return filetype
            end
          end,
      root_dir = function(path)
          -- Support git directories and git files (worktrees)
          if M.path.is_dir(M.path.join(path, '.git')) or M.path.is_file(M.path.join(path, '.git')) then
            return path
          end
      end,
      single_file_support = true
}


-- LaTex {
  -- lspconfig.ltex.setup {
  --   cmd = { "ltex-ls" },
  --     filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
  --     get_language_id = function(_, filetype)
  --           local language_id = language_id_mapping[filetype]
  --           if language_id then
  --             return language_id
  --           else
  --             return filetype
  --           end
  --         end,
  --     root_dir = function(path)
  --         -- Support git directories and git files (worktrees)
  --         if M.path.is_dir(M.path.join(path, '.git')) or M.path.is_file(M.path.join(path, '.git')) then
  --           return path
  --         end
  --     end,
  --     single_file_support = true
  -- }
-- LaTex }


