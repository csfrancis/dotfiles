if [[ `uname -s` == "Linux" ]]; then
  alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
  complete -F _quilt_completion $_quilt_complete_opt dquilt
fi
