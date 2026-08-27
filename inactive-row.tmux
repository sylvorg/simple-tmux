#!/usr/bin/env bash

# NOTE: Keeping this at the top prevents losing focus
#       of the active window when pressing M-up and
#       M-left or M-right in quick succession.
# Unbind each unprefixed command
# tmux unbind -n M-left
# tmux unbind -n M-right
# tmux unbind -n M-up
# tmux unbind -n M-down
# # tmux unbind -n C-t
# # tmux unbind -n C-v

tmux unbind -n -a

# TODO: Maybe using `source-file' is preventing the keybindings from reloading?
#       Try using `run-shell' or putting the contents back into `active-row.tmux'.
#       Otherwise, turn this into a script.
tmux bind -n M-F12 run-shell "$TPM_PLUGIN_DIR/move-up.tmux"
tmux bind -n C-M-\\ run-shell "$TPM_PLUGIN_DIR/active-row.tmux"

inactive_window_bg="$(tmux show-options -gqv "@simple-inactive-window-bg")"
inactive_window_bg=${inactive_window_bg:-colour102}
bg="$(tmux show-options -gqv "@tmux-dotbar-bg")"
bg=${bg:-#0B0E14}
maximized_pane_icon="$(tmux show-options -gqv "@tmux-dotbar-maximized-icon")"
maximized_pane_icon=${maximized_pane_icon:-󰊓}

# Change the background color to unactive
if [[ -f "$TPM_PLUGIN_DIR/dotbar.tmux" ]]; then
  if [[ -n "${1:-}" ]]; then
    source "$TPM_PLUGIN_DIR/separator.tmux"
    tmux set -g @tmux-dotbar-status-right-text "${separators[ $RANDOM % ${#separators[@]} ]}"
  fi
  tmux set -g @tmux-dotbar-fg-current "$inactive_window_bg"
  source $TPM_PLUGIN_DIR/dotbar.tmux
else
  tmux setw -g window-status-current-style bg=$inactive_window_bg
fi

prefix="$(tmux show-options -gqv "@simple-prefix")"
prefix=${prefix:-C-z}

# Unbind prefix
tmux set -u -g prefix $prefix

prefix2="$(tmux show-options -gqv "@simple-prefix2")"
prefix2=${prefix2:-C-a}

# Unbind prefix2
tmux set -u -g prefix2 $prefix2
