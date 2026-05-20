#!/bin/bash

command -v gpgconf &>/dev/null || return 0

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
