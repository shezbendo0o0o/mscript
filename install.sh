#!/usr/bin/env bash

set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
    exec sudo -E bash "$0" "$@"
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$REPO_DIR/m"

[[ -f "$MAIN_SCRIPT" ]] || {
    echo "ERROR: $MAIN_SCRIPT not found." >&2
    exit 1
}

bash -n "$MAIN_SCRIPT"
chmod 755 "$MAIN_SCRIPT"

mkdir -p /bin/mscript /usr/bin/mscript /usr/local/bin

# Link installed commands directly to the repository
ln -sfn "$MAIN_SCRIPT" /bin/mscript/m
ln -sfn "$MAIN_SCRIPT" /usr/bin/mscript/m

ln -sfn /bin/mscript/m /usr/local/bin/m
ln -sfn /bin/mscript/m /usr/bin/m
ln -sfn /bin/mscript/m /bin/m

echo
echo "[OK] MOU Script installed"
echo "Source: $MAIN_SCRIPT"
grep -n '^VERSION=' "$MAIN_SCRIPT" | head -1
