#!/bin/bash

if ls --version | grep -q GNU; then
  eval `dircolors ~/.dir_colors`
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

alias bx='bundle exec'

if [[ -d ~/.chef ]]; then
  knife() {(
    [[ -f /opt/dev/dev.sh ]] && source /opt/dev/dev.sh
    cd ~/.chef && BUNDLE_GEMFILE=~/.chef/Gemfile bx knife "$@"
  )}
fi

if [[ -d ~/vagrant ]]; then
  vssh() { (cd ~/vagrant && vagrant ssh) }
fi

alias gpg='gpg2'
alias vim='nvim'
