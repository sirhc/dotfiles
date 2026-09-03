# Chris's Dot Files

Managed with [chezmoi](https://www.chezmoi.io/). This repository is the chezmoi
source directory.

```
❯ chezmoi init --apply sirhc
```

or, if the repo is already cloned to `~/.local/share/chezmoi`:

```
❯ chezmoi diff     # preview changes
❯ chezmoi apply    # deploy to $HOME
❯ chezmoi update   # pull latest, then apply
```

Source files use chezmoi's naming convention: `dot_zshrc` → `~/.zshrc`,
`dot_config/bat/config` → `~/.config/bat/config`, and so on.

## Third-party content

Nothing vendored is committed. All of it is declared in
[`.chezmoiexternal.toml`](.chezmoiexternal.toml) and materialized by
`chezmoi apply`:

- **git-repo externals** — full clones: Vim 8 native packages under
  `~/.vim/pack/`, the numbered Zsh plugins under `~/.zshrc.d/plugins/`, and
  powerlevel10k.
- **file externals** — single files pulled from upstream: Zsh completion
  functions (`~/.zshrc.d/functions/_*`), the ohmyzsh `git.zsh` library, and the
  single-file Zsh plugins (`aws`, `fzf-git`, `git`, `git-extras`, `screen`).

To add or remove a plugin or completion, edit `.chezmoiexternal.toml` and run
`chezmoi apply`.

## Committed directly

- My own Zsh completion functions in `dot_zshrc.d/functions/`
- The Zsh config itself (`dot_zshrc`), Vim runtime config (`dot_vim/`), and
  per-tool configs under `dot_config/` and the repo root

## Repo-only files

`CLAUDE.md`, `LICENSE`, and every `README.md` are listed in
[`.chezmoiignore`](.chezmoiignore) so they stay in the repo but are never
deployed to `$HOME`.
