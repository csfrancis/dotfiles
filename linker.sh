#!/bin/bash
# Links everything in home/ to ~/, does sanity checks.
# By Simon Eskildsen (github.com/Sirupsen)

function symlink {
  ln -nsf $1 $2
}

for file in home/.[^.]*; do
  path="$(pwd)/$file"
  base=$(basename $file)
  target="$HOME/$(basename $file)"

  if [[ -h $target && ($(readlink $target) == $path)]]; then
    echo -e "\x1B[90m~/$base is symlinked to your dotfiles.\x1B[39m"
  elif [[ -f $target && $(sha256sum $path | awk '{print $2}') == $(sha256sum $target | awk '{print $2}') ]]; then
    echo -e "\x1B[32m~/$base exists and was identical to your dotfile.  Overriding with symlink.\x1B[39m"
    symlink $path $target
  elif [[ -a $target ]]; then
    read -p "\x1B[33m~/$base exists and differs from your dotfile. Override?  [yn]\x1B[39m" -n 1

    if [[ $REPLY =~ [yY]* ]]; then
      symlink $path $target
    fi
  else
    echo -e "\x1B[32m~/$base does not exist. Symlinking to dotfile.\x1B[39m"
    symlink $path $target
  fi
done

# Claude Code status line. ~/.claude holds other state, so only this folder is linked.
statusline="$HOME/.claude/statusline"
if [[ -d $statusline && ! -h $statusline ]]; then
  echo -e "\x1B[33m~/.claude/statusline is a real folder. Move it aside, then rerun.\x1B[39m"
else
  mkdir -p "$HOME/.claude"
  ln -nsf "$(pwd)/claude/statusline" "$statusline"
  echo -e "\x1B[32m~/.claude/statusline is symlinked to your dotfiles.\x1B[39m"
fi

# Rex terminal config. ~/.config holds other apps' state, so only this folder is linked.
rex="$HOME/.config/rex"
if [[ -d $rex && ! -h $rex ]]; then
  echo -e "\x1B[33m~/.config/rex is a real folder. Move it aside, then rerun.\x1B[39m"
else
  mkdir -p "$HOME/.config"
  ln -nsf "$(pwd)/home/.config/rex" "$rex"
  echo -e "\x1B[32m~/.config/rex is symlinked to your dotfiles.\x1B[39m"
fi
