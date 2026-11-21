#!/bin/bash

[[ -S $HOME/.ssh/agent.sock ]] && export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

