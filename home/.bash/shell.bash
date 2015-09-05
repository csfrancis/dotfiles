#!/bin/bash

set -o notify

shopt -s nocaseglob

if [[ "${TERM_PROGRAM}" == "iTerm.app" ]]; then
  # Fix ctrl-s with command-T in vim
  stty -ixon
fi

export EDITOR=vim
export TERM=screen-256color
export HISTFILESIZE=100000
