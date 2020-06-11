#!/bin/bash

if [[ -d /usr/local/sbin ]]; then
	export PATH="/usr/local/sbin:$PATH"
fi

if [[ -d /usr/local/bin ]]; then
	export PATH="/usr/local/bin:$PATH"
fi

export GOPATH=~

if [[ -d "${GOPATH}" ]]; then
	export PATH="$PATH:$GOPATH/bin"
fi

