#!/bin/bash

if ls --version | grep -q GNU; then
	alias ls='ls --color=auto'
else
	alias ls='ls -G'
fi

alias bx='bundle exec'

if [[ -d ~/.chef ]]; then
# Disable Ruby warnings for knife
knife() { (cd ~/.chef && RUBYOPT=-W0 bx knife "$@") }
fi

if [[ -d ~/vagrant ]]; then
vssh() { (cd ~/vagrant && vagrant ssh) }
fi

