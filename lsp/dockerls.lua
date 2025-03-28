return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile" },
  -- root_dir = function(bufnr, cb)
  --   local dir = vim.fs.root(bufnr, { "Dockerfile" }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  --   cb(dir)
  -- end,
  single_file_support = true,
  docs = {
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```

Additional configuration can be applied in the following way:
```lua
require("lspconfig").dockerls.setup {
    settings = {
        docker = {
	    languageserver = {
	        formatter = {
		    ignoreMultilineInstructions = true,
		},
	    },
	}
    }
}
```
    ]],
  },
}
