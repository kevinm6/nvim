local bin_name = "gradle-language-server"
if vim.fn.has "win32" == 1 then
  bin_name = bin_name .. ".bat"
end

---@type vim.lsp.Config
return {
  cmd = { bin_name },
  filetypes = { "groovy" },
  root_markers = { "settings.gradle", "build.gradle" },
  -- gradle-language-server expects init_options.settings to be defined
  init_options = {
    settings = {
      gradleWrapperEnabled = true,
    },
  },
  docs = {
    description = [[
https://github.com/microsoft/vscode-gradle

Microsoft's lsp server for gradle files

If you're setting this up manually, build vscode-gradle using `./gradlew installDist` and point `cmd` to the `gradle-language-server` generated in the build directory
]],
  },
}