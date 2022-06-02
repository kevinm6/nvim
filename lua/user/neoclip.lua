-------------------------------------
-- File         : statusline.lua
-- Description  : StatusLine config
-- Author       : Kevin Manca
-- Last Modified: 29/05/2022 - 10:37
-------------------------------------

local ok, neoclip = pcall(require, "neoclip")
if not ok then
  vim.notify("Error loading neoclip" .. neoclip, "Info")
  return
end

local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

neoclip.setup{
  history = 1000,
  enable_persistent_history = false,
  length_limit = 200,
  continuous_sync = false,
  -- db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
  filter = function(data)
    return not all(data.event.regcontents, is_whitespace)
  end,
  preview = true,
  default_register = '"',
  default_register_macros = 'q',
  enable_macro_history = true,
  content_spec_column = false,
  on_paste = {
    set_reg = false,
  },
  on_replay = {
    set_reg = false,
  },
  keys = {
    telescope = {
      i = {
        select = '<cr>',
        paste = '<c-p>',
        paste_behind = '<c-k>',
        replay = '<c-q>',  -- replay a macro
        delete = '<c-d>',  -- delete an entry
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {},
      },
    },
    fzf = {
      select = 'default',
      paste = 'ctrl-p',
      paste_behind = 'ctrl-k',
      custom = {},
    },
  },
}

require("telescope").load_extension("neoclip")
