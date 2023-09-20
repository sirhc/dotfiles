if (( $+commands[terraform] )); then
    alias tf='terraform'

    alias tfa='terraform apply'
    alias tfd='terraform destroy'
    alias tff='terraform fmt'
    alias tfi='terraform init'
    alias tfo='terraform output'
    alias tfp='terraform plan'
    alias tfv='terraform validate'

    alias tfs='terraform state'
    alias tfsl='terraform state list'
    alias tfsm='terraform state mv'
    alias tfsl='terraform state pull'
    alias tfsp='terraform state push'
    alias tfsr='terraform state replace-provider'
    alias tfsd='terraform state rm'
    alias tfss='terraform state show'

    alias tfw='terraform workspace'
    alias tfwd='terraform workspace delete'
    alias tfwl='terraform workspace list'
    alias tfwn='terraform workspace new'
    alias tfwr='terraform workspace select default'
    alias tfws='terraform workspace select'
    alias tfww='terraform workspace show'

    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
fi

if (( $+commands[terragrunt] )); then
    alias tg='terragrunt'

    alias tga='terraform apply'
    alias tgp='terraform plan'

    # autoload -U +X bashcompinit && bashcompinit
    # complete -o nospace -C terragrunt terragrunt
fi
