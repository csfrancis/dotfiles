#!/bin/bash

set -o notify
set -o vi

shopt -s nocaseglob
shopt -s cmdhist
shopt -s globstar
shopt -s histappend

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '

PROMPT_COMMAND='history -a'

# Fix ctrl-s with command-T in vim
if [[ $- == *i* ]]; then
  stty -ixon > /dev/null 2>&1
fi

export EDITOR=vim
export TERM=xterm-256color
