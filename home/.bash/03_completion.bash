#!/bin/bash

if [[ -f /usr/local/etc/bash_completion ]]; then
	. /usr/local/etc/bash_completion
fi

[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
