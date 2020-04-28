all:

install:
	@for i in *; do \
		if [[ -d $$i ]]; then \
			stow -v --dotfiles "$$i"; \
		fi; \
	done
