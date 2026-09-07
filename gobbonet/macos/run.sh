#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(/usr/bin/dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"
BIN="$ROOT_DIR/build/gobbonet"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gobbonet"
CONFIG="$CONFIG_DIR/config.toml"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/gobbonet"
LLAMA_SERVER="${LLAMA_SERVER:-/opt/homebrew/bin/llama-server}"

if [[ ! -x "$BIN" ]]; then
    "$ROOT_DIR/macos/build.sh"
fi

if [[ ! -f "$CONFIG" ]]; then
    "$BIN" serve --no-auth --host 127.0.0.1 || true
fi

if [[ ! -f "$DATA_DIR/setup-complete.json" ]]; then
    SETUP_ARGS=(setup --catalog "$ROOT_DIR/installer/models.ini")
    if [[ "${GOBBONET_NO_BROWSER:-}" == "1" ]]; then
        SETUP_ARGS+=(--no-browser)
    fi
    if [[ -x "$LLAMA_SERVER" ]]; then
        SETUP_ARGS+=(--server-exe "$LLAMA_SERVER")
    fi
    "$BIN" "${SETUP_ARGS[@]}"
fi

# GobboNet's Go server provides static files, state sync, reverse proxying,
# model metadata, jobs, and the native llama.cpp supervisor.
if [[ -x "$LLAMA_SERVER" ]]; then
    GOBBONET_SERVER_EXE="$LLAMA_SERVER" "$BIN" serve &
else
    "$BIN" serve &
fi
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM

for _ in {1..50}; do
    if /usr/bin/curl --silent --fail "http://127.0.0.1:9066/health-fileserver" >/dev/null; then
        break
    fi
    /bin/sleep 0.1
done

if [[ "${GOBBONET_NO_BROWSER:-}" != "1" ]]; then
    open "http://localhost:9066/chat.html"
fi
wait "$SERVER_PID"