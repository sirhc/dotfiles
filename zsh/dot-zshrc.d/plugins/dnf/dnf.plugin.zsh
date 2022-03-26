if (( $+commands[dnf] )); then
    alias dnfgl='dnf grouplist'      # list package groups
    alias dnfl='dnf list'            # list packages
    alias dnfli='dnf list installed' # list installed packages
    alias dnfmc='dnf makecache'      # generate metadata cache
    alias dnfp='dnf info'            # show package information
    alias dnfs='dnf search'          # search package

    alias dnfc='sudo dnf clean all'     # clean cache
    alias dnfgi='sudo dnf groupinstall' # install package group
    alias dnfgr='sudo dnf groupremove'  # remove package group
    alias dnfi='sudo dnf install'       # install package
    alias dnfr='sudo dnf remove'        # remove package
    alias dnfu='sudo dnf upgrade'       # upgrade package
fi
