vim.api.nvim_create_user_command("Http", function()
  require("lib.curl").exec()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Httpv", function()
  require("lib.curl").exec(true)
end, { nargs = 0 })

vim.api.nvim_create_user_command("Httpd", function()
  require("lib.curl").exec(false, true)
end, { nargs = 0 })