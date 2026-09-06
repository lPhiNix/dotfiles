#!/usr/bin/env bash
#    _          __       ____          __               _
#   (_)__  ___ / /____ _/ / / _____ __/ /____ ___  ___ (_)__  ___  ___
#  / / _ \(_-</ __/ _ `/ / / / -_) \ / __/ -_) _ \(_-</ / _ \/ _ \(_-<
# /_/_//_/___/\__/\_,_/_/_/  \__/_\_\\__/\__/_//_/___/_/\___/_//_/___/
#
# Installs in VS Code all the extensions listed in extensions.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # directory of this script
LIST="$SCRIPT_DIR/extensions.txt"                           # list of extensions to install

# Abort with a notice if the list file is missing
if [[ ! -f "$LIST" ]]; then
    echo "Error: $LIST not found" >&2
    exit 1
fi

# Install each extension from the list (one per line), one at a time
xargs -L1 code --install-extension < "$LIST"
