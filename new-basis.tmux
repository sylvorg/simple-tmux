#!/usr/bin/env bash

. $TPM_PLUGIN_DIR/new-base.tmux

. $TPM_PLUGIN_DIR/new-${1}-base.tmux "${@:2}"
