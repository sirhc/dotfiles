if (( $+commands[wd.sh] )); then
    wd() {
        source "$(command -v wd.sh)"
    }
fi
