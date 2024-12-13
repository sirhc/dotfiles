# vim: ft=just

set shell := ["zsh", "-cu"]
set dotenv-load
set quiet

just  :=  "just --justfile " + justfile() + " --working-directory " + invocation_directory()
njobs := num_cpus()

# These packages have overlapping links.
brew_overlap := "moreutils parallel terraform tfenv"

_all:
  {{ just }} --list

# Show repositories currently checked out on non-default branches
[group("myrepos")]
branches:
  {{ just }} _branches | mlr --c2p --hi label 'Repository,Branch,DefaultBranch' then filter -e '$Branch != $DefaultBranch'

# Clone all repositories from a GitHub user or organization
[group("myrepos")]
clone: && register
  {{ just }} _repos | {{ just }} _clone
  {{ just }} _repos true | {{ just }} _clone

# Register all repositories in the current directory
[group("myrepos")]
register:
  touch .mrconfig
  printf '%s\n' */.git(D/:h) | parallel 'rg -F -q "[{}]" .mrconfig || print {}' | xargs -I % mr register % 2> /dev/null || :

_branches:
  mr -j{{ njobs }} run command -- zsh -c 'git rev-parse --abbrev-ref HEAD origin/HEAD' | sed -e 's,mr run: .*/,,' -e 's,^origin/,,' -e '/^$/d' | paste -d , - - -

_clone:
  parallel '[[ -d "$( basename {} )" ]] || gh repo clone {}'

_repos isFork="false" owner=file_name(invocation_directory()):
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

brew_dir := "/opt/homebrew/Library/Taps/homebrew/homebrew-core"

# Upgrade Homebrew packages
[macos]
[group("brew")]
brew:
  brew update
  if ! brew outdated {{ brew_overlap }}; then {{ just }} _brew_unlink; brew upgrade --greedy; {{ just }} _brew_relink; else brew upgrade --greedy; fi

  # Show information about Homebrew formula added in the last week
  jq --argjson a "$( {{ just }} _brew_new_formula_date )" --argjson b "$( {{ just }} _brew_new_formula_info )" -n '$a + $b | group_by(.name) | map(add)' \
    | mlr --j2p sort -r date -n name

_brew_unlink:
  brew unlink {{ brew_overlap }}

_brew_relink: _brew_unlink
  brew link --overwrite {{ brew_overlap }}

_brew_new_formula:
  git -C {{ brew_dir }} log --since="$( gdate --date 'last week' +'%Y-%m-%d')" --name-status --diff-filter=A Formula | awk '($1 == "A") { print $2 }' | sort

_brew_new_formula_date:
  {{ just }} _brew_new_formula \
    | xargs -I @ git -C {{ brew_dir }} log -n 1 --format='{ "name": "@", "date": "%cs" }' @ \
    | jq -s '. | map( .name |= sub("^.*/"; "") | .name |= sub(".rb$"; "") )'

_brew_new_formula_info:
  {{ just }} _brew_new_formula | xargs -I @ basename @ .rb | xargs brew info --json | jq '. | map( { name, desc, homepage } )'
