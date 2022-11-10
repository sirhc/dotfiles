SHELL         = /bin/zsh
CURL          = curl -fsSL
LIB_DIR       = zsh/dot-zshrc.d/lib
FUNCTIONS_DIR = zsh/dot-zshrc.d/functions
PLUGINS_DIR   = zsh/dot-zshrc.d/plugins

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
	$(CURL) https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/git.zsh                      > $(LIB_DIR)/git.zsh

update-functions:
	$(CURL) https://raw.githubusercontent.com/AlexaraWu/zsh-completions/master/src/_7z                > $(FUNCTIONS_DIR)/_7z
	$(CURL) https://raw.githubusercontent.com/exercism/cli/main/shell/exercism_completion.zsh         > $(FUNCTIONS_DIR)/_exercism
	$(CURL) https://raw.githubusercontent.com/sirhc/myrepos.plugin.zsh/main/_myrepos                  > $(FUNCTIONS_DIR)/_myrepos
	$(CURL) https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/_terraform     > $(FUNCTIONS_DIR)/_terraform
	$(CURL) https://raw.githubusercontent.com/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt   > $(FUNCTIONS_DIR)/_terragrunt

update-plugins:
	$(CURL) https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       > $(PLUGINS_DIR)/aws/aws.plugin.zsh
	$(CURL) https://raw.githubusercontent.com/tj/git-extras/master/etc/git-extras-completion.zsh      > $(PLUGINS_DIR)/git-extras/git-extras.plugin.zsh
	$(CURL) https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       > $(PLUGINS_DIR)/git/git.plugin.zsh
	$(CURL) https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh > $(PLUGINS_DIR)/screen/screen.plugin.zsh
	$(CURL) https://raw.githubusercontent.com/rupa/z/master/z.sh                                      > $(PLUGINS_DIR)/z/z.plugin.zsh
