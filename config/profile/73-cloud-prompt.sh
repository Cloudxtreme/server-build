# Openleaf custom changes

# Cloud server prompt changes
if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
    if which git &>/dev/null; then
        __cloudprompt()
        {
          if [ "$(id -u)" != "0" ]; then
                # for non-root users
                # dim colours
                # time
                # show public IP (if set) and full PWD in window title
                # git information
            PS1='\[\e[2m\]\t \[\e]0;\u@${PUBLICIP:-$HOSTNAME}:${PWD}\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1)\$\[\e[0m\] '
          else
                # for root
                # bright colours
                # time
                # show public IP (if set) and full PWD in window title
                # always show complete PWD
            PS1='\[\e[2m\]\t \[\e]0;\u@${PUBLICIP:-$HOSTNAME}:${PWD}\a\]${debian_chroot:+($debian_chroot)}\[\e[0m\]\[\e[1m\]\u@\h:${PWD}\$\[\e[0m\] '
          fi
        }
    else
        __cloudprompt()
        {
          if [ "$(id -u)" != "0" ]; then
                # for non-root users
                # dim colours
                # time
                # show public IP (if set) and full PWD in window title
            PS1='\[\e[2m\]\t \[\e]0;\u@${PUBLICIP:-$HOSTNAME}:${PWD}\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$\[\e[0m\] '
          else
                # for root
                # bright colours
                # time
                # show public IP (if set) and full PWD in window title
                # always show complete PWD
            PS1='\[\e[2m\]\t \[\e]0;\u@${PUBLICIP:-$HOSTNAME}:${PWD}\a\]${debian_chroot:+($debian_chroot)}\[\e[0m\]\[\e[1m\]\u@\h:${PWD}\$\[\e[0m\] '
          fi
        }
    fi
    PROMPT_COMMAND=__cloudprompt
fi