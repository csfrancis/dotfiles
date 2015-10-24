#!/bin/bash

CHRUBY_DIR=/usr/local/opt/chruby/share/chruby
if [[ -d /usr/local/share/chruby ]]; then
  CHRUBY_DIR=/usr/local/share/chruby
fi

if [[ -r "${CHRUBY_DIR}/chruby.sh" ]]; then
	source "${CHRUBY_DIR}/chruby.sh"
	RUBIES=(~/.rubies/*)

	chruby 2.2.3

	source "${CHRUBY_DIR}/auto.sh"
fi

