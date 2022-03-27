SHELL         = /bin/zsh
FUNCTIONS_DIR = zsh/dot-zshrc.d/functions
PLUGINS_DIR   = zsh/dot-zshrc.d/plugins

all:

install:
	@for f in *(/); do stow --target="$$HOME" --verbose=1 --restow "$$f" --dotfiles; done

uninstall:
	@for f in *(/); do stow --target="$$HOME" --verbose=1 --delete "$$f" --dotfiles; done

update:
	@for f in **/.mrconfig; do \
		printf '\033[1;97mRunning update on %s...\033[m\n' "$$f"; \
		(cd "$${f:h}" && mr update); \
		printf '\n'; \
	done

update-functions:
	curl -Ls https://raw.githubusercontent.com/AlexaraWu/zsh-completions/master/src/_7z              > $(FUNCTIONS_DIR)/_7z
	curl -Ls https://raw.githubusercontent.com/sirhc/myrepos.plugin.zsh/main/_myrepos                > $(FUNCTIONS_DIR)/_myrepos
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/_terraform   > $(FUNCTIONS_DIR)/_terraform
	curl -Ls https://raw.githubusercontent.com/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt > $(FUNCTIONS_DIR)/_terragrunt

update-plugins:
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       > $(PLUGINS_DIR)/aws/aws.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       > $(PLUGINS_DIR)/git/git.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh > $(PLUGINS_DIR)/screen/screen.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/rupa/z/master/z.sh                                      > $(PLUGINS_DIR)/z/z.plugin.zsh
