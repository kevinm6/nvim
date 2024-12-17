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
  require("lib.session").select(arg.args)
end, {
  nargs = 1,
  desc = "Session Manager",
  complete = "custom,v:lua.require'lib.session'.usercmd_session_completion",
})

---Config File
user_command("NvimConfig", function()
  local has_telescope, tele_builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    vim.cmd.edit(vim.fn.stdpath "config")
  else
    tele_builtin.find_files { cwd = vim.fn.stdpath "config" }
  end
end, { desc = "Neovim Config" })

---Data Files
user_command("NvimData", function()
  local has_telescope, tele_builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    vim.cmd.edit(vim.fn.stdpath "data")
  else
    tele_builtin.find_files { cwd = vim.fn.stdpath "data" }
  end
end, { desc = "Neovim Config" })

---Lazygit
user_command("Lazygit", function()
  require("lib.terminal").new_terminal_win("lazygit", true, { preset = "lazygit" })
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

---Export to PDF
user_command("TOpdf", function()
  require("lib.pdf").convert_md_to_pdf()
end, { desc = "Export markdown to pdf" })

local usercmd_toggle = require("lib").user_command_toggle

user_command("DiffOrig", function()
  vim.cmd [[
  new | set buftype=nofile | read ++edit # | 0d_ \ | diffthis | wincmd p | diffthis
 ]]
end, { desc = "View this in diff-mode" })

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
