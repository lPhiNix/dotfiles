#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIST="$SCRIPT_DIR/extensions.txt"

if [[ ! -f "$LIST" ]]; then
    echo "Error: no se encuentra $LIST" >&2
    exit 1
fi

xargs -L1 code --install-extension < "$LIST"
