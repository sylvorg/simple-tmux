#!/usr/bin/env bash

source $TPM_PLUGIN_DIR/inactive-row.tmux
tmux -L $TMUX_PARENT run-shell "$TPM_PLUGIN_DIR/active-row.tmux"
