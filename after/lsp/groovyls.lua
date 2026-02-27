local classpath = { vim.fn.expand(vim.uv.cwd() .. "/build/libs/*.jar") }
vim.list_extend(classpath, vim.fn.glob("~/.gradle/caches/modules-2/files-2.1/**/*.jar", true, true))
vim.list_extend(classpath, vim.fn.glob("~/.gradle/wrapper/dists/gradle-9.1.0-bin/*/gradle-9.1.0/lib/**/*.jar", true, true))

---@type vim.lsp.Config
return {
  cmd = { "groovy-language-server" },
  filetypes = { "groovy" },
  root_markers = { "settings.gradle", "build.gradle", "gradlew" },
  settings = {
    groovy = {
      classpath = classpath
    }
  },
  init_options = {
    -- NOTE
    -- should help with performance in large plugin projects
    jvmArgs = {
      "-Xmx2G",
      "-XX:+UseG1GC"
    }
  },
  docs = {
    description = [[
https://github.com/microsoft/vscode-gradle

Microsoft's lsp server for gradle files

If you're setting this up manually, build vscode-gradle using `./gradlew installDist` and point `cmd` to the `gradle-language-server` generated in the build directory
]],
  },
}