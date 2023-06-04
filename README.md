# <p align="center" style="color: #015A60">NeoVim config</p>

<p align="center">
<img alt="Lua"
   src="https://img.shields.io/badge/Lua-2C2D72?style=flat&logo=lua&logoColor=white">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/kevinm6/nvim?style=flat">
<img alt="GitHub" src="https://img.shields.io/github/license/kevinm6/nvim?style=flat">
</p>


---

***Theme***: [knvim-theme](https://github.com/kevinm6/knvim-theme.nvim)

![screenNvim1](https://user-images.githubusercontent.com/72861758/210419269-658f8659-9a7b-422b-b1cb-b6afcc67aa07.png)

![screenNvim2](https://user-images.githubusercontent.com/72861758/210419286-5784a479-729d-4e9a-8ccd-460704b28b9e.png)

---

> Written mostly in [Lua](https://www.lua.org/)

_Most used plugins_:  

- [Lazy](https://github.com/folke/lazy.nvim)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Which-Key](https://github.com/folke/which-key.nvim)
- [Mason](https://github.com/williamboman/mason.nvim)
- [Mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [Dap](https://github.com/mfussenegger/nvim-dap)
- [Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim)
- [Whichkey](https://github.com/folke/which-key.nvim)
- [Notify](https://github.com/rcarriga/nvim-notify)
- [Noice](https://github.com/folke/noice.nvim)
- [ToggleTerm](https://github.com/akinsho/toggleterm.nvim)
- [Alpha](https://github.com/goolord/alpha-nvim)
- [Autopairs](https://github.com/windwp/nvim-autopairs)
- [Cheatsheet](https://github.com/Djancyp/cheat-sheet)
- [Code_runner](https://github.com/CRAG666/code_runner.nvim)
- [Comment](https://github.com/numToStr/Comment.nvim)
- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)
- [Luasnip](https://github.com/L3MON4D3/LuaSnip)
- [Navic](https://github.com/SmiteshP/nvim-navic)
- [Nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- [Oil](https://github.com/stevearc/oil.nvim)
- [Mind](https://github.com/phaazon/mind.nvim)
- [Peek](https://github.com/toppair/peek.nvim)
- [Surround](https://github.com/ur4ltz/surround.nvim)
- [Todo-comments](https://github.com/folke/todo-comments.nvim)
- [Twilight](https://github.com/folke/twilight.nvim)
- [Ufo](https://github.com/kevinhwang91/nvim-ufo)
- [Glow](https://github.com/ellisonleao/glow.nvim)

---

**Try with Docker**

```bash
  docker run -w /root -it --rm alpine:edge sh -uelic '
    apk add git lazygit neovim ripgrep alpine-sdk --update
    git clone https://github.com/kevinm6/knvim-theme.nvim ~/dev/knvim-theme.nvim
    git clone https://github.com/kevinm6/nvim ~/.config/nvim
    cd ~/.config/nvim
    nvim
  '
```
