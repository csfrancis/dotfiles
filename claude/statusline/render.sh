#!/bin/bash
# Claude Code status line: fills ./template with the session JSON Claude Code pipes in.
#   render.sh            render (what Claude Code runs)
#   render.sh --fields   list every field in the latest session JSON, with its value
#   render.sh --time     time a render of the latest session JSON with the current template
# Syntax and fields: README.md next to this file.

dir=${BASH_SOURCE[0]%/*}
[ "$dir" = "${BASH_SOURCE[0]}" ] && dir=.
template=$dir/template
last=$dir/last-input.json

case $1 in
--fields)
  jq -r 'paths(scalars) as $p | "\($p | map(tostring) | join("."))\t\(getpath($p) | tojson)"' "$last" | column -t -s $'\t'
  echo
  echo "Also: now (current time), git.branch git.markers git.staged git.unstaged git.untracked git.ahead git.behind"
  exit ;;
--time)
  n=${2:-50}
  start=$(perl -MTime::HiRes=time -e 'printf "%.0f", time*1000')
  for ((i = 0; i < n; i++)); do bash "$0" < "$last" > /dev/null; done
  end=$(perl -MTime::HiRes=time -e 'printf "%.0f", time*1000')
  echo "$(( (end - start) / n )) ms per render (average of $n)"
  exit ;;
esac

input=$(cat)
printf '%s' "$input" > "$last"

[ -f "$template" ] || { printf 'statusline: no template at %s' "$template"; exit; }
tpl=$(<"$template")

# git only runs when the template asks for a git field; one command gives all of them.
gitraw=
if [[ $tpl == *'{git.'* ]]; then
  cwd=$PWD
  [[ $input =~ \"current_dir\":\ ?\"([^\"]*)\" ]] && cwd=${BASH_REMATCH[1]}
  gitraw=$(git --no-optional-locks -C "$cwd" status --porcelain=v2 --branch 2>/dev/null)
fi

printf '%s' "$input" | jq -rj --arg tpl "$tpl" --arg gitraw "$gitraw" -f "$dir/render.jq" 2>/dev/null \
  || printf 'statusline: template error (run: bash %s/render.sh < %s)' "$dir" "$last"
