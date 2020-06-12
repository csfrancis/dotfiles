. ~/.bashrc
if [[ -f /opt/dev/dev.sh ]]; then
  source /opt/dev/dev.sh
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/scott/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/scott/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/scott/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/scott/Downloads/google-cloud-sdk/completion.bash.inc'
fi
if [ -e /Users/scott/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/scott/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export BASH_SILENCE_DEPRECATION_WARNING=1
