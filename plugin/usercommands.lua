-------------------------------------
-- title: usercommands.lua
-- abstract: User commands config
-- author: Kevin
-- date: 10 Feb 2026, 20:28
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
  vim.notify("Registers - all Registers wiped", vim.log.levels.WARN, { title = "Registers" })
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
  local has_mini, mini_files = pcall(require, "mini.files")
  local dotfiles_dir = vim.env.DOTFILES or vim.fn.expand "~/.MacDotfiles"
  if not has_mini then
    vim.cmd.edit(dotfiles_dir)
  else
    mini_files.open(dotfiles_dir)
  end
end, { desc = "Open Dotfiles dir" })

---University
user_command("University", function()
  local has_mini, mini_files = pcall(require, "mini.files")
  local university_dir = vim.env.CS or vim.fn.expand "~/Informatica/"
  if not has_mini then
    vim.cmd.edit(university_dir)
  else
    mini_files.open_float(university_dir)
  end
end, { desc = "Open Dotfiles dir" })

---Notes
user_command("Notes", function()
  require("lib.notes").open_note()
end, { desc = "Open notes" })

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

---Update `Last Modified` date if found in first 6 rows of file
user_command("ToggleAutoTimeStamp", function()
  if not vim.g.autoupdate_timestamp then
    require("lib.automation").auto_timestamp()
  else
    vim.api.nvim_del_augroup_by_id(vim.g.autoupdate_timestamp)
    vim.g.autoupdate_timestamp = nil
  end
  local state = vim.g.autoupdate_timestamp and "enabled" or "disabled"
  vim.notify("ToggleAutoTimeStamp => " .. state, vim.log.levels.INFO, {
    title = "AutoTimeStamp"
  })
end, { desc = "Toggle auto update timestamp on file" })

---User command to toggle auto trim trailing space on save
user_command("ToggleAutoTrimTrailSpaces", function()
  if not vim.g.autoremove_trailingspace then
    require("lib.automation").auto_remove_trailing_spaces()
  else
    vim.api.nvim_del_augroup_by_id(vim.g.autoremove_trailingspace)
    vim.g.autoremove_trailingspace = nil
  end
  local state = vim.g.autoremove_trailingspace and "enabled" or "disabled"
  vim.notify("ToggleAutoTrimTrailSpaces => " .. state, vim.log.levels.INFO, {
    title = "AutoTrailingSpaces"
  })
end, { desc = "Toggle auto remove trailing spaces on file" })