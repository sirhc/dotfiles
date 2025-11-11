set shell := ['zsh', '-cu', '-o', 'pipefail']

curl   := 'curl -fsSL'
github := 'https://raw.githubusercontent.com'

zsh_dir       := 'zsh/dot-zshrc.d'
functions_dir := zsh_dir / 'functions'
plugins_dir   := zsh_dir / 'plugins'
lib_dir       := zsh_dir / 'lib'

_default:

# Stow all of the directories to $HOME
stow:
  stow --target="$HOME" --verbose=1 --stow --dotfiles *(/)

# Un-stow all of the directories to $HOME
unstow:
  stow --target="$HOME" --verbose=1 --delete --dotfiles *(/)

# Update libs, functions, and plugins
update-all: update-libs update-functions update-plugins

# Update Zsh libraries
update-libs:
  mkdir -p {{ lib_dir }}
  {{ curl }} {{ github }}/ohmyzsh/ohmyzsh/master/lib/git.zsh                      -o {{ lib_dir }}/git.zsh

# Update Zsh functions
update-functions:
  mkdir -p {{ functions_dir }}
  {{ curl }} {{ github }}/AlexaraWu/zsh-completions/master/src/_7z                -o {{ functions_dir }}/_7z
  {{ curl }} {{ github }}/sirhc/awsvpn-cli/main/completion.zsh                    -o {{ functions_dir }}/_awsvpn_cli
  {{ curl }} {{ github }}/cheat/cheat/master/scripts/cheat.zsh                    -o {{ functions_dir }}/_cheat
  {{ curl }} {{ github }}/exercism/cli/main/shell/exercism_completion.zsh         -o {{ functions_dir }}/_exercism
  {{ curl }} {{ github }}/sirhc/myrepos.plugin.zsh/main/_myrepos                  -o {{ functions_dir }}/_myrepos
  {{ curl }} {{ github }}/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt   -o {{ functions_dir }}/_terragrunt

# Update Zsh plugins
update-plugins:
  mkdir -p {{ plugins_dir }}/{aws,fzf-completion,fzf-git,git-extras,git,screen}
  {{ curl }} {{ github }}/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       -o {{ plugins_dir }}/aws/aws.plugin.zsh
  {{ curl }} {{ github }}/junegunn/fzf/master/shell/completion.zsh                -o {{ plugins_dir }}/fzf-completion/fzf-completion.plugin.zsh
  {{ curl }} {{ github }}/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh          -o {{ plugins_dir }}/fzf-git/fzf-git.plugin.zsh
  {{ curl }} {{ github }}/tj/git-extras/master/etc/git-extras-completion.zsh      -o {{ plugins_dir }}/git-extras/git-extras.plugin.zsh
  {{ curl }} {{ github }}/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       -o {{ plugins_dir }}/git/git.plugin.zsh
  {{ curl }} {{ github }}/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh -o {{ plugins_dir }}/screen/screen.plugin.zsh
