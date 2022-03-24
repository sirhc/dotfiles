SHELL = /bin/zsh

all:

install:
	@for f in *(/); do stow -v --dotfiles "$$f"; done

update:
	@for f in **/.mrconfig; do \
		printf '\033[1;97mRunning update on %s...\033[m\n' "$$f"; \
		(cd "$${f:h}" && mr -j update); \
		printf '\n'; \
	done
