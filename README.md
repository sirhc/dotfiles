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

## Zsh Plugins

For the plugins that aren't captured in
[`.mrconfig`](zsh/dot-zshrc.d/plugins/.mrconfig) (i.e., those I copied from
somewhere), this documents where they came from. Plugins I wrote or maintain
myself are not listed here.

| Plugin | Source |
| ------ | ------ |
| [`aws`](zsh/dot-zshrc.d/plugins/aws/aws.plugin.zsh) | <https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh> |
| [`git`](zsh/dot-zshrc.d/plugins/git/git.plugin.zsh) | <https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh> |
| [`screen`](zsh/dot-zshrc.d/plugins/screen/screen.plugin.zsh) | <https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh> |
| [`z`](zsh/dot-zshrc.d/plugins/z/z.plugin.zsh) | <https://raw.githubusercontent.com/rupa/z/master/z.sh> |

## Zsh Functions

This documents where the files in
[zsh/dot-zshrc.d/functions](zsh/dot-zshrc.d/functions) came from, so I can
know where to update them later.

| Function | Source |
| -------- | ------ |
| [`_7z`](zsh/dot-zshrc.d/functions/_7z) | <https://raw.githubusercontent.com/AlexaraWu/zsh-completions/master/src/_7z> |
| [`_fd`](zsh/dot-zshrc.d/functions/_fd) | <https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fd/_fd> |
| [`_jira`](zsh/dot-zshrc.d/functions/_jira) | <https://github.com/go-jira/jira> <br /> `jira --completion-script-zsh` |
| [`_myrepos`](zsh/dot-zshrc.d/functions/_myrepos) | <https://raw.githubusercontent.com/sirhc/myrepos.plugin.zsh/main/_myrepos> |
| [`_op`](zsh/dot-zshrc.d/functions/_op) | <https://developer.1password.com/docs/cli/reference/commands/completion> <br /> `op completion zsh` |
| [`_terraform`](zsh/dot-zshrc.d/functions/_terraform) | <https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/_terraform> |
| [`_terragrunt`](zsh/dot-zshrc.d/functions/_terragrunt) | <https://raw.githubusercontent.com/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt> |
