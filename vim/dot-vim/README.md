# ~/.vim

This is my Vim runtime configuration, a culmination of a couple decade's worth
of cruft that I have periodically maintained. At some point in the past—the
afternoon of Saturday, 23 November 2013 according to this commit history—I
decided that it would behoove me to track changes. At least, it would be
beneficial to give myself a way of making major changes without the clutter of
commenting out blocks of code or leaving around files with names like
`vimrc.test42`.

This directory is more-or-less self-contained and should work without any
changes. Obviously, this is my highly-opinionated configuration and I don't
recommend anyone use it as-is.

## Plugins

With the advent of Vim 8 and its native package system, I switched over from
[Pathogen](https://github.com/tpope/vim-pathogen). For hopefully obvious
reasons, I don't include the plugins I use in this repository.

I maintain a `.mrconfig` file with the list of plugins I currently use with
Vim. The plugins can then be installed and maintained using
[myrepos](https://myrepos.branchable.com/).

```
> cd ~/.vim
> mr update
```

The current list of plugins are documented in [Plugins](Plugins.md).
