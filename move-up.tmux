#!/usr/bin/env bash

tmux -L $TMUX_PARENT run-shell "$TPM_PLUGIN_DIR/inactive-row.tmux"
source $TPM_PLUGIN_DIR/active-row.tmux
