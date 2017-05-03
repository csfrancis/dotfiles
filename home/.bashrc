#!/bin/bash

for file in ~/.bash/*.bash; do
	source $file
done

unset DISPLAY


# load dev, but only if present and the shell is interactive
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

export PATH="$HOME/.yarn/bin:$PATH"
