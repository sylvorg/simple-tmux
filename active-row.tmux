#!/usr/bin/env bash

#
# Colors
#
active_window_bg="$(tmux show-options -gqv "@simple-active-window-bg")"
active_window_bg=${active_window_bg:-colour34}
bar_bg="$(tmux show-options -gqv "@simple-bar-bg")"
bar_bg=${bar_bg:-#0B0E14}
bar_fg="$(tmux show-options -gqv "@simple-bar-fg")"
bar_fg=${bar_fg:-#475266}

#
# General settings
#
tmux set -g default-terminal screen.xterm-256color
tmux set -g status-right ''
tmux set -g history-limit 100000

#
# Configure prefix
#
tmux unbind C-b

prefix="$(tmux show-options -gqv "@simple-prefix")"
prefix=${prefix:-C-z}

# Avoid clobbering common readline bindings which should be very fast, whereas
# backgrounding a process is relatively incommon and the double-prefix is fine.
tmux set -g prefix $prefix

# Pass the prefix through (Ctrl + z, Ctrl + z)
# prefix_send="$(tmux show-options -gqv "@simple-prefix-send")"
# prefix_send=${prefix_send:-true}
# $prefix_send && tmux bind $prefix send-prefix
# tmux bind $prefix send-prefix
# if ! tmux list-keys | rg "(^|\s)$prefix(^|\s)" | rg -q "(^|\s)prefix(^|\s)"; then
#   tmux bind $prefix send-prefix
# fi

prefix2="$(tmux show-options -gqv "@simple-prefix2")"
prefix2=${prefix2:-C-a}

# Avoid clobbering common readline bindings which should be very fast, whereas
# backgrounding a process is relatively incommon and the double-prefix is fine.
tmux set -g prefix2 $prefix2

# Pass the prefix2 through (Ctrl + a, Ctrl + a)
# prefix2_send="$(tmux show-options -gqv "@simple-prefix2-send")"
# prefix2_send=${prefix2_send:-true}
# $prefix2_send && tmux bind $prefix2 send-prefix -2
# tmux bind $prefix2 send-prefix -2
# if ! tmux list-keys | rg "(^|\s)$prefix2(^|\s)" | rg -q "(^|\s)prefix(^|\s)"; then
#   tmux bind $prefix2 send-prefix -2
# fi

tmux source-file "$TPM_PLUGIN_DIR/active-row.conf"

status_position="$(tmux show-options -gqv "@simple-status-position")"
status_position=${status_position:-bottom}

if [[ "$status_position" == "top" ]]; then
  inner="down"
  inner_vim="j"
  outer="up"
  outer_vim="k"
else
  inner="up"
  inner_vim="k"
  outer="down"
  outer_vim="j"
fi

# Switch to inner tmux (Alt + Up)
tmux bind -n M-$inner send-keys M-F12
tmux bind -n M-$inner_vim send-keys M-F12

# Switch to outer tmux (Alt + Down)
# TODO: Do I need to do the same thing as the move-up command?
# TODO: Create a `move-down.tmux' script.
tmux bind -n M-$outer run-shell "$TPM_PLUGIN_DIR/move-down.tmux"
tmux bind -n M-$outer_vim run-shell "$TPM_PLUGIN_DIR/move-down.tmux"

#
# Appearance
#

bold_status=$(tmux show-options -gqv "@tmux-dotbar-bold-status")
bold_status=${bold_status:-false}
fg_session=$(tmux show-options -gqv "@tmux-dotbar-fg-session")
fg_session=${fg_session:-#565B66}
fg_prefix=$(tmux show-options -gqv "@tmux-dotbar-fg-prefix")
fg_prefix=${fg_prefix:-#95E6CB}
base_status_left="$(tmux show-options -gqv "@simple-status-left")"
base_status_left=${base_status_left:-#S}
base_status_right="$(tmux show-options -gqv "@simple-status-right")"
base_status_right=${base_status_right:-#h}
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

if [[ -f "$TPM_PLUGIN_DIR/dotbar.tmux" ]]; then
  tmux set -g @tmux-dotbar-window-status-separator " ${separators[ $RANDOM % ${#separators[@]} ]} "

  tmux set -g @tmux-dotbar-window-status-format " #W "
  tmux set -g @tmux-dotbar-bg "$bar_bg"
  tmux set -g @tmux-dotbar-fg "$bar_fg"
  tmux set -g @tmux-dotbar-fg-current "$active_window_bg"

  # Conditionally apply 'nobold' if @tmux-dotbar-bold-status is true
  if [ "$bold_status" = true ]; then
    status_left="#[bg=$bar_bg,fg=$fg_session]#{?client_prefix,, $base_status_left }#[bg=$fg_prefix,fg=$bar_bg,nobold]#{?client_prefix, $base_status_left ,}#[bg=$bar_bg,fg=${fg_session}]"
  else
    status_left="#[bg=$bar_bg,fg=$fg_session]#{?client_prefix,, $base_status_left }#[bg=$fg_prefix,fg=$bar_bg,bold]#{?client_prefix, $base_status_left ,}#[bg=$bar_bg,fg=${fg_session}]"
  fi

  tmux set -g @tmux-dotbar-status-left "$status_left"

  tmux set -g @tmux-dotbar-right "true"
  tmux set -g @tmux-dotbar-status-right "$base_status_right"
  tmux set -g @tmux-dotbar-position "$status_position"
  . $TPM_PLUGIN_DIR/dotbar.tmux
else
  tmux set -g status-style bg=$bar_bg
  tmux setw -g window-status-style fg=$bar_fg
  tmux setw -g window-status-current-format ' #I #W '
  tmux setw -g window-status-format ' #W '
  tmux setw -g window-status-current-style bg=$active_window_bg
  tmux set -g status-left "$base_status_left"
  tmux set -g status-right "$base_status_right"
  tmux set -g status-position "$status_position"
fi

if [[ -n "$TMUX_PARENT" ]]; then
  # When a new session is created unbind the parent
  tmux -L $TMUX_PARENT run-shell "$TPM_PLUGIN_DIR/inactive-row.tmux"
else
  # If we're the root tmux, unbind M-down
  tmux bind -n M-$outer send-keys ""
  tmux bind -n M-$outer_vim send-keys ""
fi
