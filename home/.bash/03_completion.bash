#!/bin/bash

if [[ -f /usr/local/etc/bash_completion ]]; then
	. /usr/local/etc/bash_completion
fi

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
