---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
      telemetry = { enabled = false },
      -- completion = { parameterCase = "camel" },
      format = {
        enable = true,
        braces = "k&r", --default: per
      },
      editor = {
        tabSize = 2,
        insertSpaces = true
      },
      phpdoc = { addPackage = true },
      trace = { server = "messages" },
      stubs = {
        "bcmath", "bz2", "Core", "curl", "date", "dom", "fileinfo", "filter", "gd", "gettext", "hash", "iconv", "imap",
        "intl", "json", "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password", "pcntl", "pcre", "PDO",
        "pdo_mysql", "Phar", "readline", "regex", "session", "SimpleXML", "sockets", "sodium", "standard", "superglobals",
        "tokenizer", "xml", "xdebug", "xmlreader", "xmlwriter", "yaml", "zip", "zlib", "wordpress-stubs",
        "woocommerce-stubs", "acf-pro-stubs", "wordpress-globals", "wp-cli-stubs", "genesis-stubs", "polylang-stubs",
        "bcmath", "bz2", "calendar", "Core", "curl", "zip", "zlib", "wordpress", "md5",
        "woocommerce", "acf-pro", "wordpress-globals", "wp-cli", "genesis", "polylang"
      },
      environemnt = {
        includePaths = { "vendor/php-stubs" },
      },
      files = {
        maxSize = 5000000,
      }
    }
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
