. ~/.bashrc
if [[ -f /opt/dev/dev.sh ]]; then
  source /opt/dev/dev.sh
  # Hack to get rid of dev's broken `knife` alias
  unalias knife
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/scott/Downloads/tmp/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/scott/Downloads/tmp/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/scott/Downloads/tmp/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/scott/Downloads/tmp/google-cloud-sdk/completion.bash.inc'
fi
