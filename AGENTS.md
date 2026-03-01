# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Chezmoi-managed dotfiles repository. Only the Neovim configuration is actively maintained here; other configurations are deprecated.

## Chezmoi Commands

```bash
chezmoi apply                    # Apply changes to home directory
chezmoi diff                     # Preview changes before applying
chezmoi edit ~/.config/nvim/...  # Edit a managed file
chezmoi re-add ~/.config/nvim/...# Re-add after direct edits to target
```

## Chezmoi Naming Conventions

- `dot_` prefix → hidden file
- `private_dot_` prefix → hidden file in private directory
- `executable_` prefix → executable permissions
- `.tmpl` suffix → processed as Go template

## Neovim Configuration

Location: `private_dot_config/nvim/`

**Structure:**
- `lua/user/options.lua` - Editor settings
- `lua/user/keymaps.lua` - Key mappings
- `lua/user/plugins/` - Lazy.nvim plugin specs
- `lua/user/plugins/lsp/` - LSP configuration
- `lua/user/plugins/lsp/configs/` - Per-language LSP configs

**Plugin Manager:** Lazy.nvim

**Colorscheme:** Gruvbox

**LSP Servers Configured:** lua_ls, nixd, jsonnet_ls, beancount, gopls, terraformls, yamlls

## Platform Handling

The `.chezmoiignore` conditionally excludes files based on NixOS detection. Template files (`.tmpl`) use Chezmoi variables like `{{ .chezmoi.os }}` for platform-specific content.
