#!/usr/bin/env bash

TMUX_PARENT=$(basename "$TMUX")
TMUX_PARENT="${TMUX_PARENT%%,*}"
export TMUX_PARENT

# TODO: Maybe just store the root parent?
if [ -z "${TMUX_PARENTS:-}" ]; then
  TMUX_PARENTS="$TMUX_PARENT"
else
  TMUX_PARENTS+=",$TMUX_PARENT"
fi
export TMUX_PARENTS
