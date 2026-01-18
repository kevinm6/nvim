-------------------------------------
-- Description  : useful plugins
-- Author       : Kevin
-- Last Modified: 14 Jan 2026, 21:53
--  NOTE
--    Font    : Fira Code : 12.5 v|i 92, n/n 90
--    Fallback: Source Code Pro : 13 v|i 92, n/n 90
--    Symbols : Symbols (Only) Nerd Font
-------------------------------------

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
---Auto-Pairs
require("mini.pairs").setup {
  mappings = {
    ["<"] = { action = "open", pair = "<>", neigh_pattern = "^r.", register = { cr = false } },
    [">"] = { action = "close", pair = "<>", register = { cr = false } },
  }
}

require("lib").user_command_toggle("ToggleAutoPairs", "minipairs_disable", {
  title = "Auto-Pairs",
  desc = "Toggle AutoPairs (mini.pairs)",
})

---Surround
require("mini.surround").setup()

---Align
require("mini.align").setup()

---WhichKey
local mini_clue = require("mini.clue")
mini_clue.setup {
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = {
    mini_clue.gen_clues.builtin_completion(),
    mini_clue.gen_clues.g(),
    mini_clue.gen_clues.marks(),
    mini_clue.gen_clues.registers(),
    mini_clue.gen_clues.square_brackets(),
    mini_clue.gen_clues.windows(),
    mini_clue.gen_clues.z(),

    { mode = 'n', keys = '<Leader><Leader>', desc = '❭ Buffers' },
    { mode = 'n', keys = '<Leader>n', desc = '❭ Notifications' },
    { mode = 'n', keys = '<Leader>f', desc = '❭ Find' },
    { mode = 'n', keys = '<Leader>l', desc = '❭ LSP' },
    { mode = 'n', keys = '<Leader>lw', desc = 'LSP ❭ Workspace' },
    { mode = 'n', keys = '<Leader>d', desc = '❭ DAP' },
    { mode = 'n', keys = '<Leader>g', desc = '❭ Git' },
    { mode = 'n', keys = '<Leader>t', desc = '❭ Terminal' },
  },
  window = {
    config = {
      height = math.floor(vim.o.lines * 0.26),
      width = "auto",
      -- width = math.floor(vim.o.columns * 0.26),
      anchor = "SE",
      border = "rounded",
    },
    delay = 400
  }
}

---Avoid running before 'vim.filetype.match'
vim.api.nvim_create_autocmd("FileType", {
  once = true,
  callback = function()
    ---Icons
    local mini_icons = require("mini.icons")
    --      --[[
    mini_icons.setup {
      filetype = {
        telescope = { glyph = " " },
        dashboard = { glyph = "" },
        list = { glyph = "" },
        table = { glyph = "" },
        search = { glyph = " " },
        error = { glyph = "" },
        warning = { glyph = "" },
        information = { glyph = "" },
        question = { glyph = "" },
        hint = { glyph = "󱧢" },
        status_ok = { glyph = "" },
        status_not_ok = { glyph = "" },
        term = { glyph = " " },
        notification = { glyph = " " },
      },
      file = {
        files = { glyph = "" },
        run = { glyph = "" },
        continue = { glyph = " " },
        reload_continue = { glyph = " " },
        pause = { glyph = "" },
        stop = { glyph = " " },
        breakpoint = { glyph = "" },
        restart = { glyph = " " },
        disconnect = { glyph = " " },
        into = { glyph = "" },
        over = { glyph = " " },
        out = { glyph = "󰆸" },
        repl = { glyph = " " },
        rerun = { glyph = " " },
        eval = { glyph = " " },
        working_sym = { glyph = "⟳" },
        error_sym = { glyph = "✗" },
        done_sym = { glyph = "✓" },
        removed_sym = { glyph = "-" },
        moved_sym = { glyph = "→" },
        header_sym = { glyph = "━" },
      },
      directory = {
        branch = { glyph = " " },
        -- Change Type
        add = { glyph = "" },
        mod = { glyph = "" },
        ignore = { glyph = "" },
        remove = { glyph = "" },
        rename = { glyph = "" },
        diff = { glyph = "" },
        repo = { glyph = "" },
        -- Status Type
        unstaged = { glyph = "*" },
        staged = { glyph = "" },
        unmerged = { glyph = "" },
        untracked = { glyph = "" },
        conflict = { glyph = "" },
        ignored = { glyph = "" },
        deleted = { glyph = "✗" },
      },
      lsp = {
        nvim_lsp = { glyph = "" },
        nvim_lua = { glyph = "" },
        snippet = { glyph = "󰘦" },
        buffer = { glyph = "" },
        path = { glyph = "" },
        treesitter = { glyph = "" },
        latex_symbols = { glyph = "α" },
        emoji = { glyph = "" },
        calc = { glyph = "" },
        otter = { glyph = "⎆" },
      }
    }
    -- ]]
    mini_icons.mock_nvim_web_devicons()
  end
})

---Diffs
local mini_diff = require("mini.diff")
local has_git = vim.fn.executable("git") == 1
local diff_sources = has_git and { mini_diff.gen_source.git(), mini_diff.gen_source.save() } or
    { mini_diff.gen_source.save() }

mini_diff.setup {
  view = {
    style = "sign",
    -- signs = { add = "+", change = "~", delete = "-" }
    signs = { add = '┃', change = '┃', delete = '▁' }
  },
  source = diff_sources,
  mappings = {
    apply = 'gh',
    reset = 'gH',
    textobject = 'gh',
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  }
}

vim.keymap.set("n", "<leader>gd", function() mini_diff.toggle_overlay() end, { desc = "Git diff" })

vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#73C990", bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#E1C08C", bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#b2555b", bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = "#2e9aff", bg = "#2c2c2c" })
vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = "orange", bg = "#2c2c2c" })
vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = "NONE", bg = "#b2555b" })

---Files
local mini_files = require("mini.files")
local set_cwd = function()
  local path = (mini_files.get_fs_entry() or {}).path
  if path == nil then return vim.notify("MiniFiles - cursor is not on valid entry") end
  local dir_path = vim.fs.dirname(path)
  vim.fn.chdir(dir_path)
  vim.notify("MiniFiles - tcd => " .. dir_path, vim.log.levels.INFO, { title = "Mini.Files" })
end

-- Yank in register full path of entry under cursor
local yank_path = function()
  local path = (mini_files.get_fs_entry() or {}).path
  if path == nil then return vim.notify("MiniFiles - cursor is not on valid entry") end
  vim.fn.setreg(vim.v.register, path)
end

local function map_split(buf_id, lhs, direction)
  local rhs = function()
    local cur_target = mini_files.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)
    mini_files.set_target_window(new_target)
    mini_files.go_in { close_on_file = true }
  end
  local desc = 'Split ' .. direction
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

local show_dotfiles = true

local function filter_show() return true end

local function filter_hide(fs_entry)
  return not vim.startswith(fs_entry.name, '.')
end

local function toggle_dotfiles()
  mini_files.refresh({ content = { filter = show_dotfiles and filter_show or filter_hide } })
  show_dotfiles = not show_dotfiles
end

local function format_size(size)
  if not size then
    return
  elseif size < 1024 then
    return ("%3dB"):format(size)
  elseif size < 1048576 then
    return ("%3.0fK"):format(size / 1024)
  else
    return ("%3.0fM"):format(size / 1048576)
  end
end

local function format_time(time)
  return time and vim.fn.strftime("%d-%m-%Y %H:%M", time.sec) or nil
end

local function custom_pre_prefix(fs_stat)
  local _, mtime = pcall(format_time, fs_stat.mtime)
  local pre_prefix = ""
  if mtime ~= nil then
    pre_prefix = pre_prefix .. " " .. mtime
  end
  if fs_stat.type == "file" then
    local _, size = pcall(format_size, fs_stat.size)
    if size ~= nil then
      pre_prefix = pre_prefix .. " " .. size
    end
  end
  return pre_prefix
end

local function custom_prefix(fs_entry)
  local prefix, hl = require("mini.files").default_prefix(fs_entry)
  local fs_stat = vim.loop.fs_stat(fs_entry.path) or {}
  local pre_prefix = custom_pre_prefix(fs_stat)
  return pre_prefix .. " " .. prefix, hl
end

local show_details = false
local function toggle_details()
  show_details = not show_details
  mini_files.refresh { content = { prefix = show_details and custom_prefix or mini_files.default_prefix } }
end
mini_files.setup {
  content = { filter = filter_hide },
  -- content = { prefix = custom_prefix, filter = filter_show  },
  mappings = {
    close       = "q",
    go_in       = "<C-l>",
    go_in_plus  = "<C-l>",
    go_out      = "<C-h>",
    go_out_plus = "<C-h>",
    mark_goto   = "'",
    mark_set    = "m",
    reset       = "<BS>",
    reveal_cwd  = "gw",
    show_help   = "g?",
    trim_left   = "<",
    trim_right  = ">",
    synchronize = "<leader>w",
    refresh     = "<leader>r",
  }
}

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    local win_id = args.data.win_id
    vim.wo[win_id].winblend = 8
    local config = vim.api.nvim_win_get_config(win_id)
    config.border, config.title_pos = "rounded", "center"
    vim.api.nvim_win_set_config(win_id, config)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  group = vim.api.nvim_create_augroup("mini-file-buffer", { clear = true }),
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set('n', '<leader>t', set_cwd, { buffer = buf_id, desc = 'Set cwd' })
    vim.keymap.set('n', '<M-h>', toggle_dotfiles, { buffer = buf_id })
    vim.keymap.set("n", "<M-d>", toggle_details, { buffer = buf_id, desc = "Toggle file details" })
    vim.keymap.set('n', 'gx', function() vim.ui.open(mini_files.get_fs_entry().path) end,
      { buffer = buf_id, desc = 'OS open' })
    vim.keymap.set('n', 'gy', yank_path, { buffer = buf_id, desc = 'Yank path' })
    vim.keymap.set('n', '<cr>', function() mini_files.go_in { close_on_file = true } end,
      { buffer = buf_id, desc = 'Open File' })
    map_split(buf_id, '<C-s>', 'belowright horizontal')
    map_split(buf_id, '<M-C-S>', 'belowright vertical')
    map_split(buf_id, '<C-t>', 'tab')
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    mini_files.set_bookmark('c', vim.fn.stdpath('config'), 'Config')
    mini_files.set_bookmark('w', vim.fn.getcwd, 'Working directory')
    mini_files.set_bookmark('~', '~', 'Home directory')
    mini_files.set_bookmark('h', '~', 'Home directory')
    mini_files.set_bookmark('d', vim.fn.expand "$DOTFILES", 'Dotfiles directory')
    mini_files.set_bookmark('u', "~/uni", 'Dotfiles directory')
    mini_files.set_bookmark('W', "~/work", 'Work directory')
    mini_files.set_bookmark('t', "~/.Trash", 'Trash')
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowUpdate",
  callback = function(args)
    local config = vim.api.nvim_win_get_config(args.data.win_id)
    config.height = math.floor(vim.o.lines * 0.4)
    local n = #config.title
    config.title[1][1] = config.title[1][1]:gsub('^ ', '')
    config.title[n][1] = config.title[n][1]:gsub(' $', '')
    vim.api.nvim_win_set_config(args.data.win_id, config)
  end,
})
vim.keymap.set("n", "<leader>e", function()
    -- require("mini.files").open()
    local buf_path = vim.api.nvim_buf_get_name(0)
    local path_exists = vim.fn.filereadable(buf_path) == 1
    require("mini.files").open(path_exists and buf_path or vim.uv.cwd())
  end,
  { desc = "File Explorer" })

vim.keymap.set("n", "<leader>E", function()
    --Open fresh in cwd
    require("mini.files").open(nil, false)
  end,
  { desc = "File Explorer" })