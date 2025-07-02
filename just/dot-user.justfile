# vim: ft=just

set shell := ["zsh", "-cu"]
set dotenv-load
set quiet

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
  printf '%s\n' */.git(D/:h) | parallel 'rg -F -q "[{}]" .mrconfig || print {}' | xargs -I % -t mr register % 2> /dev/null || :

_branches:
  mr -j{{ njobs }} run command -- zsh -c 'git rev-parse --abbrev-ref HEAD origin/HEAD' | sed -e 's,mr run: .*/,,' -e 's,^origin/,,' -e '/^$/d' | paste -d , - - -

_clone:
  parallel '[[ -d "$( basename {} )" ]] || gh repo clone {}'

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
  cd && mr --minimal --jobs 8 update
  if [[ {{ os() }} = macos ]]; then {{ just }} brew; fi
  if [[ {{ os() }} = linux ]]; then print TODO: Add dnf target; fi

brew_dir := "/opt/homebrew/Library/Taps/homebrew/homebrew-core"

# Upgrade Homebrew packages
[macos]
[group("brew")]
brew: && _brew_new_formula
  brew update
  if ! brew outdated {{ brew_overlap }}; then {{ just }} _brew_unlink; brew upgrade --greedy; {{ just }} _brew_relink; else brew upgrade --greedy; fi

_brew_unlink:
  brew unlink {{ brew_overlap }}

_brew_relink: _brew_unlink
  brew link --overwrite {{ brew_overlap }}

_brew_new_formula:
  jq --argjson a "$( {{ just }} _brew_recent_formula_date )" --argjson b "$( {{ just }} _brew_recent_formula_info )" -n '$a + $b | group_by(.name) | map(add)' \
    | mlr --j2p sort -r date -n name

_brew_recent_formula:
  #!/usr/bin/env -S zsh -e
  git -C {{ brew_dir }} log --since="$( gdate --date 'last week' +'%Y-%m-%d')" --name-status --diff-filter=A Formula |
    grep -E '^(Date:|A\t)' |
    awk '
      ( $1 == "Date:" ) { sub(/^Date: */, ""); date = $0 }
      ( $1 == "A" )     { print $2, date }
    ' |
    sed -e 's,^.*/,,' -e 's/\.rb / /' -e 's/ .[0-9]*$//'

_brew_recent_formula_date:
  #!/usr/bin/env -S zsh -e
  {{ just }} _brew_recent_formula |
    while read -r formula date; do
      printf '{ "name": "%s", "date": "%s" }\n' $formula $( gdate --date=$date +%Y-%m-%d )
    done |
    jq -s .

_brew_recent_formula_info:
  {{ just }} _brew_recent_formula | cut -d ' ' -f 1 | xargs brew info --json | jq '. | map( { name, desc, homepage } )'
