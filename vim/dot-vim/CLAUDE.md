# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Vim runtime configuration (`~/.vim`). The repo contains the vimrc, filetype detection, ftplugin overrides, custom syntax files, and one autoload utility. Plugin binaries are **not** tracked — they live under `pack/` which is gitignored and managed separately via [myrepos](https://myrepos.branchable.com/).

## Plugin management

Plugins are declared in `.mrconfig` and installed/updated with:

```
mr update        # install or pull all plugins
```

After adding or updating plugins, regenerate helptags:

```
make helptags
```

To audit which plugins haven't been updated recently:

```
make last-updated
```

To verify `.mrconfig` entries match what's actually checked out under `pack/`:

```
make check-config
```

## Repo structure

| Path | Purpose |
|------|---------|
| `vimrc` | Main configuration — settings, key maps, plugin config |
| `vimrc.local` | Host-specific overrides (gitignored; loaded at end of vimrc) |
| `filetype.vim` | Custom filetype detection rules |
| `after/ftplugin/` | Per-filetype settings and functions, loaded after plugins |
| `autoload/twiddlecase.vim` | Case-cycling helper used by the `~` visual mapping |
| `syntax/` | Custom syntax files for navi (`.cheat`), prr (`.prr`), and risor (`.risor`) |
| `pack/` | Vim 8 native packages, gitignored, managed by myrepos |

## Key conventions

- **Leader** is `,`
- **Indentation** defaults to 2 spaces (some ftplugins override, e.g. ledger uses 4)
- Plugin config lives in `vimrc` near the plugin's section, not in separate files
- ftplugin files under `after/ftplugin/` are the right place for buffer-local mappings, settings, and functions for a given filetype
- `vimrc.local` is for per-host tweaks (e.g. adjusting VimWiki diary frequency); it is gitignored

## Ledger ftplugin

`after/ftplugin/ledger.vim` contains three Python3-backed functions with buffer-local mappings:

| Mapping | Function | What it does |
|---------|----------|-------------|
| `<Leader>e` | `LedgerEvaluateExpression` | Evaluates inline math on the current split line |
| `<Leader>m` | `LedgerMergeNextLine` | Sums the line below into the current split and deletes it |
| `<Leader>d` (visual) | `LedgerDistributeProportional` | Proportionally distributes the last selected line's amount across the preceding splits |

These require Vim compiled with `+python3`.

## Copilot

Copilot is enabled by default but explicitly disabled for `ledger` and `vimwiki` filetypes. In VimWiki buffers, `<C-J>` accepts Copilot suggestions (since VimWiki claims `<Tab>` for table navigation).
