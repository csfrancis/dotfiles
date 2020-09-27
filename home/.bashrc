#!/bin/bash

unset DISPLAY

# load dev, but only if present and the shell is interactive
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

export PATH="$HOME/.yarn/bin:$PATH"
if [[ -f /Users/scott/src/github.com/Shopify/cloudplatform ]]; then
  for file in /Users/scott/src/github.com/Shopify/cloudplatform/workflow-utils/*.bash; do source ${file}; done
  kubectl-short-aliases
fi

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/scott/.kube/config:/Users/scott/.kube/config.shopify.cloudplatform

for file in ~/.bash/*.bash; do
	source $file
done
