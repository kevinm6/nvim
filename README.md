# <p align="center" style="color: #015A60">NeoVim config</p>
<p align="center" style="font-size:16px;color:grey">v0.12</p>

<p align="center">
  <img alt="Lua" src="https://img.shields.io/badge/Lua-2C2D72?style=flat&logo=lua&logoColor=white">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/kevinm6/nvim?style=flat">
  <img alt="GitHub" src="https://img.shields.io/github/license/kevinm6/nvim?style=flat">
</p>

---

***Theme***: [knvim-theme](https://github.com/kevinm6/knvim-theme.nvim)

<img width="960" height="1049" alt="nvimScreen1" src="https://github.com/user-attachments/assets/d2da4e9a-147c-4167-b87b-2be4b3125304" />

<img width="960" height="1049" alt="nvimScreen2" src="https://github.com/user-attachments/assets/4abd2d38-ac47-4754-8ec7-8f5606150d38" />
---

> Written mostly in ![Lua](https://img.shields.io/badge/Lua-2C2D72?style=flat&logo=lua&logoColor=white)

## Most used plugins

- [Lazy](https://github.com/folke/lazy.nvim)
- [Snacks](https://github.com/folke/snacks.nvim)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Which-Key](https://github.com/folke/which-key.nvim)
- [Mason](https://github.com/williamboman/mason.nvim)
- [Mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)
- [blink-cmp](https://github.com/saghen/blink.cmp)
- [Dap](https://github.com/mfussenegger/nvim-dap)
- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)
- [Which-Key](https://github.com/folke/which-key.nvim)
- [Notify](https://github.com/rcarriga/nvim-notify)
- [Noice](https://github.com/folke/noice.nvim)
- [Mini-Surround](https://github.com/echasnovski/mini.surround)
- [Mini-Pairs](https://github.com/echasnovski/mini.pairs)
- [Ufo](https://github.com/kevinhwang91/nvim-ufo)
- [Oil](https://github.com/stevearc/oil.nvim)
- [Markdown-Render](https://github.com/MeanderingProgrammer/markdown.nvim)
- [Alpha](https://github.com/goolord/alpha-nvim)

---

### Try with Docker

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
apk add git lazygit neovim ripgrep alpine-sdk --update
git clone https://github.com/kevinm6/kurayami.nvim ~/dev/kurayami.nvim
git clone https://github.com/kevinm6/nvim ~/.config/nvim
cd ~/.config/nvim
nvim
'
```