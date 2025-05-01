local function lua_rtp()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")
  return runtime_path
end

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  single_file_support = true,
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
  },
  -- Note this is ignored if the project has a .luarc.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = lua_rtp(),
      },
      diagnostics = {
        enable = true,
        globals = { "vim", "format", "pandoc", "quarto", "Snacks" },
        disable = { "undefined-field" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("", true),
          vim.fn.stdpath "config" .. "/lua",
          -- "${3rd}/luv/library",
        },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = 2,
          quote_style = "double",
          continuation_indent = 2,
          call_arg_parentheses = "remove",
          insert_final_newline = "false",
          align_if_branch = "true"
        },
      },
      completion = {
        enable = true,
        autoRequire = true,
        keywordSnippet = "Both",
        callSnippet = "Both",
        displayContext = 2,
      },
      hint = {
        enable = true,
        arrayIndex = "Auto",
        await = true,
        paramName = "Disable",
        paramType = false,
        semicolon = "SameLine",
        setType = false,
      },
      telemetry = { enable = false },
    },
  },
}