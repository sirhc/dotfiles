# Here live various lazy-loading functions, to remove any startup time penalty
# from things that may not always be executed for a given shell.

if (( $+commands[pyenv] )); then
    pyenv() {
        unfunction pyenv
        eval "$(pyenv init - --no-rehash zsh)"
        pyenv "$@"
    }
fi

if (( $+commands[jenv] )); then
    jenv() {
        unfunction jenv
        eval "$(jenv init -)"
        jenv "$@"
    }
fi
