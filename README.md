# Chris's Dot Files

This repository is organized to be used with [GNU Stow](https://www.gnu.org/software/stow/).

```
> git clone https://github.com/sirhc/dotfiles.git ~/.dotfiles
> cd ~/.dotfiles
> stow -v --dotfiles zsh  # for example; or bc, tig, ...
```

At the time of writing, Stow does not support using `--dotfiles` with
subdirectories (see <https://github.com/aspiers/stow/issues/33>), so these
have not been converted to use the `dot-*` names.

## Zsh Functions

This documents where the files in
[zsh/dot-zshrc.d/functions](zsh/dot-zshrc.d/functions) came from, so I can
know where to update them later.

| Function | Source |
| -------- | ------ |
| [`_jira`](zsh/dot-zshrc.d/functions/_jira) | <https://github.com/go-jira/jira> <br /> `jira --completion-script-zsh` |
