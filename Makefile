SHELL = /bin/zsh

all:

install:
	@for f in *(/); do stow --target="$$HOME" --verbose=1 --restow "$$f" --dotfiles; done

uninstall:
	@for f in *(/); do stow --target="$$HOME" --verbose=1 --delete "$$f" --dotfiles; done

update:
	@for f in **/.mrconfig; do \
		printf '\033[1;97mRunning update on %s...\033[m\n' "$$f"; \
		(cd "$${f:h}" && mr -j update); \
		printf '\n'; \
	done

update-functions:
	curl -Ls https://raw.githubusercontent.com/AlexaraWu/zsh-completions/master/src/_7z              > zsh/dot-zshrc.d/functions/_7z
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fd/_fd                 > zsh/dot-zshrc.d/functions/_fd
	curl -Ls https://raw.githubusercontent.com/sirhc/myrepos.plugin.zsh/main/_myrepos                > zsh/dot-zshrc.d/functions/_myrepos
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/_terraform   > zsh/dot-zshrc.d/functions/_terraform
	curl -Ls https://raw.githubusercontent.com/jkavan/terragrunt-oh-my-zsh-plugin/master/_terragrunt > zsh/dot-zshrc.d/functions/_terragrunt

	# https://github.com/go-jira/jira
	which jira >& /dev/null && jira --completion-script-zsh > zsh/dot-zshrc.d/functions/_jira || :

	# https://developer.1password.com/docs/cli/reference/commands/completion
	which op >& /dev/null && op completion zsh > zsh/dot-zshrc.d/functions/_op || :

	# https://github.com/99designs/aws-vault
	which aws-vault >& /dev/null && aws-vault --completion-script-zsh > zsh/dot-zshrc.d/functions/_aws-vault || :

update-plugins:
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/aws/aws.plugin.zsh       > zsh/dot-zshrc.d/plugins/aws/aws.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh       > zsh/dot-zshrc.d/plugins/git/git.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/screen/screen.plugin.zsh > zsh/dot-zshrc.d/plugins/screen/screen.plugin.zsh
	curl -Ls https://raw.githubusercontent.com/rupa/z/master/z.sh                                      > zsh/dot-zshrc.d/plugins/z/z.plugin.zsh
