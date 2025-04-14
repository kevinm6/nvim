local function organize_imports()
  local params = {
    command = "pyright.organizeimports",
    arguments = { vim.uri_from_bufnr(0) },
  }

  local clients = vim.lsp.get {
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  }
  for _, client in ipairs(clients) do
    client.request("workspace/executeCommand", params, nil, 0)
  end
end

local function set_python_path(path)
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    client.notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = function(bufnr, cb)
    local dir = vim.fs.root(bufnr, {
      ".git",
      "setup.py",
      "setup.cfg",
      "pyproject.toml",
      "requirements.txt",
    }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    cb(dir)
  end,
  -- root_markers = { ".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt" },
  single_file_support = true,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  commands = {
    PyrightOrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
    PyrightSetPythonPath = {
      set_python_path,
      description = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    },
  },
  docs = {
    description = [[
https://github.com/microsoft/pyright

`pyright`, a static type checker and language server for python
]],
  },
}