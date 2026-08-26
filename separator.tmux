#!/usr/bin/env bash

separator_bg="$(tmux show-options -gqv "@simple-separator-bg")"
separator_bg=${separator_bg:-$bar_bg}
separator_fg="$(tmux show-options -gqv "@simple-separator-fg")"
separator_fg=${separator_fg:-$bar_fg}
separator="$(tmux show-options -gqv "@simple-separator")"
if [[ -z "$separator" ]]; then
  separator="#[bg=${separator_bg},fg=${separator_fg}]•"
fi
separators="$(tmux show-options -gqv "@simple-separators")"

# Adapted From:
# Answer: https://stackoverflow.com/a/45201229
# User: https://stackoverflow.com/users/4272464/bgoldst
readarray -td \; separators <<< "${separators:-$separator}"
declare -a separators
