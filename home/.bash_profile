. ~/.bashrc
if [[ -f /opt/dev/dev.sh ]]; then
  source /opt/dev/dev.sh
  # Hack to get rid of dev's broken `knife` alias
  unalias knife
fi
