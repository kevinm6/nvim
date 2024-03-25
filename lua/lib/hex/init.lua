-------------------------------------
--  File         : hex.lua
--  Description  : edit hex files
--  Author       : Kevin
--  Source       : https://github.com/RaafatTurki/hex.nvim/tree/master/lua
--  Last Modified: 24 Mar 2024, 14:08
-------------------------------------

local utils = require 'lib.hex.utils'
local augroup_hex_editor = vim.api.nvim_create_augroup('hex_editor', { clear = true })

local hex = {}

local cfg = {
  dump_cmd = 'xxd -g 1 -u',
  assemble_cmd = 'xxd -r',
  is_file_binary_pre_read = function()
    local binary_ext = { 'out', 'bin', 'png', 'jpg', 'jpeg', 'exe', 'dll' }
    -- only work on normal buffers
    if vim.bo.ft ~= "" then return false end
    -- check -b flag
    if vim.bo.bin then return true end
    -- check ext within binary_ext
    -- local filename = vim.fn.expand('%:t')
    local ext = vim.fn.expand('%:e')
    if vim.tbl_contains(binary_ext, ext) then return true end
    -- none of the above
    return false
  end,
  is_file_binary_post_read = function()
    local encoding = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
    if encoding ~= 'utf-8' then return true end
    return false
  end,
}

function hex.dump()
  if not vim.b['hex'] then
    utils.dump_to_hex(cfg.dump_cmd)
  else
    vim.notify('already dumped!', vim.log.levels.WARN)
  end
end

function hex.assemble()
  if vim.b['hex'] then
    utils.assemble_from_hex(cfg.assemble_cmd)
  else
    vim.notify('already assembled!', vim.log.levels.WARN)
  end
end

function hex.toggle()
  if not vim.b['hex'] then
    hex.dump()
  else
    hex.assemble()
  end
end

local function setup_auto_cmds()
  vim.api.nvim_create_autocmd({ 'BufReadPre' }, { group = augroup_hex_editor, callback = function()
    if cfg.is_file_binary_pre_read() then
      vim.b['hex'] = true
    end
  end })

  vim.api.nvim_create_autocmd({ 'BufReadPost' }, { group = augroup_hex_editor, callback = function()
    if vim.b.hex then
      utils.dump_to_hex(cfg.dump_cmd)
    elseif cfg.is_file_binary_post_read() then
      vim.b['hex'] = true
      utils.dump_to_hex(cfg.dump_cmd)
    end
  end })

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, { group = augroup_hex_editor, callback = function()
    if vim.b.hex then
      utils.begin_patch_from_hex(cfg.assemble_cmd)
    end
  end })

  vim.api.nvim_create_autocmd({ 'BufWritePost' }, { group = augroup_hex_editor, callback = function()
    if vim.b.hex then
      utils.finish_patch_from_hex(cfg.dump_cmd)
    end
  end })
end

-- TODO: improve setup
function hex.setup(args)
  cfg = vim.tbl_deep_extend("force", cfg, args or {})

  local dump_program = vim.fn.split(cfg.dump_cmd)[1]
  local assemble_program = vim.fn.split(cfg.assemble_cmd)[1]

  if not utils.is_program_executable(dump_program) then return end
  if not utils.is_program_executable(assemble_program) then return end

  vim.api.nvim_create_user_command('HexDump', hex.dump, {})
  vim.api.nvim_create_user_command('HexAssemble', hex.assemble, {})
  vim.api.nvim_create_user_command('HexToggle', hex.toggle, {})

  setup_auto_cmds()
end

return hex