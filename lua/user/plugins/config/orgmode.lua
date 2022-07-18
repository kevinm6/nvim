-------------------------------------
--  File         : orgmode.lua
--  Description  : orgmode plugin conf
--  Author       : Kevin
--  Last Modified: 18 Jul 2022, 17:59
-------------------------------------

local ok, org = pcall(require, "orgmode")
if not ok then return end

org.setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
  },
}

org.setup {
  org_agenda_files = {
    "~/Library/Mobile Documents/iCloud~dk~simonbs~RunestoneEditor/Documents",
    "~/.orgs/**/*"
  },
  org_default_notes_file = "~/Documents/Notes/notes.org",
}
