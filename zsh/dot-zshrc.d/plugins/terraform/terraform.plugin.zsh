if (( $+commands[terraform] )); then
    alias tf='terraform'
    alias tfa='terraform apply'
    alias tfd='terraform destroy'
    alias tff='terraform fmt'
    alias tfi='terraform init'
    alias tfo='terraform output'
    alias tfp='terraform plan'
    alias tfv='terraform validate'

    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
fi

if (( $+commands[terragrunt] )); then
    alias tg='terragrunt'
fi
