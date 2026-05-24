# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory (e.g., `zsh`, `git`, `bat`) is a stow package. Running `stow` symlinks the package contents into `$HOME`, with the `dot-` prefix convention mapping to a leading dot (e.g., `dot-zshrc` → `~/.zshrc`).

## Common Commands

```sh
just stow        # Stow all packages to $HOME
just unstow      # Remove all stowed symlinks

just update-all          # Update libs, functions, and plugins from upstream
just update-libs         # Fetch Zsh library files (e.g., ohmyzsh git.zsh)
just update-functions    # Fetch completion functions from upstream repos
just update-plugins      # Fetch plugin files from upstream repos

mr checkout      # Clone repos listed in .mrconfig (gitmanaged plugins, powerlevel10k, etc.)
mr update        # Update all managed repos
```

## Architecture

### Stow Layout

Each package mirrors the target directory structure relative to `$HOME`. The `dot-` prefix is stripped and replaced with `.` by Stow's `--dotfiles` flag:

- `zsh/dot-zshrc` → `~/.zshrc`
- `zsh/dot-zshrc.d/` → `~/.zshrc.d/`
- `zsh/dot-config/zsh-patina/` → `~/.config/zsh-patina/`

### Zsh Configuration (`zsh/`)

The main `dot-zshrc` is a monolithic file containing env vars, path setup, aliases, and functions. It sources files from `~/.zshrc.d/` at startup:

- `lib/*.zsh` — library files (currently `git.zsh` from ohmyzsh)
- `plugins/*/*.plugin.zsh` — plugins, loaded in alphabetical order by directory name
- `functions/` — completion functions (fpath), not sourced directly

Plugin loading order is controlled by directory name prefixes: `01-zsh-completions`, `02-zsh-vim-mode`, `03-fzf-tab`, `04-zsh-autosuggestions` are cloned via `.mrconfig` and gitignored. The remaining plugins (`aws`, `fzf-git`, `git`, `git-extras`, `screen`) are single files fetched by `just update-plugins`.

### Managed vs. Committed Content

- **Committed directly**: custom completions in `functions/`, config files for other tools
- **Fetched by `just update-*`**: single-file plugins and completion functions from upstream (committed after fetching)
- **Cloned via `mr`**: full plugin repos in `zsh/dot-zshrc.d/plugins/01-*` through `04-*` and `powerlevel10k/` — these are gitignored

### Other Packages

- `git/` — `dot-gitconfig` with aliases, delta pager config, and signing settings
- `bat/`, `eza/`, `p10k/`, `tig/`, `tmux/`, `task/` — tool-specific configs
- `bc/` — `.bcrc` for interactive bc sessions
- `just/` — user-level justfile (`dot-user.justfile`, aliased as `.j`)
