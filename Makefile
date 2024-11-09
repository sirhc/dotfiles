SHELL     = /usr/bin/env zsh

CURL      = curl -fsSL
GITHUB    = https://raw.githubusercontent.com

TOP       = zsh/dot-zshrc.d
FUNCTIONS = $(TOP)/functions
PLUGINS   = $(TOP)/plugins
LIB       = $(TOP)/lib

all:

stow:
	stow --target='$(HOME)' --verbose=1 --stow --dotfiles *(/)

unstow:
	stow --target='$(HOME)' --verbose=1 --delete --dotfiles *(/)

update: libs functions plugins

libs: _dirs
	$(CURL) $(GITHUB)/ohmyzsh/ohmyzsh/master/lib/git.zsh                      > $(LIB)/git.zsh

functions: _dirs
	$(CURL) $(GITHUB)/AlexaraWu/zsh-completions/master/src/_7z                > $(FUNCTIONS)/_7z
	$(CURL) $(GITHUB)/sirhc/awsvpn-cli/main/completion.zsh                    > $(FUNCTIONS)/_awsvpn_cli
	$(CURL) $(GITHUB)/cheat/cheat/master/scripts/cheat.zsh                    > $(FUNCTIONS)/_cheat
	$(CURL) $(GITHUB)/exercism/cli/main/shell/exercism_completion.zsh         > $(FUNCTIONS)/_exercism
	$(CURL) $(GITHUB)/sirhc/myrepos.plugin.zsh/main/_myrepos                  > $(FUNCTIONS)/_myrepos
	$(CURL) $(GITHUB)/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt   > $(FUNCTIONS)/_terragrunt

plugins: _dirs
	$(CURL) $(GITHUB)/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       > $(PLUGINS)/aws/aws.plugin.zsh
	$(CURL) $(GITHUB)/junegunn/fzf/master/shell/completion.zsh                > $(PLUGINS)/fzf-completion/fzf-completion.plugin.zsh
	$(CURL) $(GITHUB)/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh          > $(PLUGINS)/fzf-git/fzf-git.plugin.zsh
	$(CURL) $(GITHUB)/tj/git-extras/master/etc/git-extras-completion.zsh      > $(PLUGINS)/git-extras/git-extras.plugin.zsh
	$(CURL) $(GITHUB)/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       > $(PLUGINS)/git/git.plugin.zsh
	$(CURL) $(GITHUB)/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh > $(PLUGINS)/screen/screen.plugin.zsh

_dirs:
	mkdir -p $(LIB) $(FUNCTIONS) $(PLUGINS)/{aws,fzf-completion,fzf-git,git-extras,git,screen}
