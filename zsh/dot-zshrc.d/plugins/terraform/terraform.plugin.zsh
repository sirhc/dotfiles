if (( $+commands[terraform] )); then
    alias tf='terraform'
    alias tfa='terraform apply'
    alias tfd='terraform destroy'
    alias tff='terraform fmt'
    alias tfi='terraform init'
    alias tfo='terraform output'
    alias tfp='terraform plan'
    alias tfv='terraform validate'
fi
