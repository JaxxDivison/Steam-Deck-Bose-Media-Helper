#!/usr/bin/env bash
# User-level Bluetooth media-control bridge for Steam Deck / SteamOS.
# Does not disable SteamOS read-only protection or write to system directories.
set -euo pipefail

SERVICE_DIR="${HOME}/.config/systemd/user"
SERVICE_FILE="${SERVICE_DIR}/mpris-proxy.service"

usage() {
  cat <<'EOF'
Steam Deck Bose Media Helper

Usage:
  bash steamdeck-bose-media-helper.sh install
  bash steamdeck-bose-media-helper.sh status
  bash steamdeck-bose-media-helper.sh test
  bash steamdeck-bose-media-helper.sh uninstall

install  Create and enable a per-user mpris-proxy service.
status   Show service state and visible MPRIS players.
test     Show available media-control commands; does not change playback.
uninstall Stop and remove this helper service.
EOF
}

case "${1:-}" in
  install)
    if ! command -v mpris-proxy >/dev/null 2>&1; then
      echo "Couldn't find 'mpris-proxy' on this SteamOS installation."
      echo "No system files were changed."
      echo "Please send the output of: command -v mpris-proxy"
      echo "Do not disable SteamOS read-only protection to install it."
      exit 1
    fi
    mkdir -p "$SERVICE_DIR"
    cat > "$SERVICE_FILE" <<'EOF'
[Unit]
Description=Forward Bluetooth headset media controls to Linux media players
After=bluetooth.target

[Service]
Type=simple
ExecStart=/usr/bin/mpris-proxy
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
EOF
    # Use the actual path returned by command -v, in case SteamOS differs.
    PROXY_PATH="$(command -v mpris-proxy)"
    sed -i "s|^ExecStart=.*|ExecStart=${PROXY_PATH}|" "$SERVICE_FILE"
    systemctl --user daemon-reload
    systemctl --user enable --now mpris-proxy.service
    echo
    echo "Installed and started the user-level Bluetooth media bridge."
    echo "No SteamOS system files were changed."
    echo "Next: keep Chrome open on music.youtube.com, start playback, then test"
    echo "the Bose play/pause and skip controls in Gaming Mode."
    echo
    echo "Important: this bridge forwards supported Bluetooth media commands;"
    echo "it cannot invent a double-click gesture if the headphones don't send"
    echo "a Next Track command. Volume buttons may be handled directly by Bluetooth."
    ;;
  status)
    systemctl --user --no-pager --full status mpris-proxy.service || true
    echo
    echo "MPRIS services currently visible:"
    busctl --user list 2>/dev/null | grep -i 'org.mpris' || echo "No MPRIS services found."
    echo
    echo "mpris-proxy path: $(command -v mpris-proxy 2>/dev/null || echo 'not found')"
    ;;
  test)
    echo "This is a non-destructive check; it will not pause or skip music."
    echo
    echo "mpris-proxy: $(command -v mpris-proxy 2>/dev/null || echo 'not found')"
    echo "playerctl:   $(command -v playerctl 2>/dev/null || echo 'not installed')"
    echo
    busctl --user list 2>/dev/null | grep -i 'org.mpris' || echo "No MPRIS services found."
    ;;
  uninstall)
    systemctl --user disable --now mpris-proxy.service 2>/dev/null || true
    rm -f "$SERVICE_FILE"
    systemctl --user daemon-reload
    echo "Removed the user-level helper service. SteamOS system files were untouched."
    ;;
  *)
    usage
    exit 2
    ;;
esac
