# AGENTS.md

Chezmoi-managed dotfiles repo; only `private_dot_config/nvim/` is actively maintained.

## Chezmoi

```bash
chezmoi apply
chezmoi diff
chezmoi edit ~/.config/nvim/...
chezmoi re-add ~/.config/nvim/...
```

Naming:
- `dot_` hidden file
- `private_dot_` hidden file in private dir
- `executable_` executable file
- `.tmpl` Go template

## Neovim

- Config root: `private_dot_config/nvim/`
- Key files: `lua/user/options.lua`, `lua/user/keymaps.lua`, `lua/user/plugins/`, `lua/user/plugins/lsp/`
- Plugin manager: `lazy.nvim`
- Colorscheme: `gruvbox`
- LSPs: `lua_ls`, `nixd`, `jsonnet_ls`, `beancount`, `gopls`, `terraformls`, `yamlls`

## Testing

For headless tests, deploy the managed Neovim config to a temp HOME, then run Neovim against that deployed tree with temp config HOME but existing data dir:

```bash
TEST_HOME=/tmp/<temp_dir> sh -c 'mkdir -p "$TEST_HOME" && chezmoi apply "$TEST_HOME/.config/nvim" -D "$TEST_HOME" -P'
HOME=$TEST_HOME XDG_CONFIG_HOME=$TEST_HOME/.config XDG_STATE_HOME=$TEST_HOME/.local/state XDG_DATA_HOME=/home/black/.config/local/share \
  nvim --headless -u "$TEST_HOME/.config/nvim/init.lua" ...
```

Test the deployed tree under `$TEST_HOME/.config/nvim`, not source files directly.

## Platform

`.chezmoiignore` may exclude files by platform; templates can use `{{ .chezmoi.os }}`.
