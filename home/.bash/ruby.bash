#!/bin/bash

chruby() {
  CHRUBY_DIR=/usr/local/opt/chruby/share/chruby
  if [[ -d /usr/local/share/chruby && "${SHOPIFY_DEV_VAGRANT}" != "1" ]]; then
    CHRUBY_DIR=/usr/local/share/chruby
  fi

  if [[ -r "${CHRUBY_DIR}/chruby.sh" ]]; then
    source "${CHRUBY_DIR}/chruby.sh"
    RUBIES=(~/.rubies/*)

    if [[ `hostname -s` != "vagrant" ]]; then
      chruby 2.3.1
    fi

    source "${CHRUBY_DIR}/auto.sh"
  fi
}
