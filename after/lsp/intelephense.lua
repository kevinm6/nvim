---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  init_options = {
    globalStoragePath = vim.fn.expand "~/.local/php/",
    -- clearCache = true
    root_markers = { "composer.json", ".git" },
  },
  docs = {
    description = [[
https://intelephense.com/

`intelephense` can be installed via `npm`:
```sh
npm install -g intelephense
```

```lua
-- See https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#initialisation-options
init_options = {
  storagePath = …, -- Optional absolute path to storage dir. Defaults to os.tmpdir().
  globalStoragePath = …, -- Optional absolute path to a global storage dir. Defaults to os.homedir().
  licenceKey = …, -- Optional licence key or absolute path to a text file containing the licence key.
  clearCache = …, -- Optional flag to clear server state. State can also be cleared by deleting {storagePath}/intelephense
}
-- See https://github.com/bmewburn/intelephense-docs
settings = {
  intelephense = {
    files = {
      maxSize = 1000000;
    };
  };
}
```
]],
  },
}