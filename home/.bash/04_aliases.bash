#!/bin/bash

if ls --version | grep -q GNU; then
  eval `dircolors ~/.dir_colors`
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

alias bx='bundle exec'

if [[ -d ~/.chef ]]; then
  # Disable Ruby warnings for knife
  knife() { (cd ~/.chef && chruby 2.2.3 && BUNDLE_GEMFILE=~/.chef/Gemfile bx knife "$@") }
fi

if [[ -d ~/vagrant ]]; then
  vssh() { (cd ~/vagrant && vagrant ssh) }
fi

