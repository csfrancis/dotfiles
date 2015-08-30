#!/bin/bash

if [[ -r /usr/local/opt/chruby/share/chruby/chruby.sh ]]; then
	source /usr/local/opt/chruby/share/chruby/chruby.sh
	RUBIES=(~/.rubies/*)

	chruby 2.2.3

	source /usr/local/opt/chruby/share/chruby/auto.sh
fi

