# ~/.vim

This is my Vim runtime configuration, a culmination of a couple decade's worth
of cruft that I have periodically maintained. At some point in the past—the
afternoon of Saturday, 23 November 2013 according to this commit history—I
decided that it would behoove me to track changes. At least, it would be
beneficial to give myself a way of making major changes without the clutter of
commenting out blocks of code or leaving around files with names like
`vimrc.test42`.

It once lived in its own `~/.vim` repository; that history was imported into my
[dotfiles](https://github.com/sirhc/dotfiles) repo, where it now lives as the
`dot_vim/` source directory managed by [chezmoi](https://www.chezmoi.io/).
Running `chezmoi apply` deploys it to `~/.vim`.

This configuration is self-contained and should work without any changes.
Obviously, it's highly opinionated and I don't recommend anyone use it as-is.

## Plugins

With the advent of Vim 8 and its native package system, I switched over from
[Pathogen](https://github.com/tpope/vim-pathogen). The plugins themselves aren't
committed here — they're declared as git-repo externals in the dotfiles repo's
`.chezmoiexternal.toml` and cloned into `~/.vim/pack/` by `chezmoi apply`.
