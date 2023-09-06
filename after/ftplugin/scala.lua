-------------------------------------
-- File         : scala.lua
-- Description  : scala language server configuration (metals)
-- Author       : Kevin
-- Last Modified: 08 Aug 2023, 17:18
-------------------------------------

local ok, metals = pcall(require, "metals")
if not ok then
  vim.notify("  Error on starting metals ", vim.log.levels.ERROR)
  return
end

local metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.capabilities = require "cmp_nvim_lsp".default_capabilities()

local dap = require "dap"

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(_, _)
  require "metals".setup_dap()
end

require "metals".initialize_or_attach(metals_config)
