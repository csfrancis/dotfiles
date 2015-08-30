#!/bin/bash

if ls --version | grep -q GNU; then
	alias ls='ls --color=auto'
else
	alias ls='ls -G'
fi

