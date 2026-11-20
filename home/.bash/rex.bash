#!/bin/bash

# Rex CLI. The Rex terminal adds this to PATH itself; this covers shells started
# outside it. "Current" follows Rex Server updates.
rex_bin="$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS"

if [[ -d "$rex_bin" && ":$PATH:" != *":$rex_bin:"* ]]; then
	export PATH="$PATH:$rex_bin"
fi

unset rex_bin
