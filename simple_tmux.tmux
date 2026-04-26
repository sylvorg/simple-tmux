#!/usr/bin/env bash

export TPM_PLUGIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux run-shell "$TPM_PLUGIN_DIR/active-row.tmux"
