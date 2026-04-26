#!/usr/bin/env bash

# Adapted From:
# Answer: https://unix.stackexchange.com/a/545935
# User: user341374
tmux -L "r$RANDOM" new-session \; send "smug start '$1' -a" Enter
# tmux -L "r$RANDOM" new-session \; send "smug start '$1' -i && exit" Enter
