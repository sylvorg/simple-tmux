#!/usr/bin/env bash

# # Adapted From:
# # Answer: https://stackoverflow.com/a/45201229
# # User: https://stackoverflow.com/users/4272464/bgoldst
# readarray -t sockets <<< "$(lsof -Uu "$USERNAME" | rg "$(dirname $TMUX)" | gawk '{ print $9 }' | uniq)"

# # Adapted From:
# # Answer: https://stackoverflow.com/a/18468510
# # User: https://stackoverflow.com/users/2235132/devnull
# { for socket in "${sockets[@]}"
#   do
#     readarray -t sessions <<< "$(tmux -S "$socket" list-sessions | gawk '{ print $1 }')"
#     for session in "${sessions[@]}"
#     do
#       session=${session%%:*}
#       if [[ "$session" = "$1" ]]; then
#         . $TPM_PLUGIN_DIR/new-tmux-base.tmux "$socket" "$session"
#         ! break
#       fi
#     done
#   done } && . $TPM_PLUGIN_DIR/new-smug-base.tmux "$1"

. $TPM_PLUGIN_DIR/new-smug-base.tmux "$1"
