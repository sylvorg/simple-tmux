#!/usr/bin/env bash

source $TPM_PLUGIN_DIR/new-base.tmux

source $TPM_PLUGIN_DIR/new-${1}-base.tmux "${@:2}"
