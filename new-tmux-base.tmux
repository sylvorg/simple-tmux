#!/usr/bin/env bash

# Adapted From:
# Answer: https://superuser.com/a/828730
# User: https://superuser.com/users/89018/paul
if [[ -S "$1" ]]; then

  tmux -S "$1" attach -t "$2"
else
  tmux -L "$1" attach -t "$2"
fi
