# neovim config

My neovim config.

## Plugins

See [lua/plugins/](lua/plugins/).
Plugins structures in three subdirectories:

- [lua/plugins/bones/](lua/plugins/bones/) - core plugins that provide minimal functionality for comfort work
- [lua/plugins/meat/](lua/plugins/meat/) - useful plugins that enhance experience
- [lua/plugins/skin/](lua/plugins/skin/) - ui, highlighting, etc

## Installation

### Install Neovim

<https://github.com/neovim/neovim>

### Install External Dependencies

External Requirements:

- `npm`

- `cargo`

- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)

- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

- Clipboard tool (xclip/xsel/win32yank or other depending on platform)

- A [Nerd Font](https://www.nerdfonts.com/) - provides various icons

  - if you don't have it set `vim.g.have_nerd_font` in `options.lua` to false

- tree-sitter

### Install

> **NOTE** > [Backup](#faq) your previous configuration (if any exists)

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

#### Clone

```sh
git clone https://github.com/feascr/neovim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

## Acknowledgments

This Neovim configuration was inspired by and built upon the work of several fantastic projects in the Neovim community. Special thanks to:

- <https://github.com/nvim-lua/kickstart.nvim>
  - Entrypoint into the neovim
- <https://github.com/LazyVim/LazyVim>
  - More complex configuration management and awesome plugins with _working_ configurations
- <https://github.com/chrisgrieser/nvim-kickstart-python>
  - baseline python
- ... and all used plugins
