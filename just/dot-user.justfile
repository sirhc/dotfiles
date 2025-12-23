# vim: ft=just

set shell := ["zsh", "-cu"]
set dotenv-load
set quiet

alias up := update

just  :=  "just --justfile " + justfile() + " --working-directory " + invocation_directory()
njobs := num_cpus()

_default:

# Show repositories currently checked out on non-default branches
[group("myrepos")]
branches:
  {{ just }} _branches | mlr --c2p --hi label 'Repository,Branch,DefaultBranch' then filter -e '$Branch != $DefaultBranch'

# Clone all repositories from a GitHub user or organization
[group("myrepos")]
clone owner=file_name(invocation_directory()): && register
  {{ just }} _repos {{ owner }} | {{ just }} _clone

# Clone all forked repositories from a GitHub user or organization
[group("myrepos")]
clone-forks owner=file_name(invocation_directory()): && register
  {{ just }} _repos {{ owner }} true | {{ just }} _clone

# Register all repositories in the current directory
[group("myrepos")]
register:
  test -f .mrconfig
  printf '%s\n' */.git(D/:h) | xargs -I % -P 0 zsh -c 'rg -F -q "[%]" .mrconfig || print %' | xargs -I % -t mr register % 2> /dev/null || :

_branches:
  mr -j{{ njobs }} run command -- zsh -c 'git rev-parse --abbrev-ref HEAD origin/HEAD' | sed -e 's,mr run: .*/,,' -e 's,^origin/,,' -e '/^$/d' | paste -d , - - -

_clone:
  xargs -I % -P 0 zsh -c '[[ -d ../% ]] || print %' | xargs -L 1 -P 0 -t gh repo clone

_repos owner isFork="false":
  #!/usr/bin/env -S zsh -e
  gh api graphql --paginate -q '.data.repositoryOwner.repositories.nodes[] | .nameWithOwner' -F owner='{{ owner }}' -F isFork='{{ isFork }}' -f query='
    query($owner: String! $isFork: Boolean! $endCursor: String) {
      repositoryOwner(login: $owner) {
        repositories(first: 100 ownerAffiliations: OWNER isFork: $isFork orderBy: { field: NAME direction: ASC } after: $endCursor) {
          pageInfo { hasNextPage endCursor }
          nodes { nameWithOwner }
        }
      }
    }
  '

update:
  print $'\x1b[34m==>\x1b[0m \x1b[1mUpdating repositories...\x1b[0m'
  cd && mr --minimal --jobs 8 update
  if [[ {{ os() }} = linux ]]; then {{ just }} dnf; fi
  if [[ {{ os() }} = macos ]]; then {{ just }} brew; fi

[linux]
[group("dnf")]
dnf:
  print $'\x1b[34m==>\x1b[0m \x1b[1mUpdating packages...\x1b[0m'
  sudo dnf upgrade --refresh --exclude=firefox

brew_overlap := "moreutils parallel"  # these packages have overlapping links

# Upgrade Homebrew packages
[macos]
[group("brew")]
brew:
  brew update
  if ! brew outdated {{ brew_overlap }}; then {{ just }} _brew_unlink; brew upgrade --greedy; {{ just }} _brew_relink; else brew upgrade --greedy; fi

[macos]
[group("brew")]
[no-exit-message]
update-certs:
  fd --glob cacert.pem /opt/homebrew/Cellar --exec {{ just }} _update_cert

[no-exit-message]
_update_cert file:
  openssl storeutl -certs -text -noout '{{ file }}' | grep Issuer: | grep -q CN=LookoutSSE_ForwardProxy_tealium
  print "Updating {{ file }}"
  security find-certificate -c LookoutSSE_ForwardProxy_tealium -p /Library/Keychains/System.keychain >> '{{ file }}'

_brew_unlink:
  brew unlink {{ brew_overlap }}

_brew_relink: _brew_unlink
  brew link --overwrite {{ brew_overlap }}
