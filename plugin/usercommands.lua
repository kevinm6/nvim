-------------------------------------
-- File         : usercommands.lua
-- Description  : User commands config
-- Author       : Kevin
-- Last Modified: 13 May 2024, 12:08
-------------------------------------

local user_command = vim.api.nvim_create_user_command

---Create NewFile
user_command("NewFile", function(args)
  require("lib").new_file(args)
end, {
  desc = "Create new File",
  nargs = "?",
  complete = "filetype",
})

---Create NewTempFile
user_command("NewTempFile", function(args)
  require("lib").new_tmp_file(args)
end, {
  desc = "Create new temp File",
  nargs = "?",
  complete = "filetype",
})

---Scratch
user_command("Scratch", function()
  vim.cmd.new()
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end, { desc = "Create a Scratch buffer" })

---Trim extra trailing spaces in current buffer
user_command("TrimTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

---Query CheatSH and get output in window
user_command("CheatSH", function(args)
  require("lib.cheat_sheet").run(args)
end, {
  nargs = "?",
  desc = "Cheat-Sheet",
  complete = "filetype",
})

---Wipe all Registers
user_command("WipeReg", function()
  local regs = vim.fn.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', "\\zs") or {}
  for _, v in pairs(regs) do
    vim.call("setreg", v, "")
  end
  vim.notify("All Registers wiped", vim.log.levels.INFO, { title = "Registers" })
end, { desc = "Wipe all Registers" })

---Sessions
user_command("Session", function(arg)
  local action = vim.trim(arg.args)
  require("lib.session").select(action)
end, {
  nargs = "?",
  desc = "Session Manager",
  complete = "customlist,v:lua.require'lib.session'.usercmd_session_completion",
})

---Config File
user_command("NvimConfig", function()
  local has_snacks, snacks = pcall(require, "snacks.picker")
  local config_path = vim.fn.stdpath "config"
  if not has_snacks then
    vim.cmd.edit()
  else
    snacks.files { dirs = { config_path } }
  end
end, { desc = "Neovim Config" })

---Data Files
user_command("NvimData", function()
  local has_snacks, snacks = pcall(require, "snacks.picker")
  local data_path = vim.fn.stdpath "data"
  if not has_snacks then
    vim.cmd.edit(data_path)
  else
    snacks.files { dirs = { data_path } }
  end
end, { desc = "Neovim Config" })

---Lazygit
user_command("Lazygit", function()
  local has_snacks, snacks = pcall(require, "snacks")
  if has_snacks then
    snacks.lazygit()
  else
    require("lib.terminal").new_terminal_win("lazygit", true, { preset = "lazygit" })
  end
end, { desc = "Lazygit", force = true })

---Htop
user_command("Htop", function()
  require("lib.terminal").new_terminal_win("htop", true, { preset = "htop" })
end, { desc = "Htop", force = true })

---NCDU
user_command("Ncdu", function()
  require("lib.terminal").new_terminal_win("ncdu", true, { preset = "ncdu" })
end, { desc = "Ncdu", force = true })

---Dotfiles
user_command("Dotfiles", function()
  local has_oil, oil = pcall(require, "oil")
  local dotfiles_dir = vim.env.DOTFILES or vim.fn.expand "~/.MacDotfiles"
  if not has_oil then
    vim.cmd.edit(dotfiles_dir)
  else
    oil.open_float(dotfiles_dir)
  end
end, { desc = "Open Dotfiles dir" })

---University
user_command("University", function()
  local has_oil, oil = pcall(require, "oil")
  local university_dir = vim.env.CS or vim.fn.expand "~/Informatica/"
  if not has_oil then
    vim.cmd.edit(university_dir)
  else
    oil.open_float(university_dir)
  end
end, { desc = "Open Dotfiles dir" })

---Notes
user_command("Notes", function()
  require("lib.notes").open_note()
end, { desc = "Open notes" })

local usercmd_toggle = require("lib").user_command_toggle

user_command("DiffOrig", function()
  vim.cmd [[
  new | set buftype=nofile | read ++edit # | 0d_ \ | diffthis | wincmd p | diffthis
 ]]
end, { desc = "View this in diff-mode" })

---Encode Base64
user_command("EncodeBase64", function(r)
  require("lib.base64").process_base64(true, r)
end, {
  desc = "Encode text Base64",
  range = true,
})

---Decode Base64
user_command("DecodeBase64", function(r)
  require("lib.base64").process_base64(false, r)
end, {
  desc = "Decode text Base64",
  range = true,
})

---Update `Last Modified` date if found in first 10 row of file
usercmd_toggle("ToggleAutoTimeStamp", "auto_timestamp", {
  title = "Auto Update TimeStamp",
  desc = "Update TimeStamp on save",
  on_enable = require("lib.automation").auto_timestamp,
  on_disable = function()
    local has_autocmd, autocmd = pcall(vim.api.nvim_get_autocmds, {
      event = "BufWritePre",
      group = "_autoupdate_timestamp",
      pattern = "*",
    })
    if has_autocmd then
      vim.api.nvim_del_autocmd(autocmd[1].id)
    end
  end,
})

---User command to toggle auto trim trailing space on save
usercmd_toggle("ToggleAutoTrimTrailSpaces", "auto_remove_trail_spaces", {
  title = "Auto Remove trailing spaces",
  desc = "Remove extra trailing white spaces",
  on_enable = require("lib.automation").auto_remove_trailing_spaces,
  on_disable = function()
    local has_autocmd, autocmd = pcall(vim.api.nvim_get_autocmds, {
      event = "BufWritePre",
      group = "_autoremove_trailing_space",
      pattern = "*",
    })
    if has_autocmd then
      vim.api.nvim_del_autocmd(autocmd[1].id)
    end
  end,
})
