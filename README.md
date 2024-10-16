# Chris's Dot Files

This repository is organized to be used with [GNU Stow](https://www.gnu.org/software/stow/).

```
❯ git clone https://github.com/sirhc/dotfiles.git ~/.dotfiles
❯ cd ~/.dotfiles
❯ stow -v --dotfiles zsh  # for example; or bc, tig, …
```

## Zsh Functions and Plugins

There are three classes of [functions](zsh/dot-zshrc.d/functions) and [plugins](zsh/dot-zshrc.d/plugins) I maintain in
my zsh profile.

1. Stuff I've written myself.
2. Individual files copied from elsewhere (e.g., Oh My Zsh).
3. Full clones of plugins published elsewhere.

The first class is maintained directly in this repository; the second class is maintained by the `update-functions` and
`update-plugins` targets in the [Makefile](Makefile); finally, the third class is maintained in an
[`.mrconfig`](.mrconfig) file.

## Completion Functions

The completion functions I keep in this repository are those I find in other repositories and just want to copy. For
packages that include their own completion functions, I use those. Other packages can generate their own completion
functions, so these can be installed on the system rather than kept here.
