-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 08/06/2025
-------------------------------------

vim.pack.add { { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } }

local function parsers_to_be_installed()
  return {
    "c",
    "comment",
    "cpp",
    "css",
    "dot",
    "dockerfile",
    "bash",
    "gitignore",
    "gitattributes",
    "gitcommit",
    "git_rebase",
    "go",
    "vimdoc",
    "html",
    "http",
    "json",
    "json5",
    "jsdoc",
    "latex",
    "ruby",
    "lua",
    "java",
    "javascript",
    "markdown",
    "markdown_inline",
    "php",
    "python",
    "regex",
    "python",
    "phpdoc",
    "scheme",
    "sql",
    "swift",
    "todotxt",
    "vim",
    "yaml",
    "ini",
  }
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers_to_be_installed(),
  callback = function(ev)
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    require "lib.ts_utils".attach(ev.buf)

    vim.api.nvim_create_autocmd("BufDelete", {
      pattern = parsers_to_be_installed(),
      callback = function()
        require "lib.ts_utils".detach(ev.buf)
      end
    })
  end
})

require("nvim-treesitter").setup {}


vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("nvim-treesitter_update_handler", { clear = true }),
  desc = "Handle nvim-treesitter updates",
  callback = function(ev)
    if ev.data.kind == "update" and ev.data.spec.name == "nvim-treesitter" then
      pcall(function() require "nvim-treesitter".install(parsers_to_be_installed()):wait(300000) end)
      pcall(function() require "nvim-treesitter".update() end)
    end
  end
})