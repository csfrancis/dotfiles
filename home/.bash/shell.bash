#!/bin/bash

set -o notify

shopt -s nocaseglob

# Fix ctrl-s with command-T in vim
if [[ $- == *i* ]]; then
  stty -ixon
fi

export EDITOR=vim
export TERM=screen-256color
export HISTFILESIZE=100000
