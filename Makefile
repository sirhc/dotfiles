CURL          = curl -fsSL
FUNCTIONS_DIR = zsh/dot-zshrc.d/functions
GITHUB_RAW    = https://raw.githubusercontent.com
LIB_DIR       = zsh/dot-zshrc.d/lib
PLUGINS_DIR   = zsh/dot-zshrc.d/plugins
SHELL         = /bin/zsh

all:

stow:
	stow --target="$$HOME" --verbose=1 --stow --dotfiles *(/)

unstow:
	stow --simulate --target="$$HOME" --verbose=1 --delete --dotfiles *(/)

update: update-libs update-functions update-plugins

update-repos:
	mr -j4 update
	mr -j4 prune
	mr -j4 gc

update-libs:
	mkdir -p $(LIB_DIR)
	$(CURL) $(GITHUB_RAW)/ohmyzsh/ohmyzsh/master/lib/git.zsh                      > $(LIB_DIR)/git.zsh

update-functions:
	mkdir -p $(FUNCTIONS_DIR)
	$(CURL) $(GITHUB_RAW)/AlexaraWu/zsh-completions/master/src/_7z                > $(FUNCTIONS_DIR)/_7z
	$(CURL) $(GITHUB_RAW)/sirhc/awsvpn-cli/main/completion.zsh                    > $(FUNCTIONS_DIR)/_awsvpn_cli
	$(CURL) $(GITHUB_RAW)/cheat/cheat/master/scripts/cheat.zsh                    > $(FUNCTIONS_DIR)/_cheat
	$(CURL) $(GITHUB_RAW)/exercism/cli/main/shell/exercism_completion.zsh         > $(FUNCTIONS_DIR)/_exercism
	$(CURL) $(GITHUB_RAW)/sirhc/myrepos.plugin.zsh/main/_myrepos                  > $(FUNCTIONS_DIR)/_myrepos
	$(CURL) $(GITHUB_RAW)/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt   > $(FUNCTIONS_DIR)/_terragrunt

update-plugins:
	mkdir -p $(PLUGINS_DIR)/{aws,fzf-completion,git-extras,git,screen}
	$(CURL) $(GITHUB_RAW)/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       > $(PLUGINS_DIR)/aws/aws.plugin.zsh
	$(CURL) $(GITHUB_RAW)/junegunn/fzf/master/shell/completion.zsh                > $(PLUGINS_DIR)/fzf-completion/fzf-completion.plugin.zsh
	$(CURL) $(GITHUB_RAW)/tj/git-extras/master/etc/git-extras-completion.zsh      > $(PLUGINS_DIR)/git-extras/git-extras.plugin.zsh
	$(CURL) $(GITHUB_RAW)/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       > $(PLUGINS_DIR)/git/git.plugin.zsh
	$(CURL) $(GITHUB_RAW)/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh > $(PLUGINS_DIR)/screen/screen.plugin.zsh
