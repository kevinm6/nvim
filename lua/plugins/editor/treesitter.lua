-------------------------------------
-- File         : treesitter.lua
-- Description  : TreeSitter config
-- Author       : Kevin
-- Last Modified: 29/05/2025, 21:04
-------------------------------------

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
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
    require "lib.ts_utils".attach(ev.buf)

    vim.api.nvim_create_autocmd("BufDelete", {
      pattern = parsers_to_be_installed(),
      callback = function()
        require "lib.ts_utils".detach(ev.buf)
      end
    })
  end
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(function() require "nvim-treesitter".install(parsers_to_be_installed()) end)
      pcall(function() require "nvim-treesitter".update() end)
    end,
    branch = "main",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  },
}