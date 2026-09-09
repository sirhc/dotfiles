# Customizations layered on top of the externally-pulled Catppuccin Mocha
# p10k theme (~/.p10k.zsh, see .chezmoiexternal.toml). Kept separate so
# `chezmoi update` can refresh the upstream theme without clobbering these.

# Re-declare the right prompt segment list: add jenkins/meeting/email, enable
# terraform_version/time, drop per_directory_history.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  # =========================[ Line #1 ]=========================
  status                  # exit code of the last command
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  direnv                  # direnv status (https://direnv.net/)
  asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
  virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
  anaconda                # conda environment (https://conda.io/)
  pyenv                   # python environment (https://github.com/pyenv/pyenv)
  goenv                   # go environment (https://github.com/syndbg/goenv)
  nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
  nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
  nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
  # node_version          # node.js version
  # go_version            # go version (https://golang.org)
  # rust_version          # rustc version (https://www.rust-lang.org)
  # dotnet_version        # .NET version (https://dotnet.microsoft.com)
  # php_version           # php version (https://www.php.net/)
  # laravel_version       # laravel php framework version (https://laravel.com/)
  # java_version          # java version (https://www.java.com/)
  # package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
  rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
  rvm                     # ruby version from rvm (https://rvm.io)
  fvm                     # flutter version management (https://github.com/leoafarias/fvm)
  luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
  jenv                    # java version from jenv (https://github.com/jenv/jenv)
  plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
  perlbrew                # perl version from perlbrew (https://github.com/gugod/App-perlbrew)
  phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
  scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
  haskell_stack           # haskell version from stack (https://haskellstack.org/)
  kubecontext             # current kubernetes context (https://kubernetes.io/)
  terraform               # terraform workspace (https://www.terraform.io)
  terraform_version       # terraform version (https://www.terraform.io)
  jenkins                 # my jenkins prompt
  aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
  aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
  azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
  gcloud                  # google cloud cli account and project (https://cloud.google.com/)
  google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
  toolbox                 # toolbox name (https://github.com/containers/toolbox)
  context                 # user@hostname
  nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
  ranger                  # ranger shell (https://github.com/ranger/ranger)
  yazi                    # yazi shell (https://github.com/sxyazi/yazi)
  nnn                     # nnn shell (https://github.com/jarun/nnn)
  lf                      # lf shell (https://github.com/gokcehan/lf)
  xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
  vim_shell               # vim shell indicator (:sh)
  midnight_commander      # midnight commander shell (https://midnight-commander.org/)
  nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
  chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
  # vi_mode               # vi mode (you don't need this if you've enabled prompt_char)
  # vpn_ip                # virtual private network indicator
  # load                  # CPU load
  # disk_usage            # disk usage
  # ram                   # free RAM
  # swap                  # used swap
  meeting
  email
  todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
  timewarrior             # timewarrior tracking status (https://timewarrior.net/)
  taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
  # per_directory_history # Oh My Zsh per-directory-history local/global indicator
  # cpu_arch              # CPU architecture
  time                    # current time
  # =========================[ Line #2 ]=========================
  newline
  # ip                    # ip address and bandwidth usage for a specified network interface
  # public_ip             # public IP address
  # proxy                 # system-wide http/https/ftp proxy
  # battery               # internal battery
  # wifi                  # wifi speed
  # example               # example user-defined segment (see prompt_example function below)
)

typeset -g POWERLEVEL9K_TERRAFORM_VERSION_SHOW_ON_COMMAND='terraform|tf'

# Always show the aws segment, regardless of the command being typed.
unset POWERLEVEL9K_AWS_SHOW_ON_COMMAND

#[ jenkins: my jenkins prompt ]#
function prompt_jenkins() {
  if [[ -n ${JENKINS_URL:-} ]]; then
    p10k segment -b 094 -f 7 -i $'\uE767' -t ${${JENKINS_URL#http?://}%%.*}
  fi
}

function instant_prompt_jenkins() {
  prompt_jenkins
}

#[ meeting: next event from ~/.cache/$USER/meeting.txt ]#
function prompt_meeting() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/$USER/meeting.txt"
  local next_event

  if [[ ! -r $cache ]]; then
    return
  fi

  read -r next_event <<<"$( head -1 $cache )"

  if [[ -z $next_event ]]; then
    return
  fi

  # Use the same colors as the macOS Calendar app.
  p10k segment -b '#ECF8FA' -f '#4F7174' -i $'\uF455' -t $next_event
}

function instant_prompt_meeting() {
  prompt_meeting
}

#[ email: unread count from ~/.cache/$USER/mail.json ]#
function prompt_email() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/$USER/mail.json"
  local messages unseen color icon

  if [[ ! -r $cache ]]; then
    return
  fi

  read -r messages unseen <<<"$( jq -r '"\(.messages) \(.unseen)"' "$cache" )"

  if [[ -z $messages ]]; then
    return
  fi

  if [[ $unseen -gt 0 ]]; then
    color='167'  # indianred
    icon=$'\uFBCD'
  else
    color='028'  # green4
    icon=$'\uFAEE'
  fi

  p10k segment -b $color -f 7 -i $icon -t "$unseen/$messages"
}

function instant_prompt_email() {
  prompt_email
}

typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Re-apply overrides if p10k is already loaded (hot reload workflow).
(( ! $+functions[p10k] )) || p10k reload
