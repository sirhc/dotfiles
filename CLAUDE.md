# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Chris's personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/). This
repository *is* the chezmoi source directory (`~/.local/share/chezmoi`), so
editing a file here edits the chezmoi source state directly; `chezmoi apply`
deploys it to `$HOME`.

> The repo was migrated from GNU Stow to chezmoi in commit `bc2e056`. If you find
> lingering references to Stow, `just`, or per-tool "packages" anywhere, they're
> stale — flag them.

## Naming convention

chezmoi's source-state attributes drive the target path:

- `dot_zshrc` → `~/.zshrc`
- `dot_config/bat/config` → `~/.config/bat/config`
- `dot_vim/after/ftplugin/ledger.vim` → `~/.vim/after/ftplugin/ledger.vim`

There are currently **no** templates, `run_` scripts, `private_`, or `encrypted_`
files — every source file is a plain copy. Keep it that way unless there's a real
reason not to.

## Common commands

```sh
chezmoi diff              # preview what `apply` would change
chezmoi apply             # deploy source state to $HOME (also clones/updates externals)
chezmoi apply ~/.zshrc    # deploy a single file
chezmoi update            # git pull in this repo, then apply
chezmoi add ~/.foo        # pull an existing dotfile into the source state
chezmoi cd               # open a shell in this directory
chezmoi managed          # list every path chezmoi controls
```

## Architecture

### Externals (`.chezmoiexternal.toml`)

All third-party content is declared here and materialized by `chezmoi apply` —
nothing vendored is committed. Two kinds:

- `type = "git-repo"` — full clones. Vim 8 native packages under
  `~/.vim/pack/<group>/start/*` (plugins, syntax, colors, themes) and the Zsh
  plugins `~/.zshrc.d/plugins/{01-zsh-completions,02-zsh-vim-mode,03-fzf-tab,04-zsh-autosuggestions}`
  plus `~/.zshrc.d/powerlevel10k`.
- `type = "file"` — single files pulled from upstream: Zsh completion functions
  (`~/.zshrc.d/functions/_*`), the ohmyzsh `git.zsh` lib, and single-file Zsh
  plugins (`aws`, `fzf-git`, `git`, `git-extras`, `screen`).

To add/remove a plugin or completion, edit `.chezmoiexternal.toml` and run
`chezmoi apply`. There is no longer a Makefile or `just update-*` target.

### `.chezmoiignore`

Keeps repo-only files (`CLAUDE.md`, `LICENSE`, `**/README.md`, `tmp/**`) in the
repo but out of `$HOME`.

### Zsh (`dot_zshrc`, `dot_zshrc.d/`)

`dot_zshrc` is a single large file: env vars, `path`/`fpath` setup, aliases, and
functions. Near the end (~line 627) it loops over
`~/.zshrc.d/lib/*.zsh` then `~/.zshrc.d/plugins/*/*.plugin.zsh` and sources each.
Plugin load order is alphabetical by directory, hence the `01-`–`04-` prefixes on
the cloned plugins. `~/.zshrc.d/functions/` is on `fpath` for completions, not
sourced. `~/.zshrc.local` (gitignored, per-host) is sourced last.

Committed directly: the custom completion functions in `dot_zshrc.d/functions/`.
Everything else under `dot_zshrc.d/` arrives via externals.

### `dot_mrconfig` → `~/.mrconfig`

This is **not** plugin management (that moved to chezmoi externals). It's a
[myrepos](https://myrepos.branchable.com/) config of custom `mr` subcommands for
day-to-day git/`gh` work across many repos (`mr baseline`, `mr stalebranches`,
`mr localbranches`, default-branch helpers, etc.). It `include`s
`~/.mrconfig.d/*.conf` for the actual repo list.

### Git (`dot_gitconfig`, `dot_gitconfig.d/`)

`dot_gitconfig` has aliases, delta/pager config, and signing settings, and
includes `dot_gitconfig.d/catppuccin.gitconfig` (delta Catppuccin Mocha theme).

### Other packages

`dot_config/` holds configs for bat, eza, ghostty, taskwarrior, tridactyl, and
zsh-patina. Standalone: `dot_bcrc`, `dot_tigrc`, `dot_tmux.conf`, `dot_p10k.zsh`,
`dot_jqp.yaml`, `dot_mdlrc`, `dot_perltidyrc`, `dot_perlcriticrc`, `dot_gemrc`.

## Vim (`dot_vim/`)

Personal Vim runtime config: vimrc, filetype detection, ftplugin overrides,
custom syntax files, one autoload utility. Plugins are Vim 8 native packages
under `~/.vim/pack/`, populated by `.chezmoiexternal.toml` — not tracked here.

### Structure

| Path | Purpose |
|------|---------|
| `dot_vim/vimrc` | Main config — settings, key maps, plugin config (kept near each plugin's section) |
| `dot_vim/filetype.vim` | Custom filetype detection |
| `dot_vim/after/ftplugin/` | Per-filetype settings/functions, loaded after plugins |
| `dot_vim/autoload/twiddlecase.vim` | Case-cycling helper for the `~` visual mapping |
| `dot_vim/syntax/` | Custom syntax for navi (`.cheat`), prr (`.prr`), risor (`.risor`) |
| `~/.vim/vimrc.local` | Gitignored per-host overrides, sourced at end of vimrc |

### Conventions

- **Leader** is `,`
- Indentation defaults to 2 spaces; some ftplugins override (ledger uses 4)
- Buffer-local mappings/settings/functions for a filetype go in
  `dot_vim/after/ftplugin/<ft>.vim`

### Ledger ftplugin

`dot_vim/after/ftplugin/ledger.vim` has Python3-backed helpers (need Vim with
`+python3`) with buffer-local mappings:

| Mapping | Function | What it does |
|---------|----------|-------------|
| `<Leader>e` | `LedgerEvaluateExpression` | Evaluate inline math on the current split line |
| `<Leader>m` | `LedgerMergeNextLine` | Sum the line below into the current split, delete it |
| `<Leader>d` (visual) | `LedgerDistributeProportional` | Proportionally distribute the last selected line's amount across the preceding splits |

It also has account-navigation helpers (`LedgerLocListByAccount`,
`LedgerFzfAccounts`, `LedgerWatchAccount`).
