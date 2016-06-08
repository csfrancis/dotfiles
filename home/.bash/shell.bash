#!/bin/bash

set -o notify

shopt -s nocaseglob

# Fix ctrl-s with command-T in vim
if [[ $- == *i* ]]; then
  stty -ixon > /dev/null 2>&1
fi

export EDITOR=vim
export TERM=screen-256color
export HISTFILESIZE=100000
