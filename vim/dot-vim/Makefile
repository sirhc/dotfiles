SHELL = zsh

all:

helptags:
	vim -c 'helptags ALL' -c quit

check-config:
	find pack/ -type d -name .git -exec $(SHELL) -c 'mr config "$$( realpath "$$( dirname "{}" )" )" checkout 1> /dev/null' \;

# Check to see how long ago the plugin was last updated.
last-updated:
	mr lastUpdated |& "$${PAGER:-less}"
