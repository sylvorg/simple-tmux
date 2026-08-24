#!/usr/bin/env bash

source $TPM_PLUGIN_DIR/new-base.tmux

tmux -L "r$RANDOM"
