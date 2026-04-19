vim.opt_local.makeprg = "scala"
-- vim.opt_local.errorformat = ""

local has_metals, metals = pcall(require, "metals")
if not has_metals then
  vim.notify("Scala: `nvim-metals` not found or error on starting", vim.log.levels.ERROR, { title = "Metals" })
  return
end

local metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

local dap = require "lua.plugins.editor.dap"

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

-- metals_config.on_attach = function(_, _)
--   require("metals").setup_dap()
-- end

vim.lsp.config("metals", metals_config)
require("metals").initialize_or_attach(metals_config)