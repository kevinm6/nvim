---@type vim.lsp.Config
return {
  cmd = {  "groovy-language-server" },
  filetypes = { "groovy" },
  root_markers = { "settings.gradle", "build.gradle" },
  docs = {
    description = [[
https://github.com/microsoft/vscode-gradle

Microsoft's lsp server for gradle files

If you're setting this up manually, build vscode-gradle using `./gradlew installDist` and point `cmd` to the `gradle-language-server` generated in the build directory
]],
  },
}
