---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "zsh", "sh", "bash" },
  allowList = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      shellcheckArguments = {
        "-e",
        "SC2086", -- Double quote to prevent globbing and word splitting
        "-e",
        "SC2155", -- Declare and assign separately to avoid masking return values
      },
      shfmt = {
        binaryNextLine = false,
        caseIndent = true,
        funcNextLine = true,
        simplifyCode = true,
        -- spaceRedirects = false
      }
    },
  },
}