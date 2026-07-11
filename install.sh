#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Restarting installer with sudo..."
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/m" ]; then
    echo "ERROR: m file not found in $SCRIPT_DIR"
    exit 1
fi

bash -n "$SCRIPT_DIR/m"

mkdir -p /bin/mscript /usr/bin/mscript /usr/local/bin

install -m 755 "$SCRIPT_DIR/m" /bin/mscript/m
install -m 755 "$SCRIPT_DIR/m" /usr/bin/mscript/m

[ -f "$SCRIPT_DIR/Changelog" ] && install -m 644 "$SCRIPT_DIR/Changelog" /bin/mscript/Changelog
[ -f "$SCRIPT_DIR/version.txt" ] && install -m 644 "$SCRIPT_DIR/version.txt" /bin/mscript/version.txt
[ -f "$SCRIPT_DIR/README.md" ] && install -m 644 "$SCRIPT_DIR/README.md" /bin/mscript/README.md

ln -sf /bin/mscript/m /usr/local/bin/m
ln -sf /bin/mscript/m /usr/bin/m
ln -sf /bin/mscript/m /bin/m 2>/dev/null || true

chmod +x /bin/mscript/m /usr/bin/mscript/m

echo
echo "[OK] MOU Script installed"
grep -n "VERSION=" /bin/mscript/m | head -1
echo
echo "Run with: m"
