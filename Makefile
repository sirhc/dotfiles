SHELL = /bin/zsh

all:

install:
	@for f in *(/); do stow -v --dotfiles "$$f"; done
	done
